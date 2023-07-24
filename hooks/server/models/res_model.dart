import 'dart:convert';
import 'dart:io';

class Res {
  final HttpResponse response;
  int _statusCode = 200;

  Map h1 = {
    'Access-Control-Allow-Origin': '*', // Replace with your allowed origin
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    'Access-Control-Max-Age':
        '600', // Optional: specify a preflight cache time in seconds
  };

  HttpResponse wrapHeader(HttpResponse response) {
    return response
      ..headers.add('Access-Control-Allow-Origin', '*')
      ..headers
          .add('Access-Control-Allow-Methods', 'POST,GET,DELETE,PUT,OPTIONS')
      ..headers
          .add('Access-Control-Allow-Headers', 'Content-Type, Authorization')
      ..headers.add('Access-Control-Max-Age', '600');
  }

  Res({required this.response});
  void send(data) {
    response.statusCode = _statusCode;
    response
      ..headers.contentType = ContentType(
        ContentType.json.primaryType,
        ContentType.json.subType,
      )
      ..headers.add('Access-Control-Allow-Origin', '*')
      ..headers.add('content-type', 'application/json; charset=utf-8')
      ..headers
          .add('Access-Control-Allow-Methods', 'POST,GET,DELETE,PUT,OPTIONS')
      ..headers
          .add('Access-Control-Allow-Headers', 'Content-Type, Authorization')
      ..headers.add('Access-Control-Max-Age', '600')
      ..write(jsonEncode(data));

    response.close();
  }

  Res status(int statusCode) {
    _statusCode = statusCode;
    return this;
  }
}
