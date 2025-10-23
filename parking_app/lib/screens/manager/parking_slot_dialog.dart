import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants.dart';
import '../../models/parking_slot.dart';

class ParkingSlotDialog extends StatefulWidget {
  final ParkingSlot parkingSlot;
  const ParkingSlotDialog({super.key, required this.parkingSlot});

  @override
  State<ParkingSlotDialog> createState() => _ParkingSlotDialogState();
}

class _ParkingSlotDialogState extends State<ParkingSlotDialog> {
  final TextEditingController _nameController = TextEditingController();

  void updateSlot(String status, [String name = '']) async {
    final slotRef = FirebaseFirestore.instance.collection(FirestoreCollections.parkingSlots);
    if (widget.parkingSlot.id.isEmpty) {
      // New slot
      await slotRef.add({
        'slotNumber': widget.parkingSlot.slotNumber,
        'status': status,
        'occupantName': name,
      });
    } else {
      // Update existing
      await slotRef.doc(widget.parkingSlot.id).update({
        'status': status,
        'occupantName': name,
      });
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.parkingSlot.isOccupied) {
      return AlertDialog(
        title: const Text("Occupied"),
        content: Text("Currently occupied by ${widget.parkingSlot.occupiedBy}. Make it available?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No")
          ),
          TextButton(
              onPressed: () => updateSlot('available'),
              child: const Text("Yes")
          ),
        ],
      );
    } else {
      return AlertDialog(
        title: Text("Assign Parking ${widget.parkingSlot.slotNumber}"),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: "Enter occupant name"),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")
          ),
          TextButton(
              onPressed: () => updateSlot('occupied', _nameController.text.trim()),
              child: const Text("Submit")
          ),
        ],
      );
    }
  }
}
