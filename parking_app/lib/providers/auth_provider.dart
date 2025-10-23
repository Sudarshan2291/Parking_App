import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../core/constants.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;
  bool _isLoading = true;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAdmin => _user?.role == AppStrings.adminRole;
  bool get isManager => _user?.role == AppStrings.managerRole;

  AuthProvider() {
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    final firebaseUser = _authService.currentUser;
    if (firebaseUser != null) {
      final signedInUser =
          await _authService.signIn(firebaseUser.email!, 'dummy-password');
      _user = signedInUser;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final result = await _authService.signIn(email, password);
    _user = result;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}
