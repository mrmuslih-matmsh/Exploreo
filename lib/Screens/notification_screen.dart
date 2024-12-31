import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:exploreo/Components/color.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'PoppinsSemiBold',
            color: Colors.black,
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('notifications').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No notifications available',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontFamily: 'PoppinsRegular',
                ),
              ),
            );
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification =
                  notifications[index].data() as Map<String, dynamic>;
              final title = notification['title'] ?? 'No title';
              final message = notification['message'] ?? 'No message';
              final timestamp = notification['timestamp'] ?? DateTime.now();

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  margin: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  shadowColor: Colors.grey,
                  color: Colors.white,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/exploreo_icon_bg.png',
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'PoppinsSemiBold',
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        message,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontFamily: 'PoppinsRegular',
                        ),
                      ),
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        '${timestamp}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontFamily: 'PoppinsRegular',
                        ),
                      ),
                    ),
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
