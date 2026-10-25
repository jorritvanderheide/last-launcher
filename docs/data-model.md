# Data model

Last Launcher keeps everything in SharedPreferences: one key per setting, and
JSON in a string for anything longer, such as the pinned apps or the tasks.
Nothing is in a database or a file of its own, and nothing is kept anywhere
but the phone. This page lists every key it reads and writes.

## Where it is

Android keeps the keys in the app's private storage, in
`shared_prefs/FlutterSharedPreferences.xml`, each with `flutter.` before its
name. Other apps can't read it, Android's backup to the cloud is off for it
(`allowBackup="false"`), and uninstalling removes it. Backup & restore is the
way to move it (see [Backups](#backups)).

Every key belongs to one state, which reads it at start and writes it on
every change: `SettingsState`, `HomeState`, `AppListState` or `TaskState`
(see [Architecture](architecture.md#where-state-lives)).

## App keys

Pins, custom names, hidden apps and the Launch app module refer to an app by
its key, from `AppInfo.keyFor`:

```
<package>|<work>                 an app: com.example.mail|false
<package>|<work>|<shortcut id>   a shortcut another app pinned
```

`<work>` is `true` for the work profile's copy of an app, and `false`
otherwise. Labels and hidden apps from before work profiles have the package
alone, and are read as `<package>|false`.

## Settings

One key each, declared in `SettingsState` with its type and default.
**Setting** is the name on the settings screen.

| Key | Type | Default | Setting |
| --- | --- | --- | --- |
| `theme_mode` | `system`, `light`, `dark` | `system` | Theme |
| `font` | `standard`, `mono` | `standard` | Font |
| `text_size` | number, 18 to 38 in steps of 2 | 28 | Text size |
| `accent_color` | bool | false | Accent color |
| `terminal_prompt` | bool | false | Terminal prompt |
| `glow` | bool | false | Glow |
| `scanlines` | `off`, `light`, `medium`, `strong` | `off` | Scanlines |
| `animations` | bool | true | Animations |
| `hide_status_bar` | bool | false | Fullscreen |
| `show_hints` | bool | true | Show hints |
| `locked` | bool | false | Lock layout |
| `double_tap_to_sleep` | bool | true | Double tap to sleep |
| `label_alignment` | `left`, `center`, `right` | `left` | Alignment |
| `left_panel`, `right_panel` | `none`, `tasks`, `launch_app` | `none` | Left module, Right module |
| `search_only` | bool | false | Drawer mode: Search only when true, List when false |
| `hide_pinned_from_drawer` | bool | true | Hide pinned apps |
| `include_hidden_in_search` | bool | false | Include hidden in search |
| `match_original_name` | bool | true | Match original name |
| `auto_keyboard` | bool | true | Show keyboard, in App drawer |
| `auto_launch` | bool | true | Auto-launch on match |
| `extra_char` | bool | false | Extra character |
| `quick_launch_hints` | bool | false | Quick launch hints |
| `search_prefixes` | JSON | see [Search prefixes](#search-prefixes) | Search prefixes |
| `hide_personal_when_work_active` | bool | false | Don't show non-work apps |
| `show_work_app_dot` | bool | true | Show work app dot |
| `show_work_app_dot_on_home` | bool | false | Show work dot on home screen |
| `launch_app_left`, `launch_app_right` | app key | none | Left app, Right app |
| `auto_keyboard_tasks` | bool | true | Show keyboard, in Tasks |
| `remove_on_complete` | bool | false | Remove on complete |
| `clear_completed_daily` | bool | false | Clear completed daily |
| `task_source` | `<authority>/<list id>` | none: this phone | Tasks from (see [The synced task list](#the-synced-task-list)) |
| `delete_synced_done` | bool | false | Delete done tasks everywhere |

Choices are stored by name. A key that's missing, or holds a value of another
type or a name this release doesn't know, reads as its default. A number
outside its range is read as the nearest one inside it. Some settings
only apply while another allows them, such as Extra character with
Auto-launch on match; those rules are worked out when read, and never change
what's stored.

## Pinned apps

`pinned_apps`: the apps on the home screen, in their order, as a JSON list.

| Key | Value |
| --- | --- |
| `packageName` | The app's package |
| `label` | Its name when it was pinned; a custom name is in `custom_labels` |
| `isWorkApp` | `true` for the work profile's copy; left out otherwise |
| `shortcutId` | For a shortcut, its id; left out for an app |

## Custom names and hidden apps

- `custom_labels`: a JSON object from app key to the name you gave it.
- `hidden_apps`: a JSON list of app keys.

What's pinned, named or hidden for an app that's no longer installed is
dropped when the app list is read again. A work app's are kept while the
work profile is paused, since its apps are only away.

## Search prefixes

`search_prefixes`: a JSON list, in the order they're tried. Missing means the
defaults, `.` for work apps and a space for personal ones; an empty list
means you removed them all.

| Key | Value |
| --- | --- |
| `trigger` | What you type first, such as `g ` |
| `name` | The name to show; empty means a description of the action |
| `enabled` | Whether it's on |
| `action` | What it does: one of the objects below |

| `type` | Other keys | What it does |
| --- | --- | --- |
| `filter` | `work`: bool | Searches only work apps, or only personal ones |
| `link` | `template`: a link with `%s` for the search; `openWith`: a package, or left out for Android's choice | Opens the link |
| `appSearch` | `package` | Hands the search to that app's own search |

A prefix whose `type` this release doesn't know, from a newer one, is
skipped; the others still work.

## Tasks

`tasks`: the task list on the phone, as a JSON list in the order it's shown,
done or not.

| Key | Value |
| --- | --- |
| `id` | Made from the time it was added; never changes |
| `title` | The task |
| `done` | Whether it's ticked off; left out means false |
| `indented` | Whether it's a subtask of the nearest task above it that isn't; left out, or anything but `true`, means not |

The first task is never a subtask, whatever it says. `tasks_last_clear_date`
(`YYYY-MM-DD`) is the day Clear completed daily last ran. It removes done
tasks with their subtasks, except a done task that still has open ones,
which only another app can leave behind: without it they'd become subtasks
of whatever is above.

`tasks` and `tasks_last_clear_date` belong to the Tasks module (its
`storageKeys`), so a backup can leave them out.

## The synced task list

With a list from Tasks.org or OpenTasks under Tasks from, the tasks stay in
that app. `task_source` names the list: the app's provider authority
(`org.tasks.opentasks` or `org.dmfs.tasks`), a slash, and the list's id
there. `synced_task_view` holds what the launcher adds to each list it has
shown, as a JSON object from `task_source` to:

| Key | Value |
| --- | --- |
| `order` | The tasks' ids, in the order they're shown |
| `hidden` | Ids of done tasks that are hidden here instead of deleted. One that still has open subtasks stays in view |

A list without one, read for the first time, starts with the tasks already
done there hidden. Clear completed daily, even with Delete done tasks
everywhere, only ever deletes done tasks that are shown, never hidden ones.

Both hold the tasks app's ids on this phone, so neither is ever backed up,
and a restore leaves them alone.

In the tasks app, through its OpenTasks provider, the launcher reads the
`tasklists` table's `_id`, `list_name` and `account_name`, and the `tasks`
table's `_id`, `title`, `status`, `parent_id`, `created` and `rrule` for the
chosen list, leaving out a changed copy of one occurrence of a repeating task
(`original_instance_id` set). It writes `title`, `status` (0 to do, 2
completed), `parent_id` and, for a new task, `list_id`, and deletes tasks. A completed or cancelled task
(status 2 or 3) is done; a task nested deeper than one level is shown under
its top-most task. A task with an `rrule` repeats, and is ticked off in the
tasks app, never here.

## Backups

A backup is a JSON file, written by `Backup` in
`lib/features/settings/backup.dart`:

```json
{
  "format": "last-launcher-backup",
  "version": 1,
  "modules": ["tasks"],
  "prefs": {
    "locked": { "type": "bool", "value": false },
    "pinned_apps": { "type": "string", "value": "[...]" }
  }
}
```

| Key | Value |
| --- | --- |
| `format` | Always `last-launcher-backup` |
| `version` | The backup format, `1` |
| `modules` | The modules whose own data is in it, such as `tasks` |
| `prefs` | Every stored key, with its type (`bool`, `int`, `double`, `string` or `strings`) and value |

Every key is in it, so a setting added later is backed up without anyone
having to remember it, except three: `task_source` and `synced_task_view`,
and `tasks_enabled` from older versions. A restore replaces everything else,
and a module's data only if it's in the backup and you chose to restore it.

## Older keys

Values from older versions are rewritten by `SettingsState._migrate` before
anything reads them:

- **`tasks_enabled`**, from before either side of home could be chosen:
  `true` sets `left_panel` to `tasks`, if neither side was chosen yet.
- **`theme_mode` `extra`**, from when Extra was a theme (before 1.3.0):
  becomes dark mode with the Extra options (mono font, glow, medium
  scanlines, terminal prompt and animations).
- **`text_size`** as `small`, `medium` or `large`, and **`theme_style`**,
  from development builds.

## Compatibility

What a release may change in these keys, and how a value from an older one is
read, is in [Compatibility](compatibility.md).
