import 'package:encrypt/encrypt.dart';
class EncryptData{
//for AES Algorithms
  final String encryptionkey;

  EncryptData(this.encryptionkey);

  String generateKey() {
    String finalKey = '';
    if(encryptionkey.isNotEmpty && encryptionkey.length <= 32) {
      String encryptionKeyCopy = encryptionkey;
      while(encryptionKeyCopy.length < 32) {
        int difference = 32 - encryptionKeyCopy.length;
        if(difference >= encryptionKeyCopy.length) {
          encryptionKeyCopy = encryptionKeyCopy + encryptionKeyCopy;
        } else if(difference < encryptionKeyCopy.length) {
          encryptionKeyCopy = encryptionKeyCopy + encryptionKeyCopy.substring(0, difference);
        }
      }
      finalKey = encryptionKeyCopy;
    } else if (encryptionkey.isNotEmpty && encryptionkey.length > 32) {
      String encryptionKeyCopy = encryptionkey.substring(0,32);
      finalKey = encryptionKeyCopy;
    }
    return finalKey;
  }

  String encryptAES(plainText) {
    String generatedKey = generateKey();
    final key = Key.fromUtf8(generatedKey);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    Encrypted encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  String decryptAES(plainText) {
    String generatedKey = generateKey();
    final key = Key.fromUtf8(generatedKey);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    String decrypted = encrypter.decrypt64(plainText, iv: iv);
    return decrypted;
  }
}