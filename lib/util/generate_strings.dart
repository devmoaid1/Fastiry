import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

String generateRandomString() {
  double randomNumber = Random().nextDouble();
  final randomBytes = utf8.encode(randomNumber.toString());
  final randomString = md5.convert(randomBytes).toString();
  return randomString;
}
