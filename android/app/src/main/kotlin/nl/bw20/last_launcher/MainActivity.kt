package nl.bw20.last_launcher

import android.content.Intent
import android.content.pm.ResolveInfo
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channel = "nl.bw20.last_launcher/apps"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
            .setMethodCallHandler { call, result ->
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
                    else -> result.notImplemented()
                }
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
            .sortedBy { it["label"]?.lowercase() }
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
        }
    }
}
