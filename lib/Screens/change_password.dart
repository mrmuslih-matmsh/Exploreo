import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Components/color.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');
      if (email == null) {
        throw Exception("User not logged in.");
      }

      // Get the current user's document from Firestore
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(email).get();

      if (!userDoc.exists) {
        throw Exception("User not found.");
      }

      final oldPassword = userDoc.data()?['password'];

      if (_oldPasswordController.text != oldPassword) {
        throw Exception("Old password is incorrect.");
      }

      // Update the password in Firestore
      await FirebaseFirestore.instance.collection('users').doc(email).update({
        'password': _newPasswordController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'PoppinsSemiBold',
            color: Colors.black,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // Old password text field
                TextFormField(
                  controller: _oldPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Old Password',
                    labelStyle: const TextStyle(
                      fontFamily: 'PoppinsRegular',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    hintText: 'Enter your old password',
                    hintStyle: const TextStyle(
                      fontFamily: 'PoppinsRegular',
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your old password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // New password text field
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    labelStyle: const TextStyle(
                      fontFamily: 'PoppinsRegular',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    hintText: 'Enter your new password',
                    hintStyle: const TextStyle(
                      fontFamily: 'PoppinsRegular',
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your new password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Confirm new password text field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    labelStyle: const TextStyle(
                      fontFamily: 'PoppinsRegular',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    hintText: 'Confirm your new password',
                    hintStyle: const TextStyle(
                      fontFamily: 'PoppinsRegular',
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your new password';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 36),

                // Change password button
                ElevatedButton(
                  onPressed: _isLoading ? null : _updatePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: secondaryColor,
                        )
                      : const Text(
                          'Change Password',
                          style: TextStyle(
                            fontFamily: 'PoppinsMedium',
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
