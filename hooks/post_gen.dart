import 'dart:convert';
import 'dart:io';

import 'package:mason/mason.dart';

const languages = [
  'en',
  'ar',
  'bn',
  'fil',
  'hi',
  'ml',
  'ne',
  'si',
  'ta',
  'te',
  'ur'
];

void run(HookContext context) {
  String contents = File('assets/langs/en.json').readAsStringSync();
  // string to json
  Map<String, dynamic> base = jsonDecode(contents);
  for (var lang in languages) {
    String contents = File('./assets/langs/$lang.json').readAsStringSync();
    // string to json
    Map<String, dynamic> json = jsonDecode(contents);
    // compare the base with json and print missing keys
    for (var key in base.keys) {
      if (!json.containsKey(key)) {
        print('Missing key: $key in $lang');
      }
    }
  }
  // print(json);
}
