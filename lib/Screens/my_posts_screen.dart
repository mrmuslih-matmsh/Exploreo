import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exploreo/Components/color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'detail_view.dart';

class MyPostsScreen extends StatefulWidget {
  const MyPostsScreen({super.key});

  @override
  State<MyPostsScreen> createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends State<MyPostsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _postsStream;
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('email') ?? 'No email available';
      _postsStream = _firestore
          .collection('posts')
          .where('posted_by', isEqualTo: userEmail)
          .snapshots();
    });
  }

  Future<void> _deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post deleted successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete post: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text(
          'My Posts',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'PoppinsSemiBold',
            color: Colors.black,
          ),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _postsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong.'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No posts available.'));
          }
          final posts = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(15.0),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final travel = posts[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DetailView(
                          postid: travel['postid'],
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        child: Image.network(
                          travel['coverimage'],
                          fit: BoxFit.fill,
                          height: 55.0,
                          width: 55.0,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              travel['title'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'PoppinsMedium',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  travel['location'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontFamily: 'PoppinsMedium',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_rounded,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Delete Post'),
                                        content: const Text(
                                            'Are you sure you want to delete this post?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              _deletePost(travel.id);
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
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
          );
        },
      ),
    );
  }
}
