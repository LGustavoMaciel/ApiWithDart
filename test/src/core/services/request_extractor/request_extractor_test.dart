import 'dart:convert';

import 'package:backend/src/core/services/request_extractor/request_extractor.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  final extractor = RequestExtractor();
  test('getAuthorizationBearer', () async {
    final request = Request('GET', Uri.parse('http://localhost/'),
        //exemplo de token
        headers: {'authorization': 'bearer oiashdohasidgaoisdoaisgdga'});
    final token = extractor.getAuthorizationBearer(request);

    expect(token, 'oiashdohasidgaoisdoaisgdga');
  });

  test('getAuthorizationBasic', () async {
    var credentialAuth = 'email@email.com:123';
    credentialAuth = base64Encode(credentialAuth.codeUnits);

    final request = Request('GET', Uri.parse('http://localhost/'),
        headers: {'authorization': 'basic $credentialAuth'});
    final credential = extractor.getAuthorizationBasic(request);

    expect(credential.email, 'email@email.com');
    expect(credential.password, '123');
  });
}
