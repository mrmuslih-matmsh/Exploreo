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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.menu, // Menu icon
              size: 30,
              color: secondaryColor,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_on,
                  size: 20,
                  color: secondaryColor,
                ),
                const SizedBox(
                  width: 2,
                ),
                const Text(
                  'Sri Lanka',
                  style: TextStyle(color: secondaryColor, fontSize: 16.0),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: secondaryColor,
                )
              ],
            ),
            const Icon(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
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
                    .collection('travels')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final travelData = snapshot.data!.docs;

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
                          imageUrl: travelItem['image'],
                          name: travelItem['name'],
                          location: travelItem['location'],
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DetailView(
                                id: travelItem['name'],
                              ),
                            ));
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
                children: const [
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
                    .collection('travels') // Collection for Explore Tours
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final exploreToursData = snapshot.data!.docs;

                  return Container(
                    margin: const EdgeInsets.only(top: 16),
                    height: size.height * .3,
                    child: ListView.builder(
                      itemCount: exploreToursData.length,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var exploreTourItem = exploreToursData[index];

                        return ExploreTourCard(
                          imageUrl: exploreTourItem['image'],
                          name: exploreTourItem['name'],
                          location: exploreTourItem['location'],
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DetailView(
                                id: exploreTourItem['name'],
                              ),
                            ));
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
                children: const [
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
                stream:
                    FirebaseFirestore.instance.collection('foods').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final foodConnectData = snapshot.data!.docs;

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
                          imageUrl: foodItem['image'],
                          name: foodItem['name'],
                          location: foodItem['location'],
                          cost: foodItem['cost'],
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DetailView(
                                id: foodItem['name'],
                              ),
                            ));
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
                children: const [
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
                stream:
                    FirebaseFirestore.instance.collection('skills').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final skillsData = snapshot.data!.docs;

                  return Container(
                    margin: const EdgeInsets.only(top: 16), // Add margin here
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: skillsData.length,
                      itemBuilder: (context, index) {
                        var skillItem = skillsData[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: SkillCard(
                            name: skillItem['name'],
                            location: skillItem['location'],
                            rating: skillItem['rating'],
                            imageUrl: skillItem['image'],
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DetailView(
                                    id: skillItem['name'],
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
