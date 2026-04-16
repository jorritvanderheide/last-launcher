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
  String get sectionApps => 'アプリ';

  @override
  String get sectionBehavior => '動作';

  @override
  String get sectionTasks => 'タスク';

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
  String get taskScreen => 'タスク画面';

  @override
  String get taskScreenSubtitle => 'ホームから右にスワイプしてタスクを表示';

  @override
  String get removeOnComplete => '完了時に削除';

  @override
  String get removeOnCompleteSubtitle => '完了したタスクを削除';

  @override
  String get donate => '寄付';

  @override
  String get donateSubtitle => 'Last Launcherの開発を支援';

  @override
  String get version => 'バージョン';

  @override
  String get license => 'ライセンス';

  @override
  String get openSourceLicenses => 'オープンソースライセンス';

  @override
  String get aboutSubtitle => 'バージョンとライセンス';

  @override
  String get hintSwipeUp => '上にスワイプして検索';

  @override
  String get hintSwipeRight => '右にスワイプしてタスク';

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
