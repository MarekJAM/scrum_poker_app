import 'package:flutter/material.dart';
import 'repositories.dart';

class AuthRepository {
  final AuthApiClient authApiClient;

  AuthRepository({@required this.authApiClient})
      : assert(AuthApiClient != null);

  Future<bool> login(String username, String password) async {
    return await authApiClient.login(username, password);
  }

  Future<bool> register(String username, String password) async {
    return await authApiClient.register(username, password);
  }
}
