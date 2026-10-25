package nl.bw20.last_launcher

import android.app.Activity
import android.app.AlertDialog
import android.content.pm.LauncherApps
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle

/**
 * Asks before accepting a shortcut an app wants to pin, such as a browser's
 * "Add to home screen". An app can ask without you doing anything in it, so
 * the launcher checks with you, as Android expects; an accepted shortcut
 * shows up in the app drawer like any app.
 */
class PinShortcutActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            finish()
            return
        }
        val launcherApps = getSystemService(LauncherApps::class.java)
        val request = launcherApps?.getPinItemRequest(intent)
        val shortcut = request?.shortcutInfo
        if (request == null ||
            !request.isValid ||
            request.requestType != LauncherApps.PinItemRequest.REQUEST_TYPE_SHORTCUT ||
            shortcut == null
        ) {
            finish()
            return
        }
        val label = shortcut.shortLabel ?: shortcut.longLabel ?: shortcut.id
        AlertDialog.Builder(this, android.R.style.Theme_DeviceDefault_Dialog_Alert)
            .setTitle(R.string.pin_shortcut_title)
            .setMessage(getString(R.string.pin_shortcut_message, label, appName(shortcut.`package`)))
            .setPositiveButton(R.string.pin_shortcut_add) { _, _ ->
                if (request.isValid) request.accept()
            }
            .setNegativeButton(android.R.string.cancel, null)
            .setOnDismissListener { finish() }
            .show()
    }

    private fun appName(packageName: String): CharSequence = try {
        packageManager.getApplicationLabel(packageManager.getApplicationInfo(packageName, 0))
    } catch (e: PackageManager.NameNotFoundException) {
        packageName
    }
}
