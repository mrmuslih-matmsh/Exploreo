import 'package:exploreo/Screens/bookmarks_screen.dart';
import 'package:exploreo/Screens/chat_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:exploreo/Screens/edit_profile_screen.dart';
import 'package:exploreo/Components/color.dart';
import 'package:exploreo/Screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userName;
  String? userEmail;
  String? profileImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      setState(() {
        userName = prefs.getString('name') ?? 'Guest User';
        userEmail = prefs.getString('email') ?? 'No email available';
        profileImage = prefs.getString('profile') ??
            'https://via.placeholder.com/150';
      });
    } catch (e) {
      print('Error loading user data from SharedPreferences: $e');
      setState(() {
        userName = 'Error';
        userEmail = 'Error loading email';
        profileImage = 'https://via.placeholder.com/150';
      });
    }
  }

  Future<void> _logout() async {
    final bool? confirmLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    Future<void> _clearUserDataFromSharedPreferences() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('email');
      await prefs.remove('location');
      await prefs.remove('mobile');
      await prefs.remove('name');
      await prefs.remove('profile');
    }

    if (confirmLogout == true) {
      try {
        await _clearUserDataFromSharedPreferences();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );

      } catch (e) {
        print('Error during logout: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: userName == null
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(profileImage!),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                userEmail!,
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios,
                            color: Colors.black),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Buttons Section
                  Expanded(
                    child: ListView(
                      children: [
                        _buildProfileButton(
                          icon: Icons.bookmark,
                          label: 'Bookmarks',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookmarksScreen(),
                              ),
                            );
                          },
                        ),
                        _buildProfileButton(
                          icon: Icons.chat,
                          label: 'Chat',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChatScreen(),
                              ),
                            );
                          },
                        ),
                        _buildProfileButton(
                          icon: Icons.lock,
                          label: 'Change Password',
                          onPressed: () {
                            // Navigate to Change Password Screen
                          },
                        ),
                        _buildProfileButton(
                          icon: Icons.post_add,
                          label: 'My Posts',
                          onPressed: () {
                            // Navigate to My Posts Screen
                          },
                        ),
                        _buildProfileButton(
                          icon: Icons.settings,
                          label: 'Settings',
                          onPressed: () {
                            // Navigate to Settings Screen
                          },
                        ),
                        _buildProfileButton(
                          icon: Icons.support_agent,
                          label: 'Support',
                          onPressed: () {
                            // Open Support Page
                          },
                        ),
                        _buildProfileButton(
                          icon: Icons.logout,
                          label: 'Logout',
                          onPressed: _logout,
                        ),
                      ],
                    ),
                  ),
                  const Center(
                    child: Text(
                      'App Version 1.0.0',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // A reusable widget for creating profile buttons
  Widget _buildProfileButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // White background
            side: const BorderSide(color: Colors.black, width: 1.0),
            elevation: 0, // No shadow
            minimumSize: const Size.fromHeight(50),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: secondaryColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
