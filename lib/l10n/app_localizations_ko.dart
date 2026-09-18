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
  String get sectionAppearance => '외관';

  @override
  String get sectionHome => '홈';

  @override
  String get sectionAppDrawer => '앱 서랍';

  @override
  String get sectionTasks => '할 일';

  @override
  String get sectionSupport => '지원';

  @override
  String get sectionAbout => '정보';

  @override
  String get sectionSearch => '검색';

  @override
  String get sectionWork => '업무 프로필';

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
  String get themeStyleTitle => '스타일';

  @override
  String get themeStyleStandard => '기본';

  @override
  String get themeStyleCustom => '사용자 지정';

  @override
  String get fontTitle => '글꼴';

  @override
  String get fontStandard => '기본';

  @override
  String get fontMono => '고정폭';

  @override
  String get textSizeTitle => '글자 크기';

  @override
  String get textAlignTitle => '텍스트 정렬';

  @override
  String get alignLeft => '왼쪽';

  @override
  String get alignCenter => '가운데';

  @override
  String get alignRight => '오른쪽';

  @override
  String get accentColor => '강조 색상';

  @override
  String get accentColorSubtitle => '텍스트와 배경에 시스템 강조 색상 적용';

  @override
  String get terminalPrompt => '터미널 프롬프트';

  @override
  String get terminalPromptSubtitle => '검색을 명령줄처럼 표시';

  @override
  String get sectionEffects => '효과';

  @override
  String get effectsDarkOnly => '다크 모드에서만';

  @override
  String get glow => '글로우';

  @override
  String get scanlines => '주사선';

  @override
  String get scanlinesOff => '끔';

  @override
  String get scanlinesLight => '약하게';

  @override
  String get scanlinesMedium => '보통';

  @override
  String get scanlinesStrong => '강하게';

  @override
  String get animations => '애니메이션';

  @override
  String get animationsSubtitle => '움직이는 주사선, 글리치, 깜빡이는 커서';

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
  String get leftOfHome => '왼쪽 모듈';

  @override
  String get rightOfHome => '오른쪽 모듈';

  @override
  String get panelNone => '없음';

  @override
  String get lockLayout => '레이아웃 잠금';

  @override
  String get lockLayoutSubtitle => '고정 및 홈 화면의 길게 누르기 비활성화';

  @override
  String get doubleTapToSleep => '두 번 탭하여 절전';

  @override
  String get doubleTapToSleepSubtitle => '시스템 설정에서 접근성 서비스를 활성화해야 합니다';

  @override
  String get doubleTapToSleepDialogTitle => 'Turn on accessibility service';

  @override
  String get doubleTapToSleepDialog =>
      'This uses the AccessibilityService API to lock the screen when you double-tap. It does nothing else. You will be redirected to system settings to turn it on.';

  @override
  String get setAsDefault => '기본 홈 앱으로 설정';

  @override
  String get setAsDefaultSubtitle => '시스템 선택기 열기';

  @override
  String get drawerMode => '서랍 모드';

  @override
  String get drawerModeList => '목록';

  @override
  String get searchOnlyMode => '검색 전용';

  @override
  String get prefixNoApp => '열 수 있는 앱이 없습니다';

  @override
  String get prefixTypeWork => '업무용 앱';

  @override
  String get prefixTypePersonal => '개인 앱';

  @override
  String get searchPrefixes => '검색 접두어';

  @override
  String get searchPrefixesSubtitle => '검색창에서 웹 또는 앱 검색';

  @override
  String get prefixAdd => '접두어 추가';

  @override
  String get prefixRestoreDefaults => '업무용 및 개인 접두어 복원';

  @override
  String get prefixTrigger => '접두어';

  @override
  String prefixTriggerShownAs(String trigger) {
    return '$trigger(으)로 표시';
  }

  @override
  String get prefixShadowWarning =>
      '켜져 있는 동안 이 글자로 시작하는 앱을 찾을 수 없습니다. 끝에 공백을 넣거나 기호로 시작하세요.';

  @override
  String get prefixName => '이름';

  @override
  String get prefixType => '동작';

  @override
  String get prefixTypeLink => '링크 열기';

  @override
  String get prefixTypeSearchInApp => '앱에서 검색';

  @override
  String get prefixTemplates => '템플릿';

  @override
  String get prefixLink => '링크';

  @override
  String get prefixLinkHelp => '%s 자리에 검색어가 들어갑니다';

  @override
  String get prefixOpenWith => '열 앱';

  @override
  String get prefixAnyApp => '모든 앱';

  @override
  String get prefixApp => '앱';

  @override
  String get prefixNoSearchApps => '자체 검색을 제공하는 앱이 없습니다';

  @override
  String get prefixPersonalAppsOnly => '업무 프로필의 앱은 여기서 사용할 수 없습니다';

  @override
  String get prefixErrorEmpty => '접두어를 입력하세요';

  @override
  String get prefixErrorTaken => '다른 접두어가 이미 사용 중입니다';

  @override
  String get prefixErrorNoPlaceholder => '검색어 자리에 %s를 넣으세요';

  @override
  String get prefixTemplateMaps => '지도';

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
  String get quickLaunchHints => '빠른 실행 힌트';

  @override
  String get quickLaunchHintsSubtitle => '실행할 가장 짧은 고유 문자 강조';

  @override
  String get extraChar => 'Extra character';

  @override
  String get extraCharSubtitle =>
      'Require an extra character before auto-launch';

  @override
  String get panelTasks => '할 일';

  @override
  String get panelLaunchApp => '앱 실행';

  @override
  String get panelLaunchAppHint => '앱';

  @override
  String get launchAppLeft => '왼쪽 앱';

  @override
  String get launchAppRight => '오른쪽 앱';

  @override
  String get launchAppChoose => '앱 선택';

  @override
  String get launchAppOnlyLeft => '왼쪽 모듈로 설정된 경우에만';

  @override
  String get launchAppOnlyRight => '오른쪽 모듈로 설정된 경우에만';

  @override
  String get removeOnComplete => '완료 시 제거';

  @override
  String get removeOnCompleteSubtitle => '완료된 할 일 제거';

  @override
  String get clearCompletedDaily => '완료 항목 매일 비우기';

  @override
  String get clearCompletedDailySubtitle => '하루가 끝날 때 완료된 할 일 제거';

  @override
  String get donate => '기부';

  @override
  String get donateSubtitle => 'Last Launcher 개발 지원';

  @override
  String get rateApp => 'Last Launcher 평가';

  @override
  String get rateAppSubtitle => 'Play 스토어에 리뷰 남기기';

  @override
  String get sendFeedback => '피드백 보내기';

  @override
  String get sendFeedbackSubtitle => '개발자에게 이메일 보내기';

  @override
  String get help => '도움말';

  @override
  String get helpSubtitle => '프로젝트 페이지 보기';

  @override
  String get version => '버전';

  @override
  String get license => '라이선스';

  @override
  String get openSourceLicenses => '오픈소스 라이선스';

  @override
  String get aboutSubtitle => '버전 및 라이선스';

  @override
  String get backupTitle => '백업 및 복원';

  @override
  String get backupExport => '백업 내보내기';

  @override
  String get backupExportSubtitle => '설정, 이름, 숨긴 앱과 고정한 앱을 파일로 저장';

  @override
  String get backupRestore => '백업 복원';

  @override
  String get backupRestoreSubtitle => '저장된 백업으로 모두 대체';

  @override
  String get backupAlsoInclude => '함께 포함';

  @override
  String get backupRestoreConfirm => '현재 설정, 이름, 숨긴 앱과 고정한 앱이 대체됩니다.';

  @override
  String get backupExportAction => '내보내기';

  @override
  String get backupRestoreAction => '복원';

  @override
  String get backupSaved => '백업을 저장했습니다';

  @override
  String get backupRestored => '백업을 복원했습니다';

  @override
  String get backupInvalid => '이 파일은 Last Launcher 백업이 아닙니다';

  @override
  String get backupTooNew => '이 백업은 최신 버전의 Last Launcher에서 만들어졌습니다';

  @override
  String get backupFailed => '파일을 읽거나 쓸 수 없습니다';

  @override
  String get hintSwipeUp => '위로 스와이프: 앱';

  @override
  String hintSwipeRightFor(String module) {
    return '오른쪽으로 스와이프: $module';
  }

  @override
  String hintSwipeLeftFor(String module) {
    return '왼쪽으로 스와이프: $module';
  }

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
  String get actionRemove => '제거';

  @override
  String get actionClose => '닫기';

  @override
  String get actionAppInfo => '앱 정보';

  @override
  String get actionEnable => '활성화';

  @override
  String get renameDialogTitle => '이름 변경';

  @override
  String get renameDialogCancel => '취소';

  @override
  String get renameDialogSave => '저장';

  @override
  String get showWorkAppDot => '업무 프로필 점 표시';

  @override
  String get showWorkAppDotSubtitle => '업무 프로필 앱 앞에 작은 점 표시';

  @override
  String get showWorkAppDotOnHome => '홈 화면에 업무 점 표시';

  @override
  String get showWorkAppDotOnHomeSubtitle => '고정된 홈 화면 앱에 업무 프로필 점 표시';

  @override
  String get hidePersonalWhenWorkActive => '업무 외 앱 표시 안 함';

  @override
  String get hidePersonalWhenWorkActiveSubtitle =>
      '업무 프로필이 일시 중지되면 업무 외 앱이 다시 나타납니다';

  @override
  String get homeScreenFull => '홈 화면이 가득 찼습니다';
}
