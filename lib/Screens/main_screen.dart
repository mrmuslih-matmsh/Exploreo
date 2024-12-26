import 'package:exploreo/Screens/discover.dart';
import 'package:exploreo/Screens/new_post.dart';
import 'package:exploreo/Screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:exploreo/Components/color.dart';
import 'home.dart';
import 'discover.dart';
import 'new_post.dart';
import 'ai_tips.dart';
import 'profile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomeScreen(),
    const DiscoverScreeen(),
    const NewPostScreen(),
    const AiTipsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: secondaryColor,
        unselectedItemColor: logoBlackColor,
        selectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: 'PoppinsMedium',
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontFamily: 'PoppinsRegular',
        ),
        elevation: 8.0, // Adds shadow for a floating effect
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: secondaryColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.add,
                size: 30,
                color: Colors.white,
              ),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: 'Tips',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
