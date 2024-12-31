import 'package:flutter/material.dart';
import '../Components/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exploreo/Screens/detail_view.dart';

class ViewAllScreen extends StatelessWidget {
  final String category;

  const ViewAllScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text(
          'Explore $category',
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'PoppinsSemiBold',
            color: Colors.black,
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            // Fetching and displaying the filtered travel list from Firestore
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                // Fetch data from Firestore based on category
                future: FirebaseFirestore.instance
                    .collection('posts')
                    .where('category', isEqualTo: category)
                    .orderBy('timestamp',
                        descending: true)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child:
                            CircularProgressIndicator(color: secondaryColor));
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading posts'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 18.0),
                        child: Text('No posts available',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontFamily: 'PoppinsRegular',
                            )),
                      ),
                    );
                  }

                  final filteredTravelList = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: filteredTravelList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final travel = filteredTravelList[index].data()
                          as Map<String, dynamic>;
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
                                    const SizedBox(height: 8.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              size: 23,
                                              color: Colors.amber,
                                            ),
                                            Text(
                                              travel['rating'].toString(),
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                fontFamily: 'PoppinsRegular',
                                                color: Colors.black,
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
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
