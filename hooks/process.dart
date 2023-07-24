import 'dart:io';

import 'package:mason/mason.dart';

class MyProcess {
  static late HookContext context;
  String msg;
  MyProcess({this.msg = 'Running process...'});
  Future<bool> run(String command, List<String>? params) async {
    final progress = context.logger.progress(msg);

    // Run `flutter packages get` after generation.
    ProcessResult result = await Process.run(command, params ?? []);
    // log the output of the process
    // context.logger.info(result.stdout);
    // write log into a file
    // save the log into a file using dart:io

    // File('mason_build_log.txt')
    //     .writeAsStringSync(result.stderr.toString(), mode: FileMode.append);

    // File('mason_build_log.txt')
    //     .writeAsStringSync(result.stdout.toString(), mode: FileMode.append);

    //log the error of the process
    context.logger.err(result.stderr);
    // print the log
    context.logger.info(result.stdout);

    // return false if the process failed
    if (result.exitCode != 0) {
      progress.fail();
      return false;
    }
    progress.complete();
    return true;
  }
}
