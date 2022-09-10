abstract class BCryptService {
  String genareteHash(String text);
  bool checkHash(String text, String hash);
}
