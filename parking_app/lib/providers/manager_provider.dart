import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class ManagerProvider extends ChangeNotifier {
  final _firestoreService = FirestoreService();
  final _authService = AuthService();

  Stream<List<UserModel>> get managersStream =>
      _firestoreService.streamManagers();

  Future<void> addManager(String email, String password) async {
    try {
      await _authService.createManager(email, password);
    } catch (e) {
      debugPrint('Error adding manager: $e');
      rethrow;
    }
  }

  Future<void> deleteManager(String managerId) async {
    try {
      await _authService.deleteManager(managerId);
    } catch (e) {
      debugPrint('Error deleting manager: $e');
      rethrow;
    }
  }
}
