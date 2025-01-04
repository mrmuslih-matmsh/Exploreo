import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exploreo/Components/color.dart';
import 'package:exploreo/Screens/user_profile_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../Database/bookmark.dart';
import 'chat_screen.dart';

class DetailView extends StatefulWidget {
  final String postid;
  const DetailView({super.key, required this.postid});

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  double _rating = 0;
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkBookmark();
  }

  Future<void> _checkBookmark() async {
    final bookmarked =
        await BookmarkDatabase.instance.isBookmarked(widget.postid);
    setState(() {
      isBookmarked = bookmarked;
    });
  }

  Future<void> _toggleBookmark() async {
    if (isBookmarked) {
      // Remove bookmark
      await BookmarkDatabase.instance.removeBookmark(widget.postid);

      // Show dialog for bookmark removal
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Bookmark Removed',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'PoppinsMedium',
              ),
            ),
            content: const Text(
              'The post has been removed from your bookmarks.',
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black,
                fontFamily: 'PoppinsRegular',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      try {
        // Fetch post data from Firestore
        final postSnapshot = await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postid)
            .get();

        if (postSnapshot.exists) {
          final postData = postSnapshot.data()!;
          await BookmarkDatabase.instance.addBookmark({
            'postid': widget.postid,
            'coverImage': postData['coverimage'] ?? '',
            'title': postData['title'] ?? '',
            'location': postData['location'] ?? '',
          });

          // Show dialog for bookmark added
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  'Bookmark Added',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'PoppinsMedium',
                  ),
                ),
                content: const Text(
                  'The post has been added to your bookmarks.',
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontFamily: 'PoppinsRegular',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Handle case where post data doesn't exist
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post data not found.')),
          );
          return;
        }
      } catch (e) {
        // Handle any errors during Firestore fetch
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch post data.')),
        );
        return;
      }
    }

    // Update the UI
    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

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

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  // Fetching reviews and ratings for the post
  Stream<QuerySnapshot> getReviews() {
    return FirebaseFirestore.instance
        .collection('reviews')
        .where('postid', isEqualTo: widget.postid)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  final TextEditingController _reviewController = TextEditingController();

  Future<void> addReview() async {
    // Check if the review text is empty
    if (_reviewController.text.isEmpty) {
      // Show a warning if the review is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please write a review before submitting.')),
      );
      return;
    }

    try {
      // Add the review to the 'reviews' collection
      await FirebaseFirestore.instance.collection('reviews').add({
        'postid': widget.postid,
        'rating': _rating,
        'name': 'muslih',
        'reviewText': _reviewController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Calculate the average rating
      var reviewsSnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('postid', isEqualTo: widget.postid)
          .get();

      double totalRating = 0;
      int reviewCount = reviewsSnapshot.docs.length;

      // Loop through all the reviews and calculate the total rating
      for (var doc in reviewsSnapshot.docs) {
        totalRating += doc['rating'].toDouble();
      }

      // Calculate the average rating
      double averageRating = totalRating / reviewCount;

      // Update the post with the new average rating
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postid)
          .update({
        'rating': averageRating,
      });

      // Clear the text field and notify the user of success
      _reviewController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully!')),
      );
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to submit review. Please try again.')),
      );
    }
  }

  // Function to launch Google Maps
  Future<void> _launchMaps(String location) async {
    final Uri mapUrl = Uri.parse("google.navigation:q=$location");

    if (!await launchUrl(mapUrl)) {
      throw Exception('Could not launch $mapUrl');
    }
  }

  void _makeCall(String phoneNumber) async {
    final Uri _phoneUri = Uri(scheme: 'tel', path: phoneNumber);

    try {
      await launchUrl(_phoneUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Could not launch $phoneNumber: $e');
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
            return const Center(
                child: CircularProgressIndicator(
              color: secondaryColor,
            ));
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
                return const Center(
                    child: CircularProgressIndicator(
                  color: secondaryColor,
                ));
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
                    expandedHeight: size.height * 0.5,
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
                          fit: BoxFit.cover,
                          child: Image.network(
                            postData['coverimage'] ?? '',
                          ),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      postData['title'] ?? 'Untitled',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontFamily: 'PoppinsSemiBold',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 26,
                                      ),
                                      Text(
                                        postData['rating'].toString(),
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontFamily: 'PoppinsMedium',
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Cost and location
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  const SizedBox(width: 4),
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
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'PoppinsRegular',
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Description
                              Text(
                                postData['description'] ??
                                    'No description available.',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontFamily: 'PoppinsRegular',
                                ),
                                textAlign: TextAlign.justify,
                              ),
                              const SizedBox(height: 24),
                              // Category and post ID
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Category: ${postData['category']}',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black,
                                      fontFamily: 'PoppinsRegular',
                                    ),
                                  ),
                                  Text(
                                    'Post ID: ${postData['postid']}',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black,
                                      fontFamily: 'PoppinsRegular',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Posted on: ${postData['timestamp']}',
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontFamily: 'PoppinsRegular',
                                ),
                              ),
                              const SizedBox(height: 26),
                              // Publisher details
                              const Text(
                                'Publisher',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'PoppinsMedium',
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  ClipOval(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UserProfileScreen(
                                                    userEmail:
                                                        userData['email']),
                                          ),
                                        );
                                      },
                                      child: Image.network(
                                        userData['profile'] ?? '',
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            color: Colors.grey,
                                            fontFamily: 'PoppinsRegular',
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
                                          color: secondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: IconButton(
                                          icon: const Icon(Icons.chat),
                                          color: Colors.white,
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatScreen(
                                                  receiverEmail:
                                                      userData['email'],
                                                  receiverName:
                                                      userData['name'],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: secondaryColor,
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: IconButton(
                                          icon: const Icon(Icons.call),
                                          color: Colors.white,
                                          onPressed: () {
                                            _makeCall(userData['mobile']);
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
                                              builder: (context) =>
                                                  FullImagePopup(
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
                              const SizedBox(height: 30),
                              // Rating and Review Section
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Rating and Reviews',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'PoppinsMedium',
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // Show popup when "Add Review" is clicked
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Add Review',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'PoppinsSemiBold',
                                                color: Colors.black,
                                              ),
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                // Rating Bar inside popup
                                                RatingBar.builder(
                                                  initialRating: _rating,
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemSize: 30,
                                                  itemPadding: const EdgeInsets
                                                      .symmetric(horizontal: 4),
                                                  onRatingUpdate: (rating) {
                                                    setState(() {
                                                      _rating = rating;
                                                    });
                                                  },
                                                  itemBuilder:
                                                      (context, index) => Icon(
                                                    Icons.star,
                                                    color: index < _rating
                                                        ? Colors.amber
                                                        : Colors.grey,
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                // Review Text Box inside popup
                                                TextField(
                                                  controller: _reviewController,
                                                  maxLines: 4,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Write your review here...',
                                                    hintStyle: const TextStyle(
                                                      fontSize: 14,
                                                      fontFamily:
                                                          'PoppinsRegular',
                                                      color: Colors.grey,
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide: const BorderSide(
                                                        color: secondaryColor,
                                                        width: 1.5,
                                                      ),
                                                    ),
                                                  ),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                        'PoppinsRegular',
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                // Submit Button inside popup
                                                ElevatedButton(
                                                  onPressed: addReview,
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        secondaryColor,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10,
                                                        horizontal: 14),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'Submit Review',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontFamily:
                                                          'PoppinsMedium',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: const Text(
                                      'Add Review',
                                      style: TextStyle(
                                        color:
                                            secondaryColor, // Use secondary color here
                                        fontSize: 14,
                                        fontFamily: 'PoppinsMedium',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              // Show reviews
                              StreamBuilder<QuerySnapshot>(
                                stream: getReviews(),
                                builder: (context, reviewSnapshot) {
                                  if (reviewSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator(
                                            color: secondaryColor));
                                  }

                                  if (!reviewSnapshot.hasData ||
                                      reviewSnapshot.data!.docs.isEmpty) {
                                    return const Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Text('No reviews yet.',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey)),
                                    );
                                  }

                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: reviewSnapshot
                                                    .data!.docs.length,
                                                itemBuilder: (context, index) {
                                                  var reviewData =
                                                      reviewSnapshot
                                                              .data!.docs[index]
                                                              .data()
                                                          as Map<String,
                                                              dynamic>;
                                                  var rating =
                                                      reviewData['rating'] ?? 0;
                                                  var reviewText = reviewData[
                                                          'reviewText'] ??
                                                      '';
                                                  var reviewerName = reviewData[
                                                          'name'] ??
                                                      'Anonymous'; // Reviewer Name

                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 8),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // Reviewer's Name and Rating
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              reviewerName,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'PoppinsMedium',
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                const Icon(
                                                                    Icons.star,
                                                                    color: Colors
                                                                        .amber,
                                                                    size: 18),
                                                                const SizedBox(
                                                                    width: 5),
                                                                Text(
                                                                  '$rating/5',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        'PoppinsRegular',
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        // Review Text
                                                        Text(
                                                          reviewText,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.grey,
                                                            fontFamily:
                                                                'PoppinsRegular',
                                                          ),
                                                          textAlign:
                                                              TextAlign.justify,
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap:
                                        _toggleBookmark, // Handles the onPressed action
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        border: Border.all(
                                          color: secondaryColor,
                                        ),
                                      ),
                                      child: Center(
                                        // Ensures the icon is centered
                                        child: Icon(
                                          isBookmarked
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: isBookmarked
                                              ? Colors.red
                                              : Colors.red,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () =>
                                          _launchMaps(postData['location']),
                                      child: Container(
                                        height: 50,
                                        padding: const EdgeInsets.all(9),
                                        decoration: const BoxDecoration(
                                          color: secondaryColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Discover',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                              fontFamily: 'PoppinsMedium',
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
