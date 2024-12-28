import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exploreo/Screens/detail_view.dart';
import 'package:exploreo/Components/color.dart';
import 'package:exploreo/Components/featured_card.dart';
import 'package:exploreo/Components/explore_tour_card.dart';
import 'package:exploreo/Components/food_card.dart';
import 'package:exploreo/Components/skill_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.menu, // Menu icon
              size: 30,
              color: secondaryColor,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  size: 20,
                  color: secondaryColor,
                ),
                SizedBox(
                  width: 2,
                ),
                Text(
                  'Sri Lanka',
                  style: TextStyle(color: secondaryColor, fontSize: 16.0),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: secondaryColor,
                )
              ],
            ),
            Icon(
              Icons.notifications_none_rounded, // Notification icon
              size: 30,
              color: secondaryColor,
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
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
              RichText(
                text: TextSpan(
                  text: 'Discover',
                  style: const TextStyle(
                    fontFamily: 'PoppinsMedium',
                    color: secondaryColor,
                    fontSize: 28,
                    height: 1.3,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' the Best Places to Travel',
                      style: TextStyle(
                        fontFamily: 'PoppinsSemiBold',
                        fontSize: 26,
                        color: Colors.black.withOpacity(.8),
                      ),
                    ),
                  ],
                ),
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
                      fontSize: 20,
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
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final travelData = snapshot.data!.docs;

                  if (travelData.isEmpty) {
                    return const Center(child: Text('No Featured Posts Available'));
                  }

                  return Container(
                    margin: const EdgeInsets.only(top: 16),
                    height: size.height * .4,
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Explore Tours',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'PoppinsMedium',
                    ),
                  ),
                  Text(
                    'View All',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'PoppinsMedium',
                        color: secondaryColor),
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
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final exploreToursData = snapshot.data!.docs;

                  if (exploreToursData.isEmpty) {
                    return const Center(child: Text('No Explore Tours Available'));
                  }

                  return Container(
                    margin: const EdgeInsets.only(top: 16),
                    height: size.height * .275,
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Food Connect',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'PoppinsMedium',
                    ),
                  ),
                  Text(
                    'View All',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'PoppinsMedium',
                        color: secondaryColor),
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
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final foodConnectData = snapshot.data!.docs;

                  if (foodConnectData.isEmpty) {
                    return const Center(child: Text('No Food Connect Posts Available'));
                  }

                  return Container(
                    margin: const EdgeInsets.only(top: 16),
                    height: size.height * .120,
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Skill Swap',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'PoppinsMedium',
                    ),
                  ),
                  Text(
                    'View All',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'PoppinsMedium',
                        color: secondaryColor),
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
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final skillsData = snapshot.data!.docs;

                  if (skillsData.isEmpty) {
                    return const Center(child: Text('No Skill Swap Posts Available'));
                  }

                  return Container(
                    margin: const EdgeInsets.only(top: 16),
                    height: size.height * .120,
                    child: ListView.builder(
                      itemCount: skillsData.length,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var skillItem = skillsData[index];

                        return SkillCard(
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
