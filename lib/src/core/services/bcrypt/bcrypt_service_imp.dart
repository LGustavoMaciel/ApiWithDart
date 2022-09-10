//Serviço para encriptação de Senha
import 'package:backend/src/core/services/bcrypt/bcrypt_service.dart';
import 'package:bcrypt/bcrypt.dart';

class BCryptServiceImpl implements BCryptService {
  @override
  bool checkHash(String text, String hash) {
    return BCrypt.checkpw(text, hash);
  }

  @override
  String genareteHash(String text) {
    final String hashed = BCrypt.hashpw(text, BCrypt.gensalt());
    return hashed;
  }
}
