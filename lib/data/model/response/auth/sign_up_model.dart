import 'dart:convert';

import 'package:equatable/equatable.dart';

class SignUpModel extends Equatable {
  final String token;
  final int isPhoneVerified;
  final String phoneVerifyEndUrl;

  const SignUpModel({
    this.token,
    this.isPhoneVerified,
    this.phoneVerifyEndUrl,
  });

  factory SignUpModel.fromMap(Map<String, dynamic> data) => SignUpModel(
        token: data['token'] as String,
        isPhoneVerified: data['is_phone_verified'] as int,
        phoneVerifyEndUrl: data['phone_verify_end_url'] as String,
      );

  Map<String, dynamic> toMap() => {
        'token': token,
        'is_phone_verified': isPhoneVerified,
        'phone_verify_end_url': phoneVerifyEndUrl,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SignUpModel].
  factory SignUpModel.fromJson(String data) {
    return SignUpModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SignUpModel] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  List<Object> get props => [token, isPhoneVerified, phoneVerifyEndUrl];
}
