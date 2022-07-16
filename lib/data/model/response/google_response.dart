import 'package:firebase_auth/firebase_auth.dart';

class GoogleResponse {
  final String token;
  final UserCredential userCredential;

  GoogleResponse(this.token, this.userCredential);
}
