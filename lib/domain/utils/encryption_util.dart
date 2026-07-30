import 'dart:convert';

class EncryptionUtil {
  // Simple Base64 for demonstration, in production use a real encryption like AES
  static String encrypt(String plainText) {
    return base64Url.encode(utf8.encode(plainText));
  }

  static String decrypt(String encryptedText) {
    try {
      return utf8.decode(base64Url.decode(encryptedText));
    } catch (e) {
      return '';
    }
  }
}
