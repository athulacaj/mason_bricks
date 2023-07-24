import 'dart:convert';
import 'dart:io';

import 'package:mason/mason.dart';

import '../models/config_model.dart';
import 'common_functions.dart';

class LocalizeFunctions {
  final HookContext _context;
  final ConfigModel _configModel;
  late CommonFunctions fc;

  final Map<String, Map<String, dynamic>> allData = {};
  List<String> _allKeys = [];

  get allKeys => _allKeys;
  get configeModel => _configModel;

  LocalizeFunctions(this._context, this._configModel) {
    fc = CommonFunctions(_context);
    getAllData();
  }

  List getTableData() {
    List dataList = [];
    for (String key in _allKeys) {
      Map<String, dynamic> data = {
        "key": key,
      };
      for (String lang in _configModel.locales) {
        if (allData[lang]![key] is Map) {
          data[lang] = jsonEncode(allData[lang]![key]);
          continue;
        }
        data[lang] = allData[lang]![key];
      }
      dataList.add(data);
    }
    return dataList;
  }

  List getMissingKeysTableData() {
    List missingDataList = [];
    for (String key in _allKeys) {
      bool isMissing = false;
      Map<String, dynamic> data = {
        "key": key,
      };
      for (String lang in _configModel.locales) {
        if (allData[lang]![key] == null) {
          isMissing = true;
        }
        data[lang] = allData[lang]![key].toString();
      }
      if (isMissing) {
        missingDataList.add(data);
      }
    }
    return missingDataList;
  }

  Map<String, dynamic>? getDataFromConfigModel(String lang) {
    try {
      final pathForDefaultLocale =
          '${_configModel.path}/$lang${_configModel.fileExtension}';
      final locales = _configModel.locales;
      String contents = File(pathForDefaultLocale).readAsStringSync();
      Map<String, dynamic> base = jsonDecode(contents);
      return base;
    } catch (e) {
      _context.logger.err('Failed to read : ${e.toString()}');
      return null;
    }
  }

  void getAllData() {
    allData.clear();
    final defaultData = getDataFromConfigModel(_configModel.defaultLocale);
    if (defaultData == null) {
      _context.logger.err('Failed to read default locale');
      return;
    }
    _allKeys = defaultData.keys.toList();
    allData[_configModel.defaultLocale] = defaultData;
    for (String lang in _configModel.locales) {
      final data = getDataFromConfigModel(lang);
      if (data != null) {
        allData[lang] = data;
      }
    }
  }

  void checkForMissingKeys() {
    print(allData.keys);
    print(allData[_configModel.defaultLocale]?.keys);
    Map<String, dynamic> base = allData[_configModel.defaultLocale]!;
    for (var lang in _configModel.locales) {
      if (lang == _configModel.defaultLocale) continue;
      print(lang);
      Map<String, dynamic> data = allData[lang]!;
      // compare the base with json and print missing keys
      for (var key in base.keys) {
        if (!data.containsKey(key)) {
          _context.logger.info('$key in $lang');
        }
      }
    }
  }

  void createLabel(String key, Map value) {
    value.keys.forEach((lang) {
      final path = '${_configModel.path}/$lang${_configModel.fileExtension}';
      allData[lang]![key] = value[lang];
      fc.createFile(path, jsonEncode(allData[lang]));
    });
  }
}
