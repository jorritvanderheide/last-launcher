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
  String get appTagline => '你需要的最後一個啟動器';

  @override
  String get settings => '设置';

  @override
  String get sectionAppearance => '外观';

  @override
  String get sectionApps => '应用';

  @override
  String get sectionBehavior => '行为';

  @override
  String get sectionTasks => '任务';

  @override
  String get sectionSupport => '支持';

  @override
  String get sectionAbout => '关于';

  @override
  String get themeTitle => '主题';

  @override
  String get themeSystem => '系统';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get themeExtra => 'Extra';

  @override
  String get hideStatusBar => '全屏';

  @override
  String get hideStatusBarSubtitle => '隐藏状态栏和导航栏';

  @override
  String get showHints => '显示提示';

  @override
  String get showHintsSubtitle => '在整个应用中显示使用提示';

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
  String get searchOnlyMode => '仅搜索';

  @override
  String get searchOnlyModeSubtitle => '隐藏应用名称，搜索启动';

  @override
  String get autoShowKeyboard => '显示键盘';

  @override
  String get autoShowKeyboardAppsSubtitle => '打开抽屉时显示键盘';

  @override
  String get autoShowKeyboardTasksSubtitle => '打开任务时显示键盘';

  @override
  String get autoLaunchOnMatch => '匹配时自动启动';

  @override
  String get autoLaunchOnMatchSubtitle => '仅匹配一个应用时启动';

  @override
  String get taskScreen => '任务屏幕';

  @override
  String get taskScreenSubtitle => '从主屏幕向右滑动查看任务';

  @override
  String get removeOnComplete => '完成后移除';

  @override
  String get removeOnCompleteSubtitle => '标记完成后移除任务';

  @override
  String get donate => '捐赠';

  @override
  String get donateSubtitle => '支持 Last Launcher 的开发';

  @override
  String get version => '版本';

  @override
  String get license => '许可证';

  @override
  String get openSourceLicenses => '开源许可证';

  @override
  String get aboutSubtitle => '版本和许可证';

  @override
  String get hintSwipeUp => '向上滑动搜索';

  @override
  String get hintSwipeRight => '向右滑动查看任务';

  @override
  String get hintLongPress => '长按打开设置';

  @override
  String get noResults => '无结果';

  @override
  String get emptyTaskList => '输入以添加任务';

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
  String get actionDone => '完成';

  @override
  String get actionUndo => '撤销';

  @override
  String get actionRemove => '移除';

  @override
  String get actionClose => '关闭';

  @override
  String get actionAppInfo => '应用信息';

  @override
  String get renameDialogTitle => '重命名';

  @override
  String get renameDialogCancel => '取消';

  @override
  String get renameDialogSave => '保存';

  @override
  String get homeScreenFull => '主屏幕已满';
}
