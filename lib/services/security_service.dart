import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurityService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final encrypt.Key _key =
      encrypt.Key.fromUtf8('your-32-byte-encryption-key'); // Use a secure key

  // Encrypt data
  String _encryptData(String data) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final encrypted = encrypter.encrypt(data, iv: encrypt.IV.fromLength(16));
    return encrypted.base64;
  }

  // Decrypt data
  String _decryptData(String encryptedData) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final decrypted =
        encrypter.decrypt64(encryptedData, iv: encrypt.IV.fromLength(16));
    return decrypted;
  }

  // Save encrypted data
  Future<void> saveEncryptedData(String key, String value) async {
    await _storage.write(key: key, value: _encryptData(value));
  }

  // Retrieve and decrypt data
  Future<String?> getDecryptedData(String key) async {
    String? encryptedData = await _storage.read(key: key);
    if (encryptedData != null) {
      return _decryptData(encryptedData);
    }
    return null;
  }
}
