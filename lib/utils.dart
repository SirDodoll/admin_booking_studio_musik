import 'package:crypto/crypto.dart';
import 'dart:convert';

String hashPassword(String password) {
  var bytes = utf8.encode(password);
  var hashed = sha256.convert(bytes);
  return hashed.toString();
}
