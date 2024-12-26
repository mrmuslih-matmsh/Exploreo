import 'package:exploreo/Components/color.dart';
import 'package:flutter/material.dart';
import 'package:exploreo/Models/travel.dart';
import 'package:exploreo/Screens/detail_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Travel> _travelList = Travel.getTravelItems();

    void addData() async {
      CollectionReference users = FirebaseFirestore.instance.collection('users');

      await users.add({
        'name': 'John Doeeee',
        'email': 'john@exsample.com',
        'age': 252,
      });
    }

    addData();

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
                  Icons.location_on, // Location pin icon
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
          padding: EdgeInsets.all(16.0),
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
              Container(
                margin: const EdgeInsets.only(top: 16),
                height: size.height * .4,
                child: ListView.builder(
                  itemCount: _travelList.length,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DetailView(id: index),
                          ));
                        },
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(24),
                              ),
                              child:
                                  Image.asset(_travelList[index].imageUrl[0]),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 20,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(0, 0, 0, .5),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _travelList[index].name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: 'PoppinsSemiBold',
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          _travelList[index].location,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontFamily: 'PoppinsMedium',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
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
              Container(
                margin: EdgeInsets.only(top: 16),
                height: size.height * 0.3, // Reduced card height
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // Horizontal scrolling
                  itemCount: _travelList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 15.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DetailView(id: index),
                            ),
                          );
                        },
                        child: Container(
                          width: size.width * 0.5, // Square card width
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15),
                                ),
                                child: Image.asset(
                                  _travelList[index].imageUrl[1],
                                  height:
                                      size.width * 0.4, // Square image height
                                  width: double.infinity,
                                  fit: BoxFit.cover, // Image cover
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _travelList[index].name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'PoppinsSemiBold',
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          color: Colors.grey,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            _travelList[index].location,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                              fontFamily: 'PoppinsMedium',
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color:
                                              Colors.amber, // Gold star color
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          _travelList[index].rating.toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontFamily: 'PoppinsRegular',
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
                      ),
                    );
                  },
                ),
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
              Container(
                margin: EdgeInsets.only(top: 16),
                child: SingleChildScrollView(
                  scrollDirection:
                      Axis.horizontal, // Enable horizontal scrolling
                  child: Row(
                    children: List.generate(_travelList.length, (index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            right: 15.0), // Spacing between cards
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DetailView(id: index),
                              ),
                            );
                          },
                          child: Container(
                            width:
                                size.width * 0.7, // Adjust card width as needed
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.white, // Card background color
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    _travelList[index].imageUrl[1],
                                    fit: BoxFit.cover,
                                    height: 75.0, // Small square image
                                    width: 75.0,
                                  ),
                                ),
                                const SizedBox(
                                    width:
                                        10.0), // Space between image and text
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _travelList[index].name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'PoppinsSemiBold',
                                        ),
                                        overflow: TextOverflow
                                            .ellipsis, // Handle long names
                                      ),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        _travelList[index].location,
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xff686771),
                                          fontFamily: 'PoppinsMedium',
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        '\$${_travelList[index].cost}',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontFamily: 'PoppinsSemiBold',
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
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
              Container(
                margin: EdgeInsets.only(top: 16),
                height: size.height * .4,
                child: ListView.builder(
                    itemCount: _travelList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 15.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DetailView(id: index)));
                          },
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                child: Image.asset(
                                  _travelList[index].imageUrl[1],
                                  fit: BoxFit.fill,
                                  height: 60.0,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _travelList[index].name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'PoppinsSemiBold',
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _travelList[index].location,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            color: Color(0xff686771),
                                            fontFamily: 'PoppinsMedium',
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons
                                                  .star, // Star icon for ratings
                                              size: 30,
                                              color: Colors
                                                  .amber, // Gold color for a star
                                            ),
                                            Text(
                                              _travelList[index]
                                                  .rating
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 16.0,
                                                fontFamily: 'PoppinsRegular',
                                              ),
                                            ),
                                          ],
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
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
