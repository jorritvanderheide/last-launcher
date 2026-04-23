// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Last Launcher';

  @override
  String get appTagline => '마지막으로 필요한 런처';

  @override
  String get settings => '설정';

  @override
  String get sectionGeneral => '일반';

  @override
  String get sectionAppDrawer => '앱 서랍';

  @override
  String get sectionTasks => '할 일';

  @override
  String get sectionSupport => '지원';

  @override
  String get sectionAbout => '정보';

  @override
  String get themeTitle => '테마';

  @override
  String get themeSystem => '시스템';

  @override
  String get themeLight => '라이트';

  @override
  String get themeDark => '다크';

  @override
  String get themeExtra => 'Extra';

  @override
  String get hideStatusBar => '전체 화면';

  @override
  String get hideStatusBarSubtitle => '상태 표시줄과 내비게이션 숨기기';

  @override
  String get showHints => '힌트 표시';

  @override
  String get showHintsSubtitle => '앱 전체에서 사용 힌트 표시';

  @override
  String get hidePinnedApps => '고정된 앱 숨기기';

  @override
  String get hidePinnedAppsSubtitle => '앱 서랍에서 고정된 앱 숨기기';

  @override
  String get includeHiddenInSearch => '검색에 숨긴 앱 포함';

  @override
  String get includeHiddenInSearchSubtitle => '검색에서 숨긴 앱도 일치';

  @override
  String get matchOriginalName => '원래 이름으로 일치';

  @override
  String get matchOriginalNameSubtitle => '이름이 변경된 앱을 원래 이름으로 찾기';

  @override
  String get hiddenApps => '숨긴 앱';

  @override
  String get hiddenAppsNone => '없음';

  @override
  String hiddenAppsCount(int count) {
    return '$count개 숨김';
  }

  @override
  String get noHiddenApps => '숨긴 앱 없음';

  @override
  String get lockLayout => '레이아웃 잠금';

  @override
  String get lockLayoutSubtitle => '홈 및 할 일 화면의 길게 누르기 비활성화';

  @override
  String get searchOnlyMode => '검색 전용';

  @override
  String get searchOnlyModeSubtitle => '앱 이름을 숨기고 검색으로 실행';

  @override
  String get autoShowKeyboard => '키보드 표시';

  @override
  String get autoShowKeyboardAppsSubtitle => '서랍을 열 때 키보드 표시';

  @override
  String get autoShowKeyboardTasksSubtitle => '할 일을 열 때 키보드 표시';

  @override
  String get autoLaunchOnMatch => '일치 시 자동 실행';

  @override
  String get autoLaunchOnMatchSubtitle => '하나의 앱이 일치하면 실행';

  @override
  String get taskScreen => '할 일 화면';

  @override
  String get taskScreenSubtitle => '홈에서 오른쪽으로 스와이프하여 할 일 보기';

  @override
  String get removeOnComplete => '완료 시 제거';

  @override
  String get removeOnCompleteSubtitle => '완료된 할 일 제거';

  @override
  String get taskOptionDisabled => '작업 화면을 활성화하여 구성하세요';

  @override
  String get donate => '기부';

  @override
  String get donateSubtitle => 'Last Launcher 개발 지원';

  @override
  String get version => '버전';

  @override
  String get license => '라이선스';

  @override
  String get openSourceLicenses => '오픈소스 라이선스';

  @override
  String get aboutSubtitle => '버전 및 라이선스';

  @override
  String get hintSwipeUp => '위로 스와이프하여 검색';

  @override
  String get hintSwipeRight => '오른쪽으로 스와이프하여 할 일';

  @override
  String get hintLongPress => '길게 눌러 설정';

  @override
  String get noResults => '결과 없음';

  @override
  String get emptyTaskList => '입력하여 할 일 추가';

  @override
  String get returnToAddTask => 'Enter 키로 할 일 추가';

  @override
  String get actionRename => '이름 변경';

  @override
  String get actionUnpin => '고정 해제';

  @override
  String get actionPin => '고정';

  @override
  String get actionPinFull => '가득 참';

  @override
  String get actionHide => '숨기기';

  @override
  String get actionUnhide => '숨기기 해제';

  @override
  String get actionDone => '완료';

  @override
  String get actionUndo => '실행 취소';

  @override
  String get actionRemove => '제거';

  @override
  String get actionClose => '닫기';

  @override
  String get actionAppInfo => '앱 정보';

  @override
  String get renameDialogTitle => '이름 변경';

  @override
  String get renameDialogCancel => '취소';

  @override
  String get renameDialogSave => '저장';

  @override
  String get homeScreenFull => '홈 화면이 가득 찼습니다';
}
