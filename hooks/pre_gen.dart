// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:mason/mason.dart';

import 'functions/localize_functions.dart';
import 'functions/main_functions.dart';
import 'models/config_model.dart';
import 'server/run_server.dart';

class Steps {}

class Choice {
  final String label;
  final Function action;

  Choice(this.label, this.action);

  @override
  String toString() => '$label';
}

void run(HookContext context) async {
  MainFunctions mainFunctions = MainFunctions(context);
  late LocalizeFunctions localizeFunctions;

  String? configString = mainFunctions.manageAndGetConfig();
  if (configString == null) {
    exit(0);
  }
  final ConfigModel configModel = ConfigModel.fromJson(configString);
  localizeFunctions = LocalizeFunctions(context, configModel);
  // print(configModel.toString());

  await runServer(localizeFunctions: localizeFunctions);

  Choice choice = context.logger.chooseOne("Select Option", choices: [
    Choice("Check for missing keys", () {
      localizeFunctions.checkForMissingKeys();
    }),
    Choice("Controll using web app", () async {
      // await runServer(localizeFunctions: localizeFunctions);
      // context.logger.confirm("Press Enter to exit");
    }),
    Choice("Exit", () {
      exit(0);
    }),
  ]);

  await choice.action();

  // localizeFunction.checkForMissingKeys(configModel);
  exit(0);
}
