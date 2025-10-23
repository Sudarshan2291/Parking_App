import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'firebase_service.dart';
import 'firestore_service.dart';
import '../core/constants.dart';

class AuthService {
  final _auth = FirebaseService().auth;
  final _firestore = FirebaseService().firestore;

  Future<UserModel?> signIn(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = result.user!.uid;
      final doc =
          await _firestore.collection(FirestoreCollections.managers).doc(uid).get();

      if (doc.exists) {
        return UserModel.fromMap(doc.data()!, uid);
      } else if (email == "admin@parking.com") {
        return UserModel(uid: uid, email: email, role: AppStrings.adminRole);
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<UserModel?> createManager(String email, String password) async {
    try {
      final userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final manager = UserModel(
        uid: userCred.user!.uid,
        email: email,
        role: AppStrings.managerRole,
      );

      await FirestoreService().addManager(manager);
      return manager;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> deleteManager(String managerId) async {
    await FirestoreService().deleteManager(managerId);
  }

  User? get currentUser => _auth.currentUser;
}
