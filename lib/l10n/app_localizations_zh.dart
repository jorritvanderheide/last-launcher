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
  String get leftOfHome => '主畫面左側';

  @override
  String get rightOfHome => '主畫面右側';

  @override
  String get panelNone => '無';

  @override
  String get lockLayout => '鎖定版面';

  @override
  String get lockLayoutSubtitle => '停用釘選和主畫面的長按';

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
  String get taskScreen => '任務畫面';

  @override
  String get taskScreenSubtitle => '從主畫面向右滑動以查看任務';

  @override
  String get removeOnComplete => '完成後移除';

  @override
  String get removeOnCompleteSubtitle => '標記為完成後移除任務';

  @override
  String get clearCompletedDaily => '每日清除已完成';

  @override
  String get clearCompletedDailySubtitle => '在一天結束時移除已完成的任務';

  @override
  String get taskOptionDisabled => '啟用任務畫面以進行設定';

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
  String get hintSwipeUp => '向上滑動以搜尋';

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
  String get actionDone => '完成';

  @override
  String get actionUndo => '還原';

  @override
  String get actionRemove => '移除';

  @override
  String get actionClose => '關閉';

  @override
  String get actionAppInfo => '應用程式資訊';

  @override
  String get renameDialogTitle => '重新命名';

  @override
  String get renameDialogCancel => '取消';

  @override
  String get renameDialogSave => '儲存';

  @override
  String get homeScreenFull => '主畫面已滿';
}
