import 'dart:convert';

class AppInfo {
  const AppInfo({required this.packageName, required this.label});

  final String packageName;
  final String label;
}

const _sentinel = Object();

class PinnedApp {
  const PinnedApp({
    required this.packageName,
    required this.label,
    this.customLabel,
    required this.sortOrder,
  });

  factory PinnedApp.fromJson(Map<String, dynamic> json) {
    return PinnedApp(
      packageName: json['packageName'] as String,
      label: json['label'] as String,
      customLabel: json['customLabel'] as String?,
      sortOrder: json['sortOrder'] as int,
    );
  }

  final String packageName;
  final String label;
  final String? customLabel;
  final int sortOrder;

  String get displayLabel => customLabel ?? label;

  PinnedApp copyWith({
    String? packageName,
    String? label,
    Object? customLabel = _sentinel,
    int? sortOrder,
  }) {
    return PinnedApp(
      packageName: packageName ?? this.packageName,
      label: label ?? this.label,
      customLabel: customLabel == _sentinel
          ? this.customLabel
          : customLabel as String?,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'packageName': packageName,
      'label': label,
      'customLabel': customLabel,
      'sortOrder': sortOrder,
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
