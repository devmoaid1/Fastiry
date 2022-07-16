import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SocialPhoneScreen extends StatelessWidget {
  final User user;
  final String token;
  const SocialPhoneScreen({Key key, this.user, this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Social Login ")),
      body: Column(),
    );
  }
}
