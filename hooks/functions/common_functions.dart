import 'dart:io';

import 'package:mason/mason.dart';

class CommonFunctions {
  final HookContext context;
  CommonFunctions(this.context);

  createFile(String path, String content) {
    File newFile = File(path);

    // Create the file on disk.
    File(path).writeAsStringSync(content, mode: FileMode.write);
    context.logger.success('Created file: $path');
  }

  readFile(String path) {
    final config = File('path').readAsStringSync();
  }
}
