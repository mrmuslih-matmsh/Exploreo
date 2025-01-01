import 'package:exploreo/Screens/notification_screen.dart';
import 'package:exploreo/Screens/profile.dart';
import 'package:exploreo/Screens/view_all.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exploreo/Screens/detail_view.dart';
import 'package:exploreo/Components/color.dart';
import 'package:exploreo/Components/featured_card.dart';
import 'package:exploreo/Components/explore_tour_card.dart';
import 'package:exploreo/Components/food_card.dart';
import 'package:exploreo/Components/skill_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userProfile = prefs.getString('profile');
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.menu,
              size: 30,
              color: secondaryColor,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  size: 20,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 2,
                ),
                Text(
                  'Sri Lanka',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontFamily: 'PoppinsRegular',
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black,
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                // Navigate to the notification screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationScreen()),
                );
              },
              child: const Icon(
                Icons.notifications_none_outlined,
                size: 26,
                color: secondaryColor,
              ),
            )
          ],
        ),
        centerTitle: false,
        backgroundColor: primaryColor,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RichText(
                      text: const TextSpan(
                        text: 'Exploreo\n',
                        style: TextStyle(
                          fontFamily: 'PoppinsSemiBold',
                          color: secondaryColor,
                          fontSize: 20,
                          height: 1.5,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Explore more, Experience deeper',
                            style: TextStyle(
                              fontFamily: 'PoppinsRegular',
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfileScreen()));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        '${_userProfile}',
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 34,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Featured',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'PoppinsMedium',
                    ),
                  ),
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .where('category', isEqualTo: 'Local Tours')
                    .orderBy('timestamp', descending: true)
                    .limit(5)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: secondaryColor,
                    ));
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final travelData = snapshot.data!.docs;

                  if (travelData.isEmpty) {
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 18.0),
                        child: const Text('No Featured Posts Available',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontFamily: 'PoppinsRegular',
                            )),
                      ),
                    );
                  }

                  return Container(
                    margin: const EdgeInsets.only(top: 16),
                    height: size.height * .35,
                    child: ListView.builder(
                      itemCount: travelData.length,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var travelItem = travelData[index];

                        return FeaturedCard(
                          imageUrl: travelItem['coverimage'],
                          name: travelItem['title'],
                          location: travelItem['location'],
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DetailView(
                                  postid: travelItem['postid'],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Explore Tours',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'PoppinsMedium',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ViewAllScreen(category: 'Local Tours'),
                        ),
                      );
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'PoppinsMedium',
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .where('category', isEqualTo: 'Local Tours')
                    .orderBy('title')
                    .limit(10)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: secondaryColor,
                    ));
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final exploreToursData = snapshot.data!.docs;

                  if (exploreToursData.isEmpty) {
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 18.0),
                        child: const Text('No Explore Tours Available',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontFamily: 'PoppinsRegular',
                            )),
                      ),
                    );
                  }

                  return Container(
                    margin: const EdgeInsets.only(top: 16),
                    height: size.height * .24,
                    child: ListView.builder(
                      itemCount: exploreToursData.length,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var exploreTourItem = exploreToursData[index];

                        return ExploreTourCard(
                          imageUrl: exploreTourItem['coverimage'],
                          name: exploreTourItem['title'],
                          location: exploreTourItem['location'],
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DetailView(
                                  postid: exploreTourItem['postid'],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Food Connect',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'PoppinsMedium',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ViewAllScreen(category: 'Food Sharing'),
                        ),
                      );
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'PoppinsMedium',
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .where('category', isEqualTo: 'Food Sharing')
                    .orderBy('timestamp', descending: true)
                    .limit(10)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: secondaryColor,
                    ));
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final foodConnectData = snapshot.data!.docs;

                  if (foodConnectData.isEmpty) {
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 18.0),
                        child: const Text('No Food Connect Posts Available',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontFamily: 'PoppinsRegular',
                            )),
                      ),
                    );
                  }
                  return Container(
                    margin: const EdgeInsets.only(top: 16),
                    height: size.height * .11,
                    child: ListView.builder(
                      itemCount: foodConnectData.length,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var foodItem = foodConnectData[index];

                        return FoodConnectCard(
                          imageUrl: foodItem['coverimage'],
                          name: foodItem['title'],
                          location: foodItem['location'],
                          cost: foodItem['price'],
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DetailView(
                                  postid: foodItem['postid'],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Skill Swap',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'PoppinsMedium',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ViewAllScreen(category: 'Skills Exchange'),
                        ),
                      );
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'PoppinsMedium',
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .where('category', isEqualTo: 'Skills Exchange')
                    .orderBy('timestamp', descending: true)
                    .limit(10)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: secondaryColor,
                    ));
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final skillsData = snapshot.data!.docs;

                  if (skillsData.isEmpty) {
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 18.0),
                        child: const Text('No Skill Swap Posts Available',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontFamily: 'PoppinsRegular',
                            )),
                      ),
                    );
                  }
                  return Container(
                    margin: const EdgeInsets.only(top: 16),
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: ListView.builder(
                      itemCount: skillsData.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        var skillItem = skillsData[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: SkillCard(
                            imageUrl: skillItem['coverimage'],
                            name: skillItem['title'],
                            location: skillItem['location'],
                            rating: skillItem['rating'],
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DetailView(
                                    postid: skillItem['postid'],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
