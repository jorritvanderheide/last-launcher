// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Last Launcher';

  @override
  String get appTagline => '你需要的最后一个启动器';

  @override
  String get settings => '设置';

  @override
  String get sectionAppearance => '外观';

  @override
  String get sectionHome => '主屏幕';

  @override
  String get sectionAppDrawer => '应用抽屉';

  @override
  String get sectionTasks => '任务';

  @override
  String get sectionSupport => '支持';

  @override
  String get sectionAbout => '关于';

  @override
  String get sectionSearch => '搜索';

  @override
  String get sectionWork => '工作资料';

  @override
  String get themeTitle => '主题';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get themeExtra => '扩展';

  @override
  String get themeStyleTitle => '样式';

  @override
  String get themeStyleStandard => '标准';

  @override
  String get themeStyleCustom => '自定义';

  @override
  String get fontTitle => '字体';

  @override
  String get fontStandard => '标准';

  @override
  String get fontMono => '等宽';

  @override
  String get textSizeTitle => '文字大小';

  @override
  String get alignmentTitle => '对齐方式';

  @override
  String get alignLeft => '左对齐';

  @override
  String get alignCenter => '居中';

  @override
  String get alignRight => '右对齐';

  @override
  String get accentColor => '强调色';

  @override
  String get accentColorSubtitle => '用系统强调色为文字和背景着色';

  @override
  String get terminalPrompt => '终端提示符';

  @override
  String get terminalPromptSubtitle => '将搜索显示为命令行';

  @override
  String get sectionEffects => '效果';

  @override
  String get effectsDarkOnly => '仅限深色模式';

  @override
  String get glow => '发光';

  @override
  String get scanlines => '扫描线';

  @override
  String get scanlinesOff => '关闭';

  @override
  String get scanlinesLight => '轻';

  @override
  String get scanlinesMedium => '中';

  @override
  String get scanlinesStrong => '强';

  @override
  String get animations => '动画';

  @override
  String get animationsSubtitle => '移动的扫描线、故障效果和闪烁的光标';

  @override
  String get hideStatusBar => '全屏';

  @override
  String get hideStatusBarSubtitle => '隐藏状态栏和导航栏';

  @override
  String get showHints => '显示提示';

  @override
  String get showHintsSubtitle => '在应用各处显示使用提示';

  @override
  String get hidePinnedApps => '隐藏已固定的应用';

  @override
  String get hidePinnedAppsSubtitle => '在应用抽屉中隐藏已固定的应用';

  @override
  String get includeHiddenInSearch => '搜索包含隐藏应用';

  @override
  String get includeHiddenInSearchSubtitle => '让搜索也能匹配隐藏的应用';

  @override
  String get matchOriginalName => '匹配原始名称';

  @override
  String get matchOriginalNameSubtitle => '用原始名称查找已重命名的应用';

  @override
  String get hiddenApps => '隐藏的应用';

  @override
  String get hiddenAppsNone => '无';

  @override
  String hiddenAppsCount(int count) {
    return '已隐藏 $count 个';
  }

  @override
  String get noHiddenApps => '没有隐藏的应用';

  @override
  String get leftOfHome => '左侧模块';

  @override
  String get rightOfHome => '右侧模块';

  @override
  String get panelNone => '无';

  @override
  String get lockLayout => '锁定布局';

  @override
  String get lockLayoutSubtitle => '禁用主屏幕上的固定和长按';

  @override
  String get doubleTapToSleep => '双击休眠';

  @override
  String get doubleTapToSleepSubtitle => '需要在系统设置中启用无障碍服务';

  @override
  String get doubleTapToSleepDialogTitle => '开启无障碍服务';

  @override
  String get doubleTapToSleepDialog =>
      '这会使用 AccessibilityService API，在你双击时锁定屏幕，不做任何其他事情。你将被带到系统设置中开启它。';

  @override
  String get setAsDefault => '设为默认主屏幕应用';

  @override
  String get setAsDefaultSubtitle => '打开系统选择器';

  @override
  String get drawerMode => '抽屉模式';

  @override
  String get drawerModeList => '列表';

  @override
  String get searchOnlyMode => '仅搜索';

  @override
  String get prefixNoApp => '没有应用可以打开它';

  @override
  String get prefixTypeWork => '工作应用';

  @override
  String get prefixTypePersonal => '个人应用';

  @override
  String get searchPrefixes => '搜索前缀';

  @override
  String get searchPrefixesSubtitle => '从搜索栏搜索网页或应用';

  @override
  String get prefixAdd => '添加前缀';

  @override
  String get prefixRestoreDefaults => '恢复工作和个人前缀';

  @override
  String get prefixTrigger => '前缀';

  @override
  String prefixTriggerShownAs(String trigger) {
    return '显示为 $trigger';
  }

  @override
  String get prefixShadowWarning => '开启此项时，以这些字母开头的应用将无法被找到。请以空格结尾，或以符号开头。';

  @override
  String get prefixName => '名称';

  @override
  String get prefixType => '操作';

  @override
  String get prefixTypeLink => '打开链接';

  @override
  String get prefixTypeSearchInApp => '在应用中搜索';

  @override
  String get prefixTemplates => '从模板开始';

  @override
  String get prefixLink => '链接';

  @override
  String get prefixLinkHelp => '%s 是搜索内容的位置';

  @override
  String get prefixOpenWith => '打开方式';

  @override
  String get prefixAnyApp => '任意应用';

  @override
  String get prefixApp => '应用';

  @override
  String get prefixNoSearchApps => '没有应用提供自己的搜索';

  @override
  String get prefixPersonalAppsOnly => '此处不能使用工作资料中的应用';

  @override
  String get prefixErrorEmpty => '请输入前缀';

  @override
  String get prefixErrorTaken => '已有其他前缀在使用它';

  @override
  String get prefixErrorNoPlaceholder => '请把 %s 放在搜索内容的位置';

  @override
  String get prefixTemplateMaps => '地图';

  @override
  String get autoShowKeyboard => '显示键盘';

  @override
  String get autoShowKeyboardAppsSubtitle => '打开抽屉时弹出键盘';

  @override
  String get autoShowKeyboardTasksSubtitle => '打开任务时弹出键盘';

  @override
  String get autoLaunchOnMatch => '匹配时自动启动';

  @override
  String get autoLaunchOnMatchSubtitle => '只有一个应用匹配时直接启动';

  @override
  String get quickLaunchHints => '快速启动提示';

  @override
  String get quickLaunchHintsSubtitle => '高亮可唯一确定应用的最短字符';

  @override
  String get extraChar => '额外字符';

  @override
  String get extraCharSubtitle => '自动启动前需要多输入一个字符';

  @override
  String get panelTasks => '任务';

  @override
  String get panelLaunchApp => '启动应用';

  @override
  String get panelLaunchAppHint => '一个应用';

  @override
  String get launchAppLeft => '左侧应用';

  @override
  String get launchAppRight => '右侧应用';

  @override
  String get launchAppChoose => '选择一个应用';

  @override
  String get launchAppOnlyLeft => '仅当此项为左侧模块时';

  @override
  String get launchAppOnlyRight => '仅当此项为右侧模块时';

  @override
  String get removeOnComplete => '完成后移除';

  @override
  String get removeOnCompleteSubtitle => '标记为完成时移除任务';

  @override
  String get clearCompletedDaily => '每日清除已完成';

  @override
  String get clearCompletedDailySubtitle => '在每天结束时移除已完成的任务';

  @override
  String get donate => '捐赠';

  @override
  String get donateSubtitle => '支持 Last Launcher 的开发';

  @override
  String get rateApp => '为 Last Launcher 评分';

  @override
  String get rateAppSubtitle => '在 Play 商店留下评价';

  @override
  String get sendFeedback => '发送反馈';

  @override
  String get sendFeedbackSubtitle => '给开发者发送邮件';

  @override
  String get help => '帮助';

  @override
  String get helpSubtitle => '常见问题解答';

  @override
  String get version => '版本';

  @override
  String get license => '许可证';

  @override
  String get openSourceLicenses => '开源许可';

  @override
  String get aboutSubtitle => '版本和许可证';

  @override
  String get backupTitle => '备份与恢复';

  @override
  String get backupExport => '导出备份';

  @override
  String get backupExportSubtitle => '将设置、标签、隐藏和固定的应用保存到文件';

  @override
  String get backupRestore => '恢复备份';

  @override
  String get backupRestoreSubtitle => '用已保存的备份替换所有内容';

  @override
  String get backupAlsoInclude => '同时包含';

  @override
  String get backupRestoreConfirm => '这将替换当前的设置、标签、隐藏和固定的应用。';

  @override
  String get backupExportAction => '导出';

  @override
  String get backupRestoreAction => '恢复';

  @override
  String get backupSaved => '备份已保存';

  @override
  String get backupRestored => '备份已恢复';

  @override
  String get backupInvalid => '此文件不是 Last Launcher 备份';

  @override
  String get backupTooNew => '此备份来自更新版本的 Last Launcher';

  @override
  String get backupFailed => '无法读取或写入文件';

  @override
  String get hintSwipeUp => '上滑打开应用';

  @override
  String hintSwipeRightFor(String module) {
    return '向右滑动进入$module';
  }

  @override
  String hintSwipeLeftFor(String module) {
    return '向左滑动进入$module';
  }

  @override
  String get hintLongPress => '长按打开设置';

  @override
  String get noResults => '无结果';

  @override
  String get emptyTaskList => '输入文字以添加任务';

  @override
  String get returnToAddTask => '按回车键添加任务';

  @override
  String get actionRename => '重命名';

  @override
  String get actionUnpin => '取消固定';

  @override
  String get actionPin => '固定';

  @override
  String get actionPinFull => '已满';

  @override
  String get actionHide => '隐藏';

  @override
  String get actionUnhide => '取消隐藏';

  @override
  String get actionRemove => '移除';

  @override
  String get actionMakeSubtask => '设为子任务';

  @override
  String get actionMakeMainTask => '设为主任务';

  @override
  String get actionClose => '关闭';

  @override
  String get actionAppInfo => '应用信息';

  @override
  String get actionEnable => '启用';

  @override
  String get renameDialogTitle => '重命名';

  @override
  String get renameDialogCancel => '取消';

  @override
  String get renameDialogSave => '保存';

  @override
  String get showWorkAppDot => '显示工作应用圆点';

  @override
  String get showWorkAppDotSubtitle => '在工作资料应用前显示一个小圆点';

  @override
  String get showWorkAppDotOnHome => '在主屏幕显示工作圆点';

  @override
  String get showWorkAppDotOnHomeSubtitle => '在主屏幕已固定的应用上显示工作资料圆点';

  @override
  String get hidePersonalWhenWorkActive => '不显示非工作应用';

  @override
  String get hidePersonalWhenWorkActiveSubtitle => '工作资料暂停时，非工作应用会重新出现';

  @override
  String get homeScreenFull => '主屏幕已满';

  @override
  String get taskSourceTitle => '任务来源';

  @override
  String get taskSourcePhone => '此手机';

  @override
  String taskSourceList(String list, String app) {
    return '$app 中的 $list';
  }

  @override
  String get taskSourceNoApp => '要使用与 DAVx⁵ 同步的任务列表，请先安装 Tasks.org。';

  @override
  String taskSourceNoLists(String app) {
    return '$app 中还没有列表，请先在那里添加一个。';
  }

  @override
  String get deleteSyncedDone => '在所有位置删除已完成任务';

  @override
  String deleteSyncedDoneSubtitle(String app) {
    return '“完成后移除”和“每日清除已完成”会将它们从 $app 以及与其同步的所有设备中删除。关闭此项时，它们只在此处被隐藏。';
  }

  @override
  String taskSyncNoPermission(String app) {
    return 'Last Launcher 可能无法读取你在 $app 中的任务。点按以允许。';
  }

  @override
  String taskSyncAppMissing(String app) {
    return '未安装 $app。点按以选择任务的来源。';
  }

  @override
  String taskSyncListGone(String app) {
    return '此列表已不在 $app 中。点按以选择另一个。';
  }

  @override
  String taskSyncFailed(String app) {
    return '无法从 $app 读取你的任务。点按重试。';
  }

  @override
  String taskSyncNotSaved(String app) {
    return '$app 没有接受你最近的更改。点按查看任务在那里的当前状态。';
  }

  @override
  String taskSourceApp(String app) {
    return '$app 中的列表';
  }

  @override
  String taskRepeats(String app) {
    return '重复任务。请在 $app 中勾选完成。';
  }
}
