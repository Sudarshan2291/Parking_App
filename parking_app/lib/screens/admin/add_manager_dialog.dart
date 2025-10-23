import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';
import '../../core/constants.dart';

class AddManagerDialog extends StatefulWidget {
  const AddManagerDialog({super.key});

  @override
  State<AddManagerDialog> createState() => _AddManagerDialogState();
}

class _AddManagerDialogState extends State<AddManagerDialog> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final managersRef = FirebaseFirestore.instance.collection(FirestoreCollections.managers);

    return AlertDialog(
      title: const Text("Add Manager"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
          TextField(controller: passwordController, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: isLoading
              ? null
              : () async {
                  setState(() => isLoading = true);
                  try {
                    // 1️⃣ Create user in Firebase Auth
                    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );

                    // 2️⃣ Create user in Firestore
                    final userModel = UserModel(
                      uid: credential.user!.uid,
                      email: emailController.text.trim(),
                      role: 'manager', // assign role
                    );

                    await managersRef.doc(userModel.uid).set(userModel.toMap());

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Manager added successfully")),
                    );

                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error adding manager: $e")),
                    );
                  } finally {
                    setState(() => isLoading = false);
                  }
                },
          child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Add"),
        ),
      ],
    );
  }
}
