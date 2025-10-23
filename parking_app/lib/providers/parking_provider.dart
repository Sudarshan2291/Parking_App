import 'package:flutter/material.dart';
import '../models/parking_slot.dart';
import '../services/firestore_service.dart';

class ParkingProvider extends ChangeNotifier {
  final _firestoreService = FirestoreService();

  Stream<List<ParkingSlot>> get parkingSlotsStream =>
      _firestoreService.streamParkingSlots();

  Future<void> occupySlot(String slotId, String name) async {
    await _firestoreService.occupySlot(slotId, name);
  }

  Future<void> vacateSlot(String slotId) async {
    await _firestoreService.vacateSlot(slotId);
  }

  Future<void> initializeSlots() async {
    await _firestoreService.initializeParkingSlots();
  }
}
