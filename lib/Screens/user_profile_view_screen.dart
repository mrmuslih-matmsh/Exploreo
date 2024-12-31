import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exploreo/Screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:exploreo/Components/color.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _userName = '';
  String _userEmail = '';
  String _userImageUrl = '';
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch user data from Firestore
  Future<void> _fetchUserData() async {
    try {
      // Assuming the email is passed as an argument or retrieved from local storage
      final String email = 'user@example.com'; // Replace with actual email

      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first.data() as Map<String, dynamic>;

        setState(() {
          _userName = userDoc['name'];
          _userEmail = userDoc['email'];
          _userImageUrl =
              userDoc['profileImageUrl'] ?? ''; // Handle if no profile image
        });
      } else {
        setState(() {
          _errorMessage = 'User data not found';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again later.';
      });
    }
  }

  // Log out function
  void _logout() {
    // Perform logout functionality, e.g., clear local storage or token
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  // Action options for the user
  void _showMoreActions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: [
            ListTile(
              title: const Text('Edit Profile'),
              onTap: () {
                // Implement profile editing functionality here
              },
            ),
            ListTile(
              title: const Text('Change Password'),
              onTap: () {
                // Implement change password functionality here
              },
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                // Implement settings functionality here
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('User Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Display Profile Picture
            CircleAvatar(
              radius: 50.0,
              backgroundImage: _userImageUrl.isEmpty
                  ? const AssetImage('assets/default_profile.png')
                      as ImageProvider
                  : NetworkImage(_userImageUrl),
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 16),

            // Display User Name
            Text(
              _userName.isEmpty ? 'Loading...' : _userName,
              style:
                  const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Display User Email
            Text(
              _userEmail.isEmpty ? 'Loading...' : _userEmail,
              style: const TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Display Error Message if any
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),

            const SizedBox(height: 24),

            // Action buttons
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Logout'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showMoreActions,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('More Actions'),
            ),
          ],
        ),
      ),
    );
  }
}
