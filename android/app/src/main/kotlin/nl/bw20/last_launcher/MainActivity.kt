package nl.bw20.last_launcher

import android.content.Intent
import android.content.pm.ResolveInfo
import android.net.Uri
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channel = "nl.bw20.last_launcher/apps"
    private var methodChannel: MethodChannel? = null
    private var pendingOpenSettings = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "getInstalledApps" -> result.success(getInstalledApps())
                "expandQuickSettings" -> {
                    expandQuickSettings()
                    result.success(null)
                }
                "launchApp" -> {
                    val packageName = call.argument<String>("packageName")
                    if (packageName != null) {
                        launchApp(packageName)
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
                "consumePendingOpenSettings" -> {
                    val consumed = pendingOpenSettings
                    pendingOpenSettings = false
                    result.success(consumed)
                }
                else -> result.notImplemented()
            }
        }

        // Capture any cold-start pending action for Flutter to consume.
        if (intent?.action == Intent.ACTION_APPLICATION_PREFERENCES) {
            pendingOpenSettings = true
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
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

    private fun getInstalledApps(): List<Map<String, String>> {
        val intent = Intent(Intent.ACTION_MAIN).apply {
            addCategory(Intent.CATEGORY_LAUNCHER)
        }
        val activities: List<ResolveInfo> =
            packageManager.queryIntentActivities(intent, 0)

        return activities
            .filter { it.activityInfo.packageName != packageName }
            .map { resolveInfo ->
                mapOf(
                    "packageName" to resolveInfo.activityInfo.packageName,
                    "label" to resolveInfo.loadLabel(packageManager).toString(),
                )
            }
    }

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

    private fun launchApp(targetPackageName: String) {
        val intent = packageManager.getLaunchIntentForPackage(targetPackageName)
        if (intent != null) {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
            @Suppress("DEPRECATION")
            overridePendingTransition(0, 0)
        }
    }

    private fun openAppInfo(targetPackageName: String) {
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
            data = Uri.fromParts("package", targetPackageName, null)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        startActivity(intent)
    }
}
