import 'dart:convert';

class AppInfo {
  const AppInfo({
    required this.packageName,
    required this.label,
    this.isWorkApp = false,
  });

  final String packageName;
  final String label;
  final bool isWorkApp;

  /// Identifies this app across state maps: the personal and work copies of a
  /// package are distinct entries everywhere.
  String get key => '$packageName|$isWorkApp';
}

class PinnedApp {
  const PinnedApp({
    required this.packageName,
    required this.label,
    this.isWorkApp = false,
  });

  factory PinnedApp.fromJson(Map<String, dynamic> json) {
    return PinnedApp(
      packageName: json['packageName'] as String,
      label: json['label'] as String,
      isWorkApp: json['isWorkApp'] as bool? ?? false,
    );
  }

  final String packageName;
  final String label;
  final bool isWorkApp;

  Map<String, dynamic> toJson() {
    return {
      'packageName': packageName,
      'label': label,
      if (isWorkApp) 'isWorkApp': true,
    };
  }

  static List<PinnedApp> decodeList(String json) {
    final list = jsonDecode(json) as List<dynamic>;
    return list
        .map((e) => PinnedApp.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static String encodeList(List<PinnedApp> apps) {
    return jsonEncode(apps.map((a) => a.toJson()).toList());
  }
}
