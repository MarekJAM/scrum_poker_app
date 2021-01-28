import 'package:crypto/crypto.dart';

class Hash {
  static String encrypt(String val) {
    var bytes = val.codeUnits;

    var digest = sha256.convert(bytes);

    return digest.toString();
  }
}
