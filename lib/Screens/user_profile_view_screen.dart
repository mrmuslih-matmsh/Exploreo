import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:exploreo/Components/color.dart';

import 'detail_view.dart';

class UserProfileScreen extends StatefulWidget {
  final String userEmail;

  const UserProfileScreen({super.key, required this.userEmail});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String? userName;
  String? userLocation;
  String? profileImage;
  bool isLoading = true;
  List<Map<String, dynamic>> recentPosts = [];

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userEmail)
          .get();

      if (userDoc.exists) {
        setState(() {
          userName = userDoc['name'];
          userLocation = userDoc['location'];
          profileImage = userDoc['profile'];
        });
      }

      final postsSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('posted_by', isEqualTo: widget.userEmail)
          .get();

      setState(() {
        recentPosts = postsSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error loading user profile: $e");
    }
  }

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
          'User Profile',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'PoppinsSemiBold',
            color: Colors.black,
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: profileImage != null
                            ? NetworkImage(profileImage!)
                            : const AssetImage('assets/exploreo_icon_bg.png')
                                as ImageProvider,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName ?? 'No Name',
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'PoppinsMedium',
                              ),
                            ),
                            Text(
                              userLocation ?? 'No Location',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontFamily: 'PoppinsRegular',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Recent Posts",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'PoppinsMedium',
                    ),
                  ),
                  const SizedBox(height: 20),
                  recentPosts.isEmpty
                      ? const Text(
                          "No recent posts available.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: recentPosts.length,
                          itemBuilder: (context, index) {
                            final post = recentPosts[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => DetailView(
                                      postid: post['postid'],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(15),
                                      ),
                                      child: Image.network(
                                        post['coverimage'],
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            post['title'] ?? 'No Title',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'PoppinsMedium',
                                              color: Colors.black,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                color: Colors.red,
                                                size: 14,
                                              ),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  post['location'] ??
                                                      'No Location',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                    fontFamily: 'PoppinsMedium',
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
    );
  }
}
