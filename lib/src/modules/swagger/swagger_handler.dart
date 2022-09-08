import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_swagger_ui/shelf_swagger_ui.dart';

FutureOr<Response> swaggerHandler(Request request) {
  final path = 'specs/swagger.yml';
  final handler = SwaggerUI(
    path,
    title: 'Backend crud Dart',
    deepLink: true,
  );
  return handler(request);
}
