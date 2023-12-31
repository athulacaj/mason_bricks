// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

class Req {
  final HttpHeaders headers;
  final Map body;
  final Map params;
  final Map query;

  Req(
      {required this.headers,
      required this.body,
      required this.params,
      required this.query});

  static fromHttpRequest(HttpRequest request) async {
    print("request body");
    String requestBody = "{}";
    try {
      if (request.headers.contentType?.mimeType == 'application/json' &&
          request.method != 'OPTIONS' &&
          request.method != 'GET') {
        await request.toList().then((chunks) {
          // Concatenate the list of chunks into a single Uint8List
          var bytes =
              Uint8List.fromList(chunks.expand((chunk) => chunk).toList());

          // Decode the bytes using UTF-8 to get the request body as a string
          requestBody = utf8.decode(bytes);
        });
      }
    } catch (e) {
      print(e);
    }

    return Req(
      headers: request.headers,
      body: jsonDecode(requestBody),
      params: {},
      query: {},
    );
  }

  @override
  String toString() {
    return 'Req(headers: ${headers.toString()}, body: $body, params: $params, query: $query)';
  }
}
