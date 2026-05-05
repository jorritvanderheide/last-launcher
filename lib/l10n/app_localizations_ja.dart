// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Last Launcher';

  @override
  String get appTagline => 'これが最後のランチャー';

  @override
  String get settings => '設定';

  @override
  String get sectionAppearance => '外観';

  @override
  String get sectionHome => 'ホーム';

  @override
  String get sectionAppDrawer => 'アプリドロワー';

  @override
  String get sectionTasks => 'タスク';

  @override
  String get sectionModules => 'モジュール';

  @override
  String get sectionSupport => 'サポート';

  @override
  String get sectionAbout => '概要';

  @override
  String get themeTitle => 'テーマ';

  @override
  String get themeSystem => 'システム';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get themeExtra => 'Extra';

  @override
  String get hideStatusBar => 'フルスクリーン';

  @override
  String get hideStatusBarSubtitle => 'ステータスバーとナビゲーションを非表示';

  @override
  String get showHints => 'ヒントを表示';

  @override
  String get showHintsSubtitle => 'アプリ全体で使用ヒントを表示';

  @override
  String get hidePinnedApps => '固定したアプリを非表示';

  @override
  String get hidePinnedAppsSubtitle => '固定したアプリをアプリドロワーから隠す';

  @override
  String get includeHiddenInSearch => '非表示アプリも検索対象';

  @override
  String get includeHiddenInSearchSubtitle => '検索で非表示のアプリも一致させる';

  @override
  String get matchOriginalName => '元の名前と一致';

  @override
  String get matchOriginalNameSubtitle => '名前を変更したアプリを元の名前で検索できる';

  @override
  String get hiddenApps => '非表示のアプリ';

  @override
  String get hiddenAppsNone => 'なし';

  @override
  String hiddenAppsCount(int count) {
    return '$count件非表示';
  }

  @override
  String get noHiddenApps => '非表示のアプリはありません';

  @override
  String get leftOfHome => 'ホームの左';

  @override
  String get rightOfHome => 'ホームの右';

  @override
  String get panelNone => 'なし';

  @override
  String get lockLayout => 'レイアウトをロック';

  @override
  String get lockLayoutSubtitle => 'ピン留めとホーム画面の長押しを無効化';

  @override
  String get searchOnlyMode => '検索のみ';

  @override
  String get searchOnlyModeSubtitle => 'アプリ名を非表示にし、検索で起動';

  @override
  String get autoShowKeyboard => 'キーボードを表示';

  @override
  String get autoShowKeyboardAppsSubtitle => 'ドロワーを開いたときにキーボードを表示';

  @override
  String get autoShowKeyboardTasksSubtitle => 'タスクを開いたときにキーボードを表示';

  @override
  String get autoLaunchOnMatch => '一致時に自動起動';

  @override
  String get autoLaunchOnMatchSubtitle => '一つのアプリが一致したら起動';

  @override
  String get panelTasks => 'タスク';

  @override
  String get removeOnComplete => '完了時に削除';

  @override
  String get removeOnCompleteSubtitle => '完了したタスクを削除';

  @override
  String get clearCompletedDaily => '完了タスクを毎日クリア';

  @override
  String get clearCompletedDailySubtitle => '1日の終わりに完了タスクを削除';

  @override
  String get taskOptionDisabled => '設定するにはタスク画面を有効にしてください';

  @override
  String get donate => '寄付';

  @override
  String get donateSubtitle => 'Last Launcherの開発を支援';

  @override
  String get rateApp => 'Last Launcherを評価';

  @override
  String get rateAppSubtitle => 'Playストアでレビューを残す';

  @override
  String get sendFeedback => 'フィードバックを送信';

  @override
  String get sendFeedbackSubtitle => '開発者にメールを送る';

  @override
  String get help => 'ヘルプ';

  @override
  String get helpSubtitle => 'プロジェクトページを表示';

  @override
  String get version => 'バージョン';

  @override
  String get license => 'ライセンス';

  @override
  String get openSourceLicenses => 'オープンソースライセンス';

  @override
  String get aboutSubtitle => 'バージョンとライセンス';

  @override
  String get hintSwipeUp => '上にスワイプでアプリ';

  @override
  String hintSwipeRightFor(String module) {
    return '右にスワイプで$module';
  }

  @override
  String hintSwipeLeftFor(String module) {
    return '左にスワイプで$module';
  }

  @override
  String get hintLongPress => '長押しで設定';

  @override
  String get noResults => '結果なし';

  @override
  String get emptyTaskList => '入力してタスクを追加';

  @override
  String get returnToAddTask => 'Enterキーでタスクを追加';

  @override
  String get actionRename => '名前変更';

  @override
  String get actionUnpin => 'ピン解除';

  @override
  String get actionPin => 'ピン留め';

  @override
  String get actionPinFull => '満杯';

  @override
  String get actionHide => '非表示';

  @override
  String get actionUnhide => '再表示';

  @override
  String get actionDone => '完了';

  @override
  String get actionUndo => '元に戻す';

  @override
  String get actionRemove => '削除';

  @override
  String get actionClose => '閉じる';

  @override
  String get actionAppInfo => 'アプリ情報';

  @override
  String get renameDialogTitle => '名前変更';

  @override
  String get renameDialogCancel => 'キャンセル';

  @override
  String get renameDialogSave => '保存';

  @override
  String get homeScreenFull => 'ホーム画面がいっぱいです';
}
