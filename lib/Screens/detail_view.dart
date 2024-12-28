import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exploreo/Components/color.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailView extends StatefulWidget {
  final String postid;
  const DetailView({super.key, required this.postid});

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  // Fetching post data from Firestore
  Future<DocumentSnapshot> getPostData() async {
    return await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postid)
        .get();
  }

  // Fetching user data from Firestore
  Future<DocumentSnapshot> getUserData(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .get();
  }

  // Function to launch Google Maps
  Future<void> _launchMaps(String location) async {

    final Uri mapUrl = Uri.parse("google.navigation:q=$location");

    if (!await launchUrl(mapUrl)) {
      throw Exception('Could not launch $mapUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: getPostData(),
        builder: (context, postSnapshot) {
          if (postSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!postSnapshot.hasData || postSnapshot.data == null) {
            return const Center(child: Text('No post found.'));
          }

          var postData = postSnapshot.data!.data() as Map<String, dynamic>?;

          if (postData == null) {
            return const Center(child: Text('Post data is empty.'));
          }

          var images = List<String>.from(postData['images'] ?? []);
          var userEmail = postData['posted_by'];

          return FutureBuilder<DocumentSnapshot>(
            future: getUserData(userEmail),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!userSnapshot.hasData || userSnapshot.data == null) {
                return const Center(child: Text('No user found.'));
              }

              var userData = userSnapshot.data!.data() as Map<String, dynamic>?;

              if (userData == null) {
                return const Center(child: Text('User data is empty.'));
              }

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: size.height * 0.6,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    flexibleSpace: FlexibleSpaceBar(
                      background: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => FullImagePopup(
                              images: images,
                            ),
                          );
                        },
                        child: FittedBox(
                          child: Image.network(
                            postData['coverimage'] ?? '',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title and rating
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    postData['title'] ?? 'Untitled',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontFamily: 'PoppinsSemiBold'),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 30,
                                      ),
                                      Text(
                                        postData['rating'].toString(),
                                        style: const TextStyle(fontSize: 16.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Cost and location
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.account_balance_wallet,
                                        color: secondaryColor,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'LKR ${postData['price']}' ??
                                            'Price not available',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontFamily: 'PoppinsMedium',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        '${postData['location']}',
                                        style: TextStyle(
                                          color: Colors.black87.withOpacity(.5),
                                          fontFamily: 'PoppinsMedium',
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Description
                              Text(
                                postData['description'] ?? 'No description available.',
                                style: const TextStyle(
                                  color: Color(0xff686771),
                                  fontSize: 16,
                                  fontFamily: 'PoppinsRegular',
                                ),
                                textAlign: TextAlign.justify,
                              ),
                              const SizedBox(height: 20),
                              // Category and post ID
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Category: ${postData['category']}',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black54,
                                      fontFamily: 'PoppinsMedium',
                                    ),
                                  ),
                                  Text(
                                    'Post ID: ${postData['postid']}',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black54,
                                      fontFamily: 'PoppinsMedium',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Posted on: ${postData['timestamp']}',
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black54,
                                  fontFamily: 'PoppinsMedium',
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Publisher details
                              const Text(
                                'Publisher',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'PoppinsMedium',
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  ClipOval(
                                    child: Image.network(
                                      userData['profile'] ?? '',
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userData['name'] ?? 'Unknown',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'PoppinsMedium',
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          userData['location'] ??
                                              'No location provided',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                            fontFamily: 'PoppinsMedium',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                        child: IconButton(
                                          icon: const Icon(Icons.chat_bubble_outline),
                                          color: Colors.black,
                                          onPressed: () {
                                            // Chat functionality
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                        child: IconButton(
                                          icon: const Icon(Icons.call),
                                          color: Colors.black,
                                          onPressed: () {
                                            // Call functionality
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // More photos section
                              const Text(
                                'More Images',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'PoppinsMedium',
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: images.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => FullImagePopup(
                                                images: images,
                                                initialIndex: index,
                                              ),
                                            );
                                          },
                                          child: Image.network(
                                            images[index],
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Buttons at the bottom
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                        color: secondaryColor,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.favorite_border,
                                      color: secondaryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => _launchMaps(postData['location']),
                                      child: Container(
                                        padding: const EdgeInsets.all(9),
                                        decoration: BoxDecoration(
                                          color: secondaryColor,
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Discover',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ),
                                      ),
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
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class FullImagePopup extends StatelessWidget {
  final List<String> images;
  final int initialIndex;

  const FullImagePopup({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Stack(
          children: [
            PageView.builder(
              itemCount: images.length,
              controller: PageController(initialPage: initialIndex),
              itemBuilder: (context, index) {
                return Image.network(
                  images[index],
                  fit: BoxFit.contain,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
