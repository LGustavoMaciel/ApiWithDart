import 'package:backend/backend.dart';
import 'package:shelf/shelf_io.dart' as io;

void main(List<String> arguments) async {
  final handler = await startShelfModular();
  final server = await io.serve(handler, 'localhost', 8080);
  print('Server online -  ${server.address.address}:${server.port}');
}
