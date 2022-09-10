import 'dart:async';
import 'dart:convert';

import 'package:backend/src/core/services/bcrypt/bcrypt_service.dart';
import 'package:backend/src/core/services/database/remote_database.dart';
import 'package:backend/src/core/services/jwt/jwt_service.dart';
import 'package:backend/src/core/services/request_extractor/request_extractor.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AuthResource extends Resource {
  @override
  List<Route> get routes => [
        //login
        Route.get('/auth/login', _login),
        //refreshToken
        Route.get('/auth/login', _refreshToken),
        //checkToken
        Route.get('/auth/login', _checkToken),
        //update_password
        Route.post('/auth/login', _updatePassword),
      ];

  FutureOr<Response> _login(Request request, Injector injector) async {
    final extractor = injector.get<RequestExtractor>();
    final bcrypt = injector.get<BCryptService>();
    final jwt = injector.get<JwtService>();
    final credential = extractor.getAuthorizationBasic(request);

    final database = injector.get<RemoteDatabase>();

    final result = await database.query(
        'SELECT id, role, password FROM "User" WHERE email = @email;',
        variables: {
          'email': credential.email,
        });

    if (result.isEmpty) {
      return Response.forbidden(
          jsonEncode({'error': 'Email ou senha invalidos!'}));
    }
    final userMap = result.map((element) => element['User']).first!;

    if (bcrypt.checkHash(credential.password, userMap['password'])) {
      return Response.forbidden(
          jsonEncode({'error': 'Email ou senha invalidos!'}));
    }

    final payload = userMap..remove('password');

    payload['exp'] = _determineExpiration(Duration(minutes: 10));
    final accesToken = jwt.generateToken(payload, 'accessToken');

    payload['exp'] = _determineExpiration(Duration(days: 5));
    final refreshToken = jwt.generateToken(payload, 'refreshToken');

    return Response.ok(
        jsonEncode({'accessToken': accesToken, 'refreshToken': refreshToken}));
  }

  FutureOr<Response> _refreshToken() {
    return Response.ok('');
  }

  FutureOr<Response> _checkToken() {
    return Response.ok('');
  }

  FutureOr<Response> _updatePassword() {
    return Response.ok('');
  }
}

int _determineExpiration(Duration duration) {
  final expiresDate = DateTime.now().add(duration);
  final expiresIn = Duration(milliseconds: expiresDate.millisecondsSinceEpoch);

  return expiresIn.inSeconds;
}
