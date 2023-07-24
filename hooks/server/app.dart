import 'dart:io';
import 'models/req_model.dart';
import 'models/res_model.dart';

class Types {
  static const GET = 'GET';
  static const POST = 'POST';
  static const PUT = 'PUT';
  static const DELETE = 'DELETE';
}

class RequestModel {
  final String method;
  final String path;
  final Function callback;

  RequestModel(this.method, this.path, this.callback);
}

class App {
  // HttpRequest request;
  Map listendedRequests = {};

  Future<void> listen(int port, Function callback) async {
    // close all connections the server is listening to port 8888

    final requests = await HttpServer.bind(InternetAddress.anyIPv4, port);
    callback();

    await requests.forEach((request) async {
      print("request: ${request.uri.path}");
      final req = await Req.fromHttpRequest(request);
      final res = Res(response: request.response);
      // send if path exists else send 404

      if (request.method == 'OPTIONS') {
        request.response
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..headers
              .add('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE')
          ..headers.add(
              'Access-Control-Allow-Headers', 'Content-Type, Authorization')
          ..statusCode = HttpStatus.ok
          ..close();
      }

      if (listendedRequests[request.uri.path] != null) {
        switch (listendedRequests[request.uri.path].method) {
          case Types.GET:
            return listendedRequests[request.uri.path].callback(req, res);
          case Types.POST:
            return listendedRequests[request.uri.path].callback(req, res);
        }
      } else {
        res.status(HttpStatus.notFound).send({"message": "url Not found"});
      }
    });

    // await requests.listen((request) {

    // });
  }

  get(String path, void Function(Req req, Res res) callback) {
    listendedRequests[path] = RequestModel(Types.GET, path, callback);
  }

  post(String path, void Function(Req req, Res res) callback) {
    listendedRequests[path] = RequestModel(Types.POST, path, callback);
  }
}
