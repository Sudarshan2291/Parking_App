import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants.dart';
import '../../models/parking_slot.dart';
import 'parking_slot_dialog.dart';
import '../login/login_screen.dart';

class ManagerDashboard extends StatelessWidget {
  const ManagerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final parkingRef = FirebaseFirestore.instance.collection(FirestoreCollections.parkingSlots);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manager Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: parkingRef.orderBy('slotNumber').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final slotsMap = {
            for (var doc in snapshot.data!.docs)
              doc['slotNumber'] as int: ParkingSlot.fromMap(doc.data() as Map<String, dynamic>, doc.id)
          };

          final slots = List.generate(10, (i) {
            int slotNumber = i + 1;
            if (slotsMap.containsKey(slotNumber)) {
              return slotsMap[slotNumber]!;
            } else {
              return ParkingSlot(
                id: '',
                slotNumber: slotNumber,
                status: 'available',
                occupantName: '',
              );
            }
          });

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: slots.length,
            itemBuilder: (context, index) {
              final slot = slots[index];
              return GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => ParkingSlotDialog(parkingSlot: slot),
                ),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: slot.isOccupied ? Colors.red : Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Slot ${slot.slotNumber}",
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      if (slot.isOccupied)
                        Text(
                          slot.occupiedBy,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
