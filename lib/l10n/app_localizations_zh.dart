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
  String get settings => '設定';

  @override
  String get sectionAppearance => '外觀';

  @override
  String get sectionHome => '主畫面';

  @override
  String get sectionAppDrawer => '應用程式抽屜';

  @override
  String get sectionTasks => '任務';

  @override
  String get sectionModules => '模組';

  @override
  String get sectionSupport => '支援';

  @override
  String get sectionAbout => '關於';

  @override
  String get sectionSearch => '搜索';

  @override
  String get sectionWork => '工作资料';

  @override
  String get themeTitle => '主題';

  @override
  String get themeSystem => '系統';

  @override
  String get themeLight => '淺色';

  @override
  String get themeDark => '深色';

  @override
  String get themeExtra => 'Extra';

  @override
  String get themeStyleTitle => '風格';

  @override
  String get themeStyleStandard => '標準';

  @override
  String get themeStyleCustom => '自訂';

  @override
  String get fontTitle => '字型';

  @override
  String get fontStandard => '標準';

  @override
  String get fontMono => '等寬';

  @override
  String get textSizeTitle => '文字大小';

  @override
  String get textSizeSmall => '小';

  @override
  String get textSizeMedium => '中';

  @override
  String get textSizeLarge => '大';

  @override
  String get textAlignTitle => '文字對齊';

  @override
  String get alignLeft => '靠左';

  @override
  String get alignCenter => '置中';

  @override
  String get alignRight => '靠右';

  @override
  String get accentColor => '強調色';

  @override
  String get accentColorSubtitle => '以系統強調色為文字與背景上色';

  @override
  String get terminalPrompt => '終端機提示字元';

  @override
  String get terminalPromptSubtitle => '將搜尋顯示為命令列';

  @override
  String get sectionEffects => '效果';

  @override
  String get effectsDarkOnly => '僅限深色模式';

  @override
  String get glow => '光暈';

  @override
  String get scanlines => '掃描線';

  @override
  String get scanlinesOff => '關閉';

  @override
  String get scanlinesLight => '輕微';

  @override
  String get scanlinesMedium => '中等';

  @override
  String get scanlinesStrong => '強烈';

  @override
  String get animations => '動畫';

  @override
  String get animationsSubtitle => '移動的掃描線、故障效果和閃爍游標';

  @override
  String get hideStatusBar => '全螢幕';

  @override
  String get hideStatusBarSubtitle => '隱藏狀態列和導覽列';

  @override
  String get showHints => '顯示提示';

  @override
  String get showHintsSubtitle => '在整個應用程式中顯示使用提示';

  @override
  String get hidePinnedApps => '隱藏已固定的應用程式';

  @override
  String get hidePinnedAppsSubtitle => '從應用程式抽屜中隱藏已固定的應用程式';

  @override
  String get includeHiddenInSearch => '在搜尋中包含隱藏項目';

  @override
  String get includeHiddenInSearchSubtitle => '讓搜尋也能找到已隱藏的應用程式';

  @override
  String get matchOriginalName => '比對原始名稱';

  @override
  String get matchOriginalNameSubtitle => '以原始名稱尋找已重新命名的應用程式';

  @override
  String get hiddenApps => '已隱藏的應用程式';

  @override
  String get hiddenAppsNone => '無';

  @override
  String hiddenAppsCount(int count) {
    return '已隱藏 $count 個';
  }

  @override
  String get noHiddenApps => '沒有已隱藏的應用程式';

  @override
  String get leftOfHome => '左側模組';

  @override
  String get rightOfHome => '右側模組';

  @override
  String get panelNone => '無';

  @override
  String get lockLayout => '鎖定版面';

  @override
  String get lockLayoutSubtitle => '停用釘選和主畫面的長按';

  @override
  String get doubleTapToSleep => '雙擊以休眠';

  @override
  String get doubleTapToSleepSubtitle => '需要系統設定中啟用輔助功能服務';

  @override
  String get doubleTapToSleepDialogTitle => 'Turn on accessibility service';

  @override
  String get doubleTapToSleepDialog =>
      'This uses the AccessibilityService API to lock the screen when you double-tap. It does nothing else. You will be redirected to system settings to turn it on.';

  @override
  String get doubleTapToSleepPrivacy =>
      'We do not collect, store, or share any personal or sensitive user data through the AccessibilityService API.';

  @override
  String get setAsDefault => '設為預設主畫面應用程式';

  @override
  String get setAsDefaultSubtitle => '開啟系統選擇器';

  @override
  String get drawerMode => '抽屜模式';

  @override
  String get drawerModeList => '清單';

  @override
  String get searchOnlyMode => '僅搜尋';

  @override
  String get searchOnlyModeSubtitle => '隱藏應用程式名稱，以搜尋開啟';

  @override
  String get autoShowKeyboard => '顯示鍵盤';

  @override
  String get autoShowKeyboardAppsSubtitle => '開啟抽屜時顯示鍵盤';

  @override
  String get autoShowKeyboardTasksSubtitle => '開啟任務時顯示鍵盤';

  @override
  String get autoLaunchOnMatch => '符合時自動開啟';

  @override
  String get autoLaunchOnMatchSubtitle => '當只有一個應用程式符合時自動開啟';

  @override
  String get quickLaunchHints => '快速啟動提示';

  @override
  String get quickLaunchHintsSubtitle => '突顯最短的唯一字元以啟動';

  @override
  String get extraChar => 'Extra character';

  @override
  String get extraCharSubtitle =>
      'Require an extra character before auto-launch';

  @override
  String get panelTasks => '任務';

  @override
  String get panelLaunchApp => '開啟應用程式';

  @override
  String get panelLaunchAppHint => '應用程式';

  @override
  String get launchAppLeft => '左側應用程式';

  @override
  String get launchAppRight => '右側應用程式';

  @override
  String get launchAppChoose => '選擇應用程式';

  @override
  String get launchAppOnlyLeft => '僅在設為左側模組時';

  @override
  String get launchAppOnlyRight => '僅在設為右側模組時';

  @override
  String get launchAppSearch => '搜尋應用程式';

  @override
  String get removeOnComplete => '完成後移除';

  @override
  String get removeOnCompleteSubtitle => '標記為完成後移除任務';

  @override
  String get clearCompletedDaily => '每日清除已完成';

  @override
  String get clearCompletedDailySubtitle => '在一天結束時移除已完成的任務';

  @override
  String get donate => '贊助';

  @override
  String get donateSubtitle => '支持 Last Launcher 的開發';

  @override
  String get rateApp => '評分 Last Launcher';

  @override
  String get rateAppSubtitle => '在 Play 商店留下評論';

  @override
  String get sendFeedback => '傳送意見';

  @override
  String get sendFeedbackSubtitle => '寄電子郵件給開發者';

  @override
  String get help => '說明';

  @override
  String get helpSubtitle => '檢視專案頁面';

  @override
  String get version => '版本';

  @override
  String get license => '授權條款';

  @override
  String get openSourceLicenses => '開放原始碼授權';

  @override
  String get aboutSubtitle => '版本與授權';

  @override
  String get backupTitle => '備份與還原';

  @override
  String get backupExport => '匯出備份';

  @override
  String get backupExportSubtitle => '將設定、名稱，以及隱藏和釘選的應用程式儲存到檔案';

  @override
  String get backupRestore => '還原備份';

  @override
  String get backupRestoreSubtitle => '以已儲存的備份取代全部內容';

  @override
  String get backupAlsoInclude => '一併包含';

  @override
  String get backupRestoreConfirm => '這會取代目前的設定、名稱，以及隱藏和釘選的應用程式。';

  @override
  String get backupExportAction => '匯出';

  @override
  String get backupRestoreAction => '還原';

  @override
  String get backupSaved => '已儲存備份';

  @override
  String get backupRestored => '已還原備份';

  @override
  String get backupInvalid => '此檔案不是 Last Launcher 備份';

  @override
  String get backupTooNew => '此備份來自較新版本的 Last Launcher';

  @override
  String get backupFailed => '無法讀取或寫入檔案';

  @override
  String get hintSwipeUp => '向上滑動：應用程式';

  @override
  String hintSwipeRightFor(String module) {
    return '向右滑動：$module';
  }

  @override
  String hintSwipeLeftFor(String module) {
    return '向左滑動：$module';
  }

  @override
  String get hintLongPress => '長按以開啟設定';

  @override
  String get noResults => '沒有結果';

  @override
  String get emptyTaskList => '輸入以新增任務';

  @override
  String get returnToAddTask => '按 Enter 鍵以新增任務';

  @override
  String get actionRename => '重新命名';

  @override
  String get actionUnpin => '取消固定';

  @override
  String get actionPin => '固定';

  @override
  String get actionPinFull => '已滿';

  @override
  String get actionHide => '隱藏';

  @override
  String get actionUnhide => '取消隱藏';

  @override
  String get actionRemove => '移除';

  @override
  String get actionClose => '關閉';

  @override
  String get actionAppInfo => '應用程式資訊';

  @override
  String get actionEnable => '啟用';

  @override
  String get renameDialogTitle => '重新命名';

  @override
  String get renameDialogCancel => '取消';

  @override
  String get renameDialogSave => '儲存';

  @override
  String get showWorkAppDot => '显示工作资料点';

  @override
  String get showWorkAppDotSubtitle => '在工作资料应用前显示一个小点';

  @override
  String get showWorkAppDotOnHome => '在主屏幕上显示工作资料点';

  @override
  String get showWorkAppDotOnHomeSubtitle => '在固定的主屏幕应用上显示工作资料点';

  @override
  String get hidePersonalWhenWorkActive => '不显示非工作应用';

  @override
  String get hidePersonalWhenWorkActiveSubtitle => '非工作应用将在工作资料暂停时重新显示';

  @override
  String get homeScreenFull => '主畫面已滿';
}
