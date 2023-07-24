// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ConfigModel {
  final String path;
  final String defaultLocale;
  final List<String> locales;
  final String? googleTranslateApiKey;
  final String? fileExtension;

  ConfigModel({
    required this.path,
    required this.defaultLocale,
    required this.locales,
    required this.googleTranslateApiKey,
    this.fileExtension = '.json',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'path': path,
      'defaultLocale': defaultLocale,
      'locales': locales,
      'googleTranslateApiKey': googleTranslateApiKey,
      'fileExtension': fileExtension,
    };
  }

  factory ConfigModel.fromMap(Map<String, dynamic> map) {
    return ConfigModel(
        path: map['path'] as String,
        defaultLocale: map['defaultLocale'] as String,
        locales: List<String>.from(map['locales']),
        googleTranslateApiKey: map['googleTranslateApiKey'] != null
            ? map['googleTranslateApiKey'] as String
            : null,
        fileExtension: map['fileExtension']);
  }

  String toJson() => jsonEncode(toMap());

  factory ConfigModel.fromJson(String source) =>
      ConfigModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ConfigModel(path: $path, defaultLocale: $defaultLocale, locales: $locales, googleTranslateApiKey: $googleTranslateApiKey)';
  }
}
