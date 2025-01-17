import 'package:exploreo/Screens/main_screen.dart';
import 'package:exploreo/Screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:exploreo/Components/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Set a delay before navigating to the main screen
    Future.delayed(const Duration(seconds: 4), () async {
      if (mounted) {
        final prefs = await SharedPreferences.getInstance();
        final email = prefs.getString('email');
        final name = prefs.getString('name');

        if (email != null && name != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: primaryColor,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50.0),
              // Logo image
              Image(
                image: AssetImage('assets/exploreo_trans.png'),
                width: 185.0,
                height: 185.0,
              ),
              Spacer(),
              // Version info
              Text(
                'Version: 1.0.0',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                  fontFamily: "PoppinsRegular",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
