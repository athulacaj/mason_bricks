import 'dart:convert';
import 'dart:io';

import 'package:mason/mason.dart';

import '../models/config_model.dart';
import 'common_functions.dart';

class MainFunctions {
  final HookContext context;
  late CommonFunctions fc = CommonFunctions(context);
  MainFunctions(this.context) {}

  String? manageAndGetConfig() {
    String? configString;
    try {
      configString = File('./mason_localize_config.json').readAsStringSync();
    } catch (e) {
      final bool isCreate = context.logger.confirm(
          'No config file found. Would you like to create one? (y/n)',
          defaultValue: true);

      if (isCreate) {
        // create a new config file
        ConfigModel exsmpleConfigModel = ConfigModel(
          path: "assets/langs",
          defaultLocale: "en",
          locales: ["en", "es"],
          googleTranslateApiKey: null,
          fileExtension: ".json",
        );

        fc.createFile(
            './mason_localize_config.json', exsmpleConfigModel.toJson());
      }
      exit(0);
    }
    return configString;
  }

  // List getKeys(ConfigModel configModel) {}
}
