import 'package:flutter/material.dart';
import 'repositories.dart';

class AuthRepository {
  final AuthApiClient authApiClient;

  AuthRepository({@required this.authApiClient})
      : assert(AuthApiClient != null);

  Future<bool> loginWithCredentials(String username, String password) async {
    return await authApiClient.loginWithCredentials(username, password);
  }

  Future<bool> loginAsGuest(String username) async {
    return await authApiClient.loginAsGuest(username);
  }

  Future<bool> register(
    String username,
    String password,
    String securityQuestion,
    String answer,
  ) async {
    return await authApiClient.register(
      username,
      password,
      securityQuestion,
      answer,
    );
  }
}
