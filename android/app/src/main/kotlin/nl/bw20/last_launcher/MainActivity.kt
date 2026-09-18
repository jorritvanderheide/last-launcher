package nl.bw20.last_launcher

import android.app.Activity
import android.app.SearchManager
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.content.pm.LauncherApps
import android.graphics.Color
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Process
import android.os.UserHandle
import android.os.UserManager
import android.provider.Settings
import android.view.View
import android.view.WindowInsets
import android.view.WindowManager
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channel = "nl.bw20.last_launcher/apps"
    private var methodChannel: MethodChannel? = null
    private var pendingOpenSettings = false
    private var fullscreenEnabled = false

    // The file picker answers through onActivityResult; this is who's waiting.
    private var pendingBackupResult: MethodChannel.Result? = null
    private var pendingBackupContent: String? = null

    // ------------------------------------------------------------------
    // Lifecycle
    // ------------------------------------------------------------------

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Window theme already sets windowTranslucentStatus / windowTranslucentNavigation.
        // Combined with FLAG_LAYOUT_NO_LIMITS the window owns the bar regions visually,
        // so there is no transient reveal or contrast scrim when bars are hidden.
        @Suppress("DEPRECATION")
        window.addFlags(WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            window.isStatusBarContrastEnforced = false
            window.isNavigationBarContrastEnforced = false
        }
        @Suppress("DEPRECATION")
        window.statusBarColor = Color.TRANSPARENT
        @Suppress("DEPRECATION")
        window.navigationBarColor = Color.TRANSPARENT
        // Re-hide system bars whenever they reappear (soft IME dismiss, OEM
        // overlays, etc). Predictive back is disabled at the manifest level
        // so the back gesture never reveals bars to begin with.
        //
        // Skipped while the IME is showing: the keyboard brings the navigation
        // bar back with it, and changing window flags mid-IME-animation puts
        // this listener in the middle of the app drawer's keyboard handling
        // (see SearchFocusController) for no visible gain. The bars are hidden
        // again by the same listener once the IME goes away.
        ViewCompat.setOnApplyWindowInsetsListener(window.decorView) { v, insets ->
            if (fullscreenEnabled &&
                !isFinishing &&
                insets.isVisible(WindowInsetsCompat.Type.systemBars()) &&
                !insets.isVisible(WindowInsetsCompat.Type.ime())
            ) {
                v.post { if (!isFinishing) applyFullscreen() }
            }
            insets
        }
    }

    override fun onResume() {
        super.onResume()
        applyFullscreen()
    }

    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        if (hasFocus) applyFullscreen()
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        // Pressing home while this launcher is already the foreground task
        // arrives here rather than starting anything, so it is our only cue
        // that the user asked to be taken back to the home page.
        if (intent.action == Intent.ACTION_MAIN &&
            intent.hasCategory(Intent.CATEGORY_HOME)
        ) {
            methodChannel?.invokeMethod("goHome", null)
            return
        }
        if (intent.action == Intent.ACTION_APPLICATION_PREFERENCES) {
            // Set a fallback flag in case Flutter's handler isn't attached yet;
            // clear it once Dart acknowledges the direct invoke.
            pendingOpenSettings = true
            methodChannel?.invokeMethod(
                "openSettings",
                null,
                object : MethodChannel.Result {
                    override fun success(result: Any?) {
                        pendingOpenSettings = false
                    }
                    override fun error(code: String, msg: String?, details: Any?) {}
                    override fun notImplemented() {}
                },
            )
        }
    }

    // ------------------------------------------------------------------
    // Flutter MethodChannel
    // ------------------------------------------------------------------

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "getInstalledApps" -> result.success(getInstalledApps())
                "launchApp" -> {
                    val packageName = call.argument<String>("packageName")
                    val useWorkProfile = call.argument<Boolean>("isWorkApp") ?: false
                    val shortcutId = call.argument<String>("shortcutId")
                    if (packageName != null) {
                        if (shortcutId != null) {
                            launchShortcut(packageName, shortcutId, useWorkProfile)
                        } else {
                            launchApp(packageName, useWorkProfile)
                        }
                        result.success(null)
                    } else {
                        result.error("INVALID_ARGUMENT", "packageName is required", null)
                    }
                }
                "openAppInfo" -> {
                    val packageName = call.argument<String>("packageName")
                    if (packageName != null) {
                        try {
                            openAppInfo(packageName)
                            result.success(null)
                        } catch (e: Exception) {
                            result.error(
                                "OPEN_APP_INFO_FAILED",
                                e.message ?: "Unable to open app info",
                                null,
                            )
                        }
                    } else {
                        result.error("INVALID_ARGUMENT", "packageName is required", null)
                    }
                }
                "expandQuickSettings" -> {
                    expandQuickSettings()
                    result.success(null)
                }
                "consumePendingOpenSettings" -> {
                    val consumed = pendingOpenSettings
                    pendingOpenSettings = false
                    result.success(consumed)
                }
                "setFullscreen" -> {
                    val enabled = call.argument<Boolean>("enabled") ?: false
                    setFullscreen(enabled)
                    result.success(null)
                }
                "lockScreen" -> {
                    val locked = LockAccessibilityService.instance?.lockScreen() ?: false
                    result.success(locked)
                }
                "openAccessibilitySettings" -> {
                    if (LockAccessibilityService.instance == null) {
                        val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
                        startActivity(intent)
                    }
                    result.success(null)
                }
                "isAccessibilityServiceEnabled" -> {
                    result.success(LockAccessibilityService.instance != null)
                }
                "hasWorkProfile" -> {
                    val userManager = getSystemService(Context.USER_SERVICE) as UserManager?
                    val profiles = userManager?.userProfiles ?: listOf(Process.myUserHandle())
                    result.success(profiles.any { it != Process.myUserHandle() })
                }
                "getAccentColors" -> result.success(accentColors())
                "openLink" -> {
                    val uri = call.argument<String>("uri")
                    if (uri == null) {
                        result.error("INVALID_ARGUMENT", "uri is required", null)
                    } else {
                        result.success(openLink(uri, call.argument<String>("package")))
                    }
                }
                "searchInApp" -> {
                    val pkg = call.argument<String>("package")
                    val query = call.argument<String>("query")
                    if (pkg == null || query == null) {
                        result.error("INVALID_ARGUMENT", "package and query are required", null)
                    } else {
                        result.success(searchInApp(pkg, query))
                    }
                }
                "removeShortcut" -> {
                    val packageName = call.argument<String>("packageName")
                    val shortcutId = call.argument<String>("shortcutId")
                    val isWork = call.argument<Boolean>("isWorkApp") ?: false
                    if (packageName != null && shortcutId != null) {
                        removeShortcut(packageName, shortcutId, isWork)
                        result.success(null)
                    } else {
                        result.error("INVALID_ARGUMENT", "packageName and shortcutId are required", null)
                    }
                }
                "saveBackup" -> {
                    val fileName = call.argument<String>("fileName")
                    val content = call.argument<String>("content")
                    if (fileName == null || content == null) {
                        result.error("INVALID_ARGUMENT", "fileName and content are required", null)
                    } else {
                        saveBackup(fileName, content, result)
                    }
                }
                "openBackup" -> openBackup(result)
                "isDefaultLauncher" -> result.success(isDefaultLauncher())
                "requestDefaultLauncher" -> {
                    requestDefaultLauncher()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }

        // Capture any cold-start pending action for Flutter to consume.
        if (intent?.action == Intent.ACTION_APPLICATION_PREFERENCES) {
            pendingOpenSettings = true
        }
    }

    // ------------------------------------------------------------------
    // Fullscreen
    // ------------------------------------------------------------------

    private fun setFullscreen(enabled: Boolean) {
        fullscreenEnabled = enabled
        runOnUiThread { applyFullscreen() }
    }

    private fun applyFullscreen() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            val controller = window.insetsController ?: return
            if (fullscreenEnabled) {
                controller.hide(WindowInsets.Type.systemBars())
            } else {
                controller.show(WindowInsets.Type.systemBars())
            }
        } else {
            @Suppress("DEPRECATION")
            window.decorView.systemUiVisibility = if (fullscreenEnabled) {
                View.SYSTEM_UI_FLAG_IMMERSIVE or
                    View.SYSTEM_UI_FLAG_FULLSCREEN or
                    View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
            } else {
                0
            }
        }
    }

    // ------------------------------------------------------------------
    // App listing / launching
    // ------------------------------------------------------------------

    private fun getInstalledApps(): List<Map<String, Any?>> {
        val launcherApps = getSystemService(Context.LAUNCHER_APPS_SERVICE) as LauncherApps?
        val userManager = getSystemService(Context.USER_SERVICE) as UserManager?
        val profiles = userManager?.userProfiles ?: listOf(Process.myUserHandle())
        val currentUser = Process.myUserHandle()
        val result = mutableListOf<Map<String, Any?>>()

        for (profile in profiles) {
            if (launcherApps == null) continue
            val isWork = profile != currentUser
            if (isWork && Build.VERSION.SDK_INT >= Build.VERSION_CODES.N &&
                userManager?.isQuietModeEnabled(profile) == true) continue
            val activities = launcherApps.getActivityList(null, profile)
            for (activity in activities) {
                val packageName = activity.applicationInfo.packageName
                if (packageName == this.packageName) continue
                result.add(
                    mapOf(
                        "packageName" to packageName,
                        "label" to (activity.label?.toString() ?: ""),
                        "isWorkApp" to isWork,
                    ),
                )
            }
            result.addAll(pinnedShortcuts(launcherApps, profile, isWork))
        }
        return result
    }

    // ------------------------------------------------------------------
    // Pinned shortcuts (installed web apps, website shortcuts, ...)
    // ------------------------------------------------------------------

    /**
     * Shortcuts pinned to this launcher, listed like apps. Only the default
     * launcher may read them, so this is empty until it is one.
     */
    private fun pinnedShortcuts(
        launcherApps: LauncherApps,
        profile: UserHandle,
        isWork: Boolean,
    ): List<Map<String, Any?>> {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N_MR1) return emptyList()
        if (!launcherApps.hasShortcutHostPermission()) return emptyList()
        val query = LauncherApps.ShortcutQuery()
            .setQueryFlags(LauncherApps.ShortcutQuery.FLAG_MATCH_PINNED)
        val shortcuts = try {
            launcherApps.getShortcuts(query, profile)
        } catch (_: Exception) {
            // A locked profile or a lost default-launcher role.
            null
        } ?: return emptyList()
        return shortcuts.mapNotNull { shortcut ->
            if (!shortcut.isEnabled) return@mapNotNull null
            val label = (shortcut.shortLabel ?: shortcut.longLabel)?.toString()
            if (label.isNullOrBlank()) return@mapNotNull null
            mapOf(
                "packageName" to shortcut.`package`,
                "label" to label,
                "isWorkApp" to isWork,
                "shortcutId" to shortcut.id,
            )
        }
    }

    private fun launchShortcut(packageName: String, shortcutId: String, isWork: Boolean) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N_MR1) return
        val launcherApps = getSystemService(Context.LAUNCHER_APPS_SERVICE) as LauncherApps? ?: return
        val user = profileFor(isWork) ?: return
        try {
            launcherApps.startShortcut(packageName, shortcutId, null, null, user)
        } catch (_: Exception) {
            // The shortcut was disabled or removed by its app since listing.
        }
    }

    /** Unpins one shortcut: pinning is per package, so re-pin the others. */
    private fun removeShortcut(packageName: String, shortcutId: String, isWork: Boolean) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N_MR1) return
        val launcherApps = getSystemService(Context.LAUNCHER_APPS_SERVICE) as LauncherApps? ?: return
        if (!launcherApps.hasShortcutHostPermission()) return
        val user = profileFor(isWork) ?: return
        val query = LauncherApps.ShortcutQuery()
            .setPackage(packageName)
            .setQueryFlags(LauncherApps.ShortcutQuery.FLAG_MATCH_PINNED)
        try {
            val remaining = launcherApps.getShortcuts(query, user)
                ?.map { it.id }
                ?.filter { it != shortcutId }
                ?: return
            launcherApps.pinShortcuts(packageName, remaining, user)
        } catch (_: Exception) {
            // Nothing to unpin if the profile is locked or the role was lost.
        }
    }

    private fun profileFor(isWork: Boolean): UserHandle? {
        val currentUser = Process.myUserHandle()
        if (!isWork) return currentUser
        val userManager = getSystemService(Context.USER_SERVICE) as UserManager? ?: return null
        return userManager.userProfiles.firstOrNull { it != currentUser }
    }

    private fun launchApp(targetPackageName: String, useWorkProfile: Boolean) {
        if (useWorkProfile) {
            val launcherApps = getSystemService(Context.LAUNCHER_APPS_SERVICE) as LauncherApps?
            if (launcherApps == null) return
            val userManager = getSystemService(Context.USER_SERVICE) as UserManager?
            val profiles = userManager?.userProfiles ?: return
            for (profile in profiles) {
                if (profile == Process.myUserHandle()) continue
                val activityList = launcherApps.getActivityList(targetPackageName, profile)
                if (activityList.isNotEmpty()) {
                    launcherApps.startMainActivity(
                        activityList[0].componentName,
                        profile,
                        null,
                        null,
                    )
                    return
                }
            }
            return
        }
        // Personal profile
        val intent = packageManager.getLaunchIntentForPackage(targetPackageName)
        if (intent != null) {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
            @Suppress("DEPRECATION")
            overridePendingTransition(0, 0)
            return
        }
        // Work-only fallback for pinned apps (which lack isWorkApp)
        val launcherApps = getSystemService(Context.LAUNCHER_APPS_SERVICE) as LauncherApps?
        if (launcherApps == null) return
        val userManager = getSystemService(Context.USER_SERVICE) as UserManager?
        val profiles = userManager?.userProfiles ?: return
        for (profile in profiles) {
            if (profile == Process.myUserHandle()) continue
            val activityList = launcherApps.getActivityList(targetPackageName, profile)
            if (activityList.isNotEmpty()) {
                launcherApps.startMainActivity(
                    activityList[0].componentName,
                    profile,
                    null,
                    null,
                )
                return
            }
        }
    }

    private fun openAppInfo(targetPackageName: String) {
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
            data = Uri.fromParts("package", targetPackageName, null)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        startActivity(intent)
    }

    // ------------------------------------------------------------------
    // Backup files
    // ------------------------------------------------------------------

    // Through the system file picker, so no storage permission is needed.

    private fun saveBackup(fileName: String, content: String, result: MethodChannel.Result) {
        if (!claimBackupResult(result)) return
        pendingBackupContent = content
        val intent = Intent(Intent.ACTION_CREATE_DOCUMENT)
            .addCategory(Intent.CATEGORY_OPENABLE)
            .setType("application/json")
            .putExtra(Intent.EXTRA_TITLE, fileName)
        @Suppress("DEPRECATION")
        startActivityForResult(intent, REQUEST_SAVE_BACKUP)
    }

    private fun openBackup(result: MethodChannel.Result) {
        if (!claimBackupResult(result)) return
        // Some file managers label .json files as plain text or generic data.
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT)
            .addCategory(Intent.CATEGORY_OPENABLE)
            .setType("*/*")
            .putExtra(
                Intent.EXTRA_MIME_TYPES,
                arrayOf("application/json", "text/plain", "application/octet-stream"),
            )
        @Suppress("DEPRECATION")
        startActivityForResult(intent, REQUEST_OPEN_BACKUP)
    }

    private fun claimBackupResult(result: MethodChannel.Result): Boolean {
        if (pendingBackupResult != null) {
            result.error("BUSY", "A file picker is already open", null)
            return false
        }
        pendingBackupResult = result
        return true
    }

    @Deprecated("Deprecated in Java")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        @Suppress("DEPRECATION")
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != REQUEST_SAVE_BACKUP && requestCode != REQUEST_OPEN_BACKUP) return
        val result = pendingBackupResult ?: return
        val content = pendingBackupContent
        pendingBackupResult = null
        pendingBackupContent = null

        val uri = data?.data
        if (resultCode != Activity.RESULT_OK || uri == null) {
            // Cancelled: saving reports false, opening reports no file.
            result.success(if (requestCode == REQUEST_SAVE_BACKUP) false else null)
            return
        }
        try {
            if (requestCode == REQUEST_SAVE_BACKUP) {
                val stream = contentResolver.openOutputStream(uri, "wt")
                    ?: throw java.io.IOException("Could not open $uri for writing")
                stream.use { it.write(content!!.toByteArray(Charsets.UTF_8)) }
                result.success(true)
            } else {
                val stream = contentResolver.openInputStream(uri)
                    ?: throw java.io.IOException("Could not open $uri for reading")
                result.success(stream.use { it.readBytes().toString(Charsets.UTF_8) })
            }
        } catch (e: Exception) {
            result.error("FILE_FAILED", e.message ?: "File access failed", null)
        }
    }

    // ------------------------------------------------------------------
    // Search prefix actions
    // ------------------------------------------------------------------

    /** Opens [uri] like any link, in [pkg] if given. False if nothing can. */
    private fun openLink(uri: String, pkg: String?): Boolean {
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(uri))
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        if (pkg != null) intent.setPackage(pkg)
        return startIfPossible(intent)
    }

    /** Hands [query] to [pkg]'s own search. False if it has none. */
    private fun searchInApp(pkg: String, query: String): Boolean {
        val intent = Intent(Intent.ACTION_SEARCH)
            .setPackage(pkg)
            .putExtra(SearchManager.QUERY, query)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        return startIfPossible(intent)
    }

    private fun startIfPossible(intent: Intent): Boolean = try {
        startActivity(intent)
        true
    } catch (_: ActivityNotFoundException) {
        false
    } catch (_: SecurityException) {
        false
    }

    // ------------------------------------------------------------------
    // Accent colours
    // ------------------------------------------------------------------

    /**
     * The system's Material You accent in the tones the launcher draws with:
     * text on dark and on light backgrounds, and a mid tone to tint the
     * backgrounds themselves. Null before Android 12, which has no accent.
     */
    private fun accentColors(): Map<String, Long>? {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) return null
        // Masked so ARGB arrives in Dart as a positive int, as Color expects.
        fun tone(id: Int) = getColor(id).toLong() and 0xFFFFFFFFL
        return mapOf(
            "onDark" to tone(android.R.color.system_accent1_200),
            "onLight" to tone(android.R.color.system_accent1_700),
            "tint" to tone(android.R.color.system_accent1_500),
        )
    }

    // ------------------------------------------------------------------
    // Default-launcher role
    // ------------------------------------------------------------------

    private fun isDefaultLauncher(): Boolean {
        val intent = Intent(Intent.ACTION_MAIN).apply {
            addCategory(Intent.CATEGORY_HOME)
        }
        val resolved = packageManager.resolveActivity(intent, 0) ?: return false
        return resolved.activityInfo.packageName == packageName
    }

    private fun requestDefaultLauncher() {
        // ROLE_HOME is declared requestable=false in the platform role config,
        // so RoleManager.createRequestRoleIntent(ROLE_HOME) opens an activity
        // that finishes immediately. ACTION_HOME_SETTINGS reliably opens the
        // system "Default home app" picker on every Android version.
        val intent = Intent(Settings.ACTION_HOME_SETTINGS)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        try {
            startActivity(intent)
        } catch (_: Exception) {
            // No-op if the device exposes no home-app settings screen.
        }
    }

    // ------------------------------------------------------------------
    // Quick settings (notification panel)
    // ------------------------------------------------------------------

    @Suppress("WrongConstant")
    private fun expandQuickSettings() {
        val statusBarService = getSystemService("statusbar") ?: return
        val clazz = statusBarService.javaClass

        try {
            clazz.getMethod("expandNotificationsPanel").invoke(statusBarService)
        } catch (_: Exception) {
            // Silently fail
        }
    }

    private companion object {
        const val REQUEST_SAVE_BACKUP = 4001
        const val REQUEST_OPEN_BACKUP = 4002
    }
}
