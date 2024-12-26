import 'package:exploreo/Screens/bookmarks_screen.dart';
import 'package:exploreo/Screens/chat_screen.dart';
import 'package:exploreo/Screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:exploreo/Components/color.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor, // Background set to white
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme:
            const IconThemeData(color: Colors.black), // AppBar icons black
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Information Row
            GestureDetector(
              onTap: () {
                // Navigate to Edit Profile Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
              },
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150', // Replace with user's image URL
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Doe',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Text color black
                          ),
                        ),
                        Text(
                          'johndoe@example.com',
                          style:
                              TextStyle(color: Colors.black54), // Subtle black
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: Colors.black),
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
                    onPressed: () {
                      // Logout action
                    },
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
