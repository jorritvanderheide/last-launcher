package nl.bw20.last_launcher

import android.app.Activity
import android.content.pm.LauncherApps
import android.os.Build
import android.os.Bundle

/**
 * Accepts shortcuts that apps ask to pin to the home screen, such as a
 * browser's "Add to home screen". The request already came from the user
 * inside that app, so it's accepted without asking again; the shortcut then
 * shows up in the app drawer like any app.
 */
class PinShortcutActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val launcherApps = getSystemService(LauncherApps::class.java)
            val request = launcherApps?.getPinItemRequest(intent)
            if (request != null &&
                request.isValid &&
                request.requestType == LauncherApps.PinItemRequest.REQUEST_TYPE_SHORTCUT
            ) {
                request.accept()
            }
        }
        finish()
    }
}
