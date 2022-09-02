import 'dart:convert';

import 'package:equatable/equatable.dart';

class LoginModel extends Equatable {
  final String token;
  final int isPhoneVerified;

  const LoginModel({this.token, this.isPhoneVerified});

  factory LoginModel.fromMap(Map<String, dynamic> data) {
    return LoginModel(
      token: data['token'] as String,
      isPhoneVerified: data['is_phone_verified'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'is_phone_verified': isPhoneVerified,
    };
  }

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [LoginModel].
  factory LoginModel.fromJson(String data) {
    return LoginModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [LoginModel] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  List<Object> get props => [token, isPhoneVerified];
}
