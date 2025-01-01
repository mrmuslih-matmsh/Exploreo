import 'package:flutter/material.dart';
import 'package:exploreo/Components/color.dart';
import 'package:exploreo/screens/detail_view.dart';

import '../Database/bookmark.dart'; // Ensure this import is correct

// Bookmark Post Model
class BookmarkPost {
  final String postid;
  final String imageUrl;
  final String title;
  final String location;

  BookmarkPost({
    required this.postid,
    required this.imageUrl,
    required this.title,
    required this.location,
  });
}

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  _BookmarksScreenState createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  late Future<List<BookmarkPost>> _bookmarkedPosts;

  @override
  void initState() {
    super.initState();
    _bookmarkedPosts = _loadBookmarks();
  }

  // Load bookmarks from the SQLite database
  Future<List<BookmarkPost>> _loadBookmarks() async {
    final List<Map<String, dynamic>> bookmarks =
        await BookmarkDatabase.instance.getBookmarks();

    return bookmarks.map((bookmark) {
      return BookmarkPost(
        postid: bookmark['postid'],
        imageUrl: bookmark['coverImage'],
        title: bookmark['title'],
        location: bookmark['location'],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text(
          'Bookmarks',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'PoppinsSemiBold',
            color: Colors.black,
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: FutureBuilder<List<BookmarkPost>>(
        future: _bookmarkedPosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: secondaryColor,
            ));
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading bookmarks'));
          }

          final bookmarkedPosts = snapshot.data;

          if (bookmarkedPosts == null || bookmarkedPosts.isEmpty) {
            return const Center(
                child: Text('No bookmarks found',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: 'PoppinsRegular',
                    )));
          }

          return ListView.builder(
            itemCount: bookmarkedPosts.length,
            itemBuilder: (context, index) {
              final post = bookmarkedPosts[index];

              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.white,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10.0),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(post.imageUrl,
                        height: 55, width: 55, fit: BoxFit.cover),
                  ),
                  title: Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'PoppinsMedium',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.location,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: 'PoppinsRegular',
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DetailView(
                          postid: post.postid,
                        ),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () =>
                        _showDeleteConfirmationDialog(context, index),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Show delete confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Bookmark'),
          content: const Text('Are you sure you want to delete this bookmark?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Perform the deletion action (remove from the database)
                final post = await BookmarkDatabase.instance
                    .getBookmarks()
                    .then((value) => value[index]);
                await BookmarkDatabase.instance.removeBookmark(post['postid']);
                setState(() {
                  _bookmarkedPosts =
                      _loadBookmarks(); // Reload the bookmarks list
                });
                Navigator.pop(context);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
