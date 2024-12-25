import 'package:flutter/material.dart';

// Bookmark Post Model
class BookmarkPost {
  final String imageUrl;
  final String title;
  final String category;
  final String publishDate;

  BookmarkPost({
    required this.imageUrl,
    required this.title,
    required this.category,
    required this.publishDate,
  });
}

class BookmarksScreen extends StatelessWidget {
  BookmarksScreen({super.key});

  // Sample bookmark data (replace this with actual data from Firebase or local storage)
  final List<BookmarkPost> bookmarkedPosts = [
    BookmarkPost(
      imageUrl: 'https://via.placeholder.com/150',
      title: 'Post Title 1',
      category: 'Category 1',
      publishDate: '2024-12-24',
    ),
    BookmarkPost(
      imageUrl: 'https://via.placeholder.com/150',
      title: 'Post Title 2',
      category: 'Category 2',
      publishDate: '2024-12-23',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: ListView.builder(
        itemCount: bookmarkedPosts.length,
        itemBuilder: (context, index) {
          final post = bookmarkedPosts[index];

          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10.0),
              leading: Image.network(post.imageUrl, width: 50, height: 50),
              title: Text(post.title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.category),
                  Text('Published: ${post.publishDate}',
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteConfirmationDialog(context, index),
              ),
            ),
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
              onPressed: () {
                // Perform the deletion action (e.g., remove from the list or Firebase)
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
