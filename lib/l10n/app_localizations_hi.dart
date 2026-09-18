// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Last Launcher';

  @override
  String get appTagline => 'आखिरी लॉन्चर जिसकी आपको कभी ज़रूरत होगी';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get sectionAppearance => 'दिखावट';

  @override
  String get sectionHome => 'होम';

  @override
  String get sectionAppDrawer => 'ऐप ड्रॉअर';

  @override
  String get sectionTasks => 'कार्य';

  @override
  String get sectionModules => 'मॉड्यूल';

  @override
  String get sectionSupport => 'सहायता';

  @override
  String get sectionAbout => 'परिचय';

  @override
  String get sectionSearch => 'खोज';

  @override
  String get sectionWork => 'कार्य प्रोफ़ाइल';

  @override
  String get themeTitle => 'थीम';

  @override
  String get themeSystem => 'सिस्टम';

  @override
  String get themeLight => 'लाइट';

  @override
  String get themeDark => 'डार्क';

  @override
  String get themeExtra => 'Extra';

  @override
  String get themeStyleTitle => 'शैली';

  @override
  String get themeStyleStandard => 'मानक';

  @override
  String get themeExtraAlwaysDark => 'Extra हमेशा डार्क होता है';

  @override
  String get hideStatusBar => 'फ़ुलस्क्रीन';

  @override
  String get hideStatusBarSubtitle => 'स्टेटस बार और नेविगेशन छुपाएँ';

  @override
  String get showHints => 'संकेत दिखाएँ';

  @override
  String get showHintsSubtitle => 'पूरे ऐप में उपयोग संकेत दिखाएँ';

  @override
  String get hidePinnedApps => 'पिन किए गए ऐप्स छुपाएँ';

  @override
  String get hidePinnedAppsSubtitle => 'ऐप ड्रॉअर से पिन किए गए ऐप्स छुपाएँ';

  @override
  String get includeHiddenInSearch => 'खोज में छुपे शामिल करें';

  @override
  String get includeHiddenInSearchSubtitle =>
      'खोज को छुपे ऐप्स से मिलान करने दें';

  @override
  String get matchOriginalName => 'मूल नाम से मिलान करें';

  @override
  String get matchOriginalNameSubtitle =>
      'नाम बदली गई ऐप्स को उनके मूल नाम से खोजें';

  @override
  String get hiddenApps => 'छुपे हुए ऐप्स';

  @override
  String get hiddenAppsNone => 'कोई नहीं';

  @override
  String hiddenAppsCount(int count) {
    return '$count छुपे हुए';
  }

  @override
  String get noHiddenApps => 'कोई छुपे हुए ऐप्स नहीं';

  @override
  String get leftOfHome => 'बायां मॉड्यूल';

  @override
  String get rightOfHome => 'दायां मॉड्यूल';

  @override
  String get panelNone => 'कोई नहीं';

  @override
  String get lockLayout => 'लेआउट लॉक करें';

  @override
  String get lockLayoutSubtitle =>
      'होम स्क्रीन पर पिन करना और लंबा दबाना अक्षम करें';

  @override
  String get doubleTapToSleep => 'सोने के लिए डबल टैप करें';

  @override
  String get doubleTapToSleepSubtitle =>
      'सिस्टम सेटिंग्स में एक्सेसिबिलिटी सेवा सक्षम होनी चाहिए';

  @override
  String get doubleTapToSleepDialogTitle => 'Turn on accessibility service';

  @override
  String get doubleTapToSleepDialog =>
      'This uses the AccessibilityService API to lock the screen when you double-tap. It does nothing else. You will be redirected to system settings to turn it on.';

  @override
  String get doubleTapToSleepPrivacy =>
      'We do not collect, store, or share any personal or sensitive user data through the AccessibilityService API.';

  @override
  String get setAsDefault => 'डिफ़ॉल्ट होम ऐप के रूप में सेट करें';

  @override
  String get setAsDefaultSubtitle => 'सिस्टम पिकर खोलें';

  @override
  String get searchOnlyMode => 'केवल खोज';

  @override
  String get searchOnlyModeSubtitle => 'ऐप के नाम छुपाएँ, खोजकर खोलें';

  @override
  String get autoShowKeyboard => 'कीबोर्ड दिखाएँ';

  @override
  String get autoShowKeyboardAppsSubtitle => 'ड्रॉअर खुलने पर कीबोर्ड खोलें';

  @override
  String get autoShowKeyboardTasksSubtitle => 'कार्य खुलने पर कीबोर्ड खोलें';

  @override
  String get autoLaunchOnMatch => 'मिलान पर ऑटो-लॉन्च';

  @override
  String get autoLaunchOnMatchSubtitle => 'एक ऐप मिलने पर लॉन्च करें';

  @override
  String get quickLaunchHints => 'त्वरित लॉन्च संकेत';

  @override
  String get quickLaunchHintsSubtitle =>
      'लॉन्च करने के लिए सबसे छोटे अद्वितीय अक्षरों को हाइलाइट करें';

  @override
  String get extraChar => 'Extra character';

  @override
  String get extraCharSubtitle =>
      'Require an extra character before auto-launch';

  @override
  String get panelTasks => 'कार्य';

  @override
  String get removeOnComplete => 'पूरा होने पर हटाएँ';

  @override
  String get removeOnCompleteSubtitle => 'पूर्ण होने पर कार्य हटाएँ';

  @override
  String get clearCompletedDaily => 'रोज़ाना पूर्ण कार्य हटाएँ';

  @override
  String get clearCompletedDailySubtitle =>
      'दिन के अंत में पूर्ण कार्य हटा दें';

  @override
  String get donate => 'दान करें';

  @override
  String get donateSubtitle => 'Last Launcher के विकास का समर्थन करें';

  @override
  String get rateApp => 'Last Launcher को रेट करें';

  @override
  String get rateAppSubtitle => 'Play Store पर समीक्षा छोड़ें';

  @override
  String get sendFeedback => 'प्रतिक्रिया भेजें';

  @override
  String get sendFeedbackSubtitle => 'डेवलपर को ईमेल करें';

  @override
  String get help => 'सहायता';

  @override
  String get helpSubtitle => 'प्रोजेक्ट पेज देखें';

  @override
  String get version => 'संस्करण';

  @override
  String get license => 'लाइसेंस';

  @override
  String get openSourceLicenses => 'ओपन सोर्स लाइसेंस';

  @override
  String get aboutSubtitle => 'संस्करण और लाइसेंस';

  @override
  String get hintSwipeUp => 'ऐप्स के लिए ऊपर स्वाइप करें';

  @override
  String hintSwipeRightFor(String module) {
    return '$module के लिए दाएँ स्वाइप करें';
  }

  @override
  String hintSwipeLeftFor(String module) {
    return '$module के लिए बाएँ स्वाइप करें';
  }

  @override
  String get hintLongPress => 'सेटिंग्स के लिए लंबा दबाएँ';

  @override
  String get noResults => 'कोई परिणाम नहीं';

  @override
  String get emptyTaskList => 'कार्य जोड़ने के लिए टाइप करें';

  @override
  String get returnToAddTask => 'कार्य जोड़ने के लिए एंटर दबाएं';

  @override
  String get actionRename => 'नाम बदलें';

  @override
  String get actionUnpin => 'अनपिन';

  @override
  String get actionPin => 'पिन';

  @override
  String get actionPinFull => 'भरा हुआ';

  @override
  String get actionHide => 'छुपाएँ';

  @override
  String get actionUnhide => 'दिखाएँ';

  @override
  String get actionRemove => 'हटाएँ';

  @override
  String get actionClose => 'बंद करें';

  @override
  String get actionAppInfo => 'ऐप जानकारी';

  @override
  String get actionEnable => 'सक्षम करें';

  @override
  String get renameDialogTitle => 'नाम बदलें';

  @override
  String get renameDialogCancel => 'रद्द करें';

  @override
  String get renameDialogSave => 'सहेजें';

  @override
  String get showWorkAppDot => 'कार्य प्रोफ़ाइल बिंदु दिखाएं';

  @override
  String get showWorkAppDotSubtitle =>
      'कार्य प्रोफ़ाइल ऐप्स के सामने एक छोटा बिंदु दिखाएं';

  @override
  String get showWorkAppDotOnHome => 'होम स्क्रीन पर कार्य बिंदु दिखाएं';

  @override
  String get showWorkAppDotOnHomeSubtitle =>
      'पिन की गई होम स्क्रीन ऐप्स पर कार्य प्रोफ़ाइल बिंदु दिखाएं';

  @override
  String get hidePersonalWhenWorkActive => 'गैर-कार्य ऐप्स न दिखाएं';

  @override
  String get hidePersonalWhenWorkActiveSubtitle =>
      'कार्य प्रोफ़ाइल रुकने पर गैर-कार्य ऐप्स फिर से दिखाई देंगे';

  @override
  String get homeScreenFull => 'होम स्क्रीन भर गई है';
}
