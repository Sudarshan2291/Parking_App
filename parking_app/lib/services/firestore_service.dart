import '../models/user_model.dart';
import '../models/parking_slot.dart';
import '../core/constants.dart';
import 'firebase_service.dart';

class FirestoreService {
  final _firestore = FirebaseService().firestore;


  Stream<List<UserModel>> streamManagers() {
    return _firestore
        .collection(FirestoreCollections.managers)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> addManager(UserModel manager) async {
    await _firestore
        .collection(FirestoreCollections.managers)
        .doc(manager.uid)
        .set(manager.toMap());
  }

  Future<void> deleteManager(String uid) async {
    await _firestore
        .collection(FirestoreCollections.managers)
        .doc(uid)
        .delete();
  }


  Stream<List<ParkingSlot>> streamParkingSlots() {
    return _firestore
        .collection(FirestoreCollections.parkingSlots)
        .orderBy('slotNumber')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ParkingSlot.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> occupySlot(String slotId, String name) async {
    await _firestore
        .collection(FirestoreCollections.parkingSlots)
        .doc(slotId)
        .update({
      'status': 'occupied',
      'occupantName': name,
    });
  }

  Future<void> vacateSlot(String slotId) async {
    await _firestore
        .collection(FirestoreCollections.parkingSlots)
        .doc(slotId)
        .update({
      'status': 'available',
      'occupantName': null,
    });
  }

  Future<void> initializeParkingSlots() async {
    final collection = _firestore.collection(FirestoreCollections.parkingSlots);
    final snapshot = await collection.get();
    if (snapshot.docs.isEmpty) {
      for (int i = 1; i <= 10; i++) {
        await collection.add({
          'slotNumber': i,
          'status': 'available',
          'occupantName': null,
        });
      }
    }
  }
}
