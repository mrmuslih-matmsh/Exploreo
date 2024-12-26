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
      backgroundColor: const Color(0xFFFCFCFC), // Background set to white
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: const Color(0xFFFCFCFC),
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
            const SizedBox(height: 50),
            // Buttons at the bottom
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Bookmarks screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookmarksScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // White background
                    side: const BorderSide(color: Colors.black, width: 1.0),
                    elevation: 0, // No shadow
                    minimumSize: const Size.fromHeight(50),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.bookmark, color: secondaryColor),
                      SizedBox(width: 8),
                      Text(
                        'Bookmarks',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Chat screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // White background
                    side: const BorderSide(color: Colors.black, width: 1.0),
                    elevation: 0, // No shadow
                    minimumSize: const Size.fromHeight(50),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.chat, color: secondaryColor),
                      SizedBox(width: 8),
                      Text(
                        'Chat',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Open Support Page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // White background
                    side: const BorderSide(color: Colors.black, width: 1.0),
                    elevation: 0, // No shadow
                    minimumSize: const Size.fromHeight(50),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.support_agent, color: secondaryColor),
                      SizedBox(width: 8),
                      Text(
                        'Support',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Logout action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // White background
                    side: const BorderSide(color: Colors.black, width: 1.0),
                    elevation: 0, // No shadow
                    minimumSize: const Size.fromHeight(50),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.logout, color: secondaryColor),
                      SizedBox(width: 8),
                      Text(
                        'Logout',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
            const Spacer(),
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
}
