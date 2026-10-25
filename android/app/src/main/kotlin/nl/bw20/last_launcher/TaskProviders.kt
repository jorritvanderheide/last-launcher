package nl.bw20.last_launcher

import android.content.ContentValues
import android.content.Context
import android.content.pm.PackageManager
import android.database.ContentObserver
import android.net.Uri
import android.os.Handler
import android.os.Looper

/**
 * The task lists of a tasks app with an OpenTasks provider, which DAVx⁵
 * syncs with a CalDAV server. The launcher reads and writes the tasks of one
 * list there, and nothing else; the syncing is the other apps' business.
 *
 * Columns and paths are OpenTasks' TaskContract; authorities and permissions
 * are the ones DAVx⁵ uses (ical4android's TaskProvider.ProviderName).
 */
class TaskProviders(private val context: Context) {
    class Provider(
        val authority: String,
        val packageName: String,
        val readPermission: String,
        val writePermission: String,
    ) {
        val permissions get() = arrayOf(readPermission, writePermission)
        val listsUri: Uri get() = Uri.parse("content://$authority/tasklists")
        val tasksUri: Uri get() = Uri.parse("content://$authority/tasks")
    }

    /** A provider gone, or a permission taken back. */
    class Unavailable(message: String) : Exception(message)

    private var observer: ContentObserver? = null

    fun provider(authority: String): Provider =
        all.firstOrNull { it.authority == authority }
            ?: throw IllegalArgumentException("Unknown task provider $authority")

    fun isGranted(provider: Provider): Boolean = provider.permissions.all {
        context.checkSelfPermission(it) == PackageManager.PERMISSION_GRANTED
    }

    /** The task apps that are installed: their authority, name and whether
     * the launcher may use them. */
    fun installed(): List<Map<String, Any>> = all.mapNotNull { provider ->
        context.packageManager.resolveContentProvider(provider.authority, 0)
            ?: return@mapNotNull null
        val label = try {
            val info = context.packageManager.getApplicationInfo(provider.packageName, 0)
            context.packageManager.getApplicationLabel(info).toString()
        } catch (e: PackageManager.NameNotFoundException) {
            provider.packageName
        }
        mapOf(
            "authority" to provider.authority,
            "label" to label,
            "granted" to isGranted(provider),
        )
    }

    fun lists(authority: String): List<Map<String, Any?>> {
        val provider = provider(authority)
        val cursor = query(provider.listsUri, arrayOf("_id", "list_name", "account_name"), null, null)
        return cursor.use {
            buildList {
                while (it.moveToNext()) {
                    add(
                        mapOf(
                            "id" to it.getLong(0).toString(),
                            "name" to it.getString(1),
                            "account" to it.getString(2),
                        ),
                    )
                }
            }
        }
    }

    fun tasks(authority: String, listId: String): List<Map<String, Any?>> {
        val provider = provider(authority)
        val cursor = query(
            provider.tasksUri,
            arrayOf("_id", "title", "status", "parent_id", "created", "rrule"),
            // Left out: an occurrence of a repeating task changed on its own,
            // which would show it twice.
            "list_id = ? AND _deleted = 0 AND original_instance_id IS NULL",
            arrayOf(listId),
        )
        return cursor.use {
            buildList {
                while (it.moveToNext()) {
                    add(
                        mapOf(
                            "id" to it.getLong(0).toString(),
                            "title" to (it.getString(1) ?: ""),
                            "status" to (if (it.isNull(2)) 0 else it.getInt(2)),
                            "parentId" to (if (it.isNull(3)) null else it.getLong(3).toString()),
                            "created" to (if (it.isNull(4)) 0L else it.getLong(4)),
                            "repeats" to !it.isNull(5),
                        ),
                    )
                }
            }
        }
    }

    /**
     * Applies [changes] in order: maps with an "op" of insert, update or
     * delete. An insert names a temporary id, which later changes may use as
     * a parent; the answer maps each temporary id to the one it got.
     */
    fun apply(authority: String, listId: String, changes: List<Map<String, Any?>>): Map<String, String> {
        val provider = provider(authority)
        val resolver = context.contentResolver
        val ids = mutableMapOf<String, String>()
        fun real(id: String?) = id?.let { ids[it] ?: it }
        try {
            for (change in changes) {
                val id = change["id"] as String
                val values = ContentValues()
                if (change.containsKey("title")) values.put("title", change["title"] as String)
                if (change.containsKey("done")) {
                    // NEEDS_ACTION or COMPLETED; the provider sets the
                    // completion time itself.
                    values.put("status", if (change["done"] as Boolean) 2 else 0)
                }
                if (change.containsKey("parentId")) {
                    val parent = real(change["parentId"] as String?)
                    if (parent == null) values.putNull("parent_id") else values.put("parent_id", parent.toLong())
                }
                when (change["op"]) {
                    "insert" -> {
                        values.put("list_id", listId.toLong())
                        val uri = resolver.insert(provider.tasksUri, values)
                            ?: throw Unavailable("Insert failed")
                        ids[id] = uri.lastPathSegment ?: throw Unavailable("Insert failed")
                    }
                    "update" -> resolver.update(taskUri(provider, real(id)!!), values, null, null)
                    "delete" -> resolver.delete(taskUri(provider, real(id)!!), null, null)
                }
            }
        } catch (e: SecurityException) {
            throw Unavailable(e.message ?: "No permission")
        }
        return ids
    }

    /** Calls [notify] whenever the tasks at [authority] change, from here
     * or elsewhere; null stops watching. */
    fun watch(authority: String?, notify: () -> Unit) {
        observer?.let { context.contentResolver.unregisterContentObserver(it) }
        observer = null
        if (authority == null) return
        val watching = object : ContentObserver(Handler(Looper.getMainLooper())) {
            override fun onChange(selfChange: Boolean) = notify()
        }
        try {
            context.contentResolver.registerContentObserver(provider(authority).tasksUri, true, watching)
            observer = watching
        } catch (e: SecurityException) {
            // Without the permission there's nothing to watch yet.
        }
    }

    private fun taskUri(provider: Provider, id: String) =
        Uri.withAppendedPath(provider.tasksUri, id)

    private fun query(uri: Uri, columns: Array<String>, selection: String?, args: Array<String>?) =
        try {
            context.contentResolver.query(uri, columns, selection, args, null)
        } catch (e: SecurityException) {
            throw Unavailable(e.message ?: "No permission")
        } ?: throw Unavailable("No provider at $uri")

    companion object {
        val all = listOf(
            Provider(
                "org.tasks.opentasks",
                "org.tasks",
                "org.tasks.permission.READ_TASKS",
                "org.tasks.permission.WRITE_TASKS",
            ),
            Provider(
                "org.dmfs.tasks",
                "org.dmfs.tasks",
                "org.dmfs.permission.READ_TASKS",
                "org.dmfs.permission.WRITE_TASKS",
            ),
        )
    }
}
