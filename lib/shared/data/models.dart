import 'dart:convert';

class AppInfo {
  const AppInfo({required this.packageName, required this.label});

  final String packageName;
  final String label;
}

class PinnedApp {
  const PinnedApp({
    required this.packageName,
    required this.label,
    this.customLabel,
  });

  factory PinnedApp.fromJson(Map<String, dynamic> json) {
    return PinnedApp(
      packageName: json['packageName'] as String,
      label: json['label'] as String,
      customLabel: json['customLabel'] as String?,
    );
  }

  final String packageName;
  final String label;
  final String? customLabel;

  String get displayLabel => customLabel ?? label;

  PinnedApp copyWith({String? label, String? Function()? customLabel}) {
    return PinnedApp(
      packageName: packageName,
      label: label ?? this.label,
      customLabel: customLabel != null ? customLabel() : this.customLabel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'packageName': packageName,
      'label': label,
      'customLabel': customLabel,
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
