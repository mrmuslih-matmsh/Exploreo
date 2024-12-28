import 'package:exploreo/Components/color.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exploreo/Screens/detail_view.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  List<Map<String, dynamic>> _travelList = [];
  List<Map<String, dynamic>> _filteredTravelList = [];
  String _sortOption = 'a_to_z';
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTravelData();
    _searchController.addListener(_filterSearchResults);
  }

  Future<void> fetchTravelData() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('posts').get();
    final List<Map<String, dynamic>> fetchedData =
        querySnapshot.docs.map((doc) {
      return {
        'postid': doc['postid'],
        'title': doc['title'],
        'location': doc['location'],
        'rating': doc['rating'],
        'coverimage': doc['coverimage'],
      };
    }).toList();
    setState(() {
      _travelList = fetchedData;
      _filteredTravelList = fetchedData;
      sortData();
    });
  }

  void _filterSearchResults() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTravelList = _travelList.where((travel) {
        return travel['title'].toLowerCase().contains(query) ||
            travel['location'].toLowerCase().contains(query);
      }).toList();
      sortData();
    });
  }

  void sortData() {
    setState(() {
      if (_sortOption == 'a_to_z') {
        _filteredTravelList.sort((a, b) => a['title'].compareTo(b['title']));
      } else if (_sortOption == 'z_to_a') {
        _filteredTravelList.sort((a, b) => b['title'].compareTo(a['title']));
      } else if (_sortOption == 'new_to_old') {
        // Assuming data has a timestamp field
        _filteredTravelList
            .sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
      } else if (_sortOption == 'old_to_new') {
        _filteredTravelList
            .sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text(
          'Discover',
          style: TextStyle(
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
            // Search bar and sort icon
            Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.1),
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: const Icon(
                      Icons.search,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search Places',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'PoppinsRegular',
                          color: Colors.grey,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'PoppinsRegular',
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () async {
                        final option = await showModalBottomSheet<String>(
                          context: context,
                          builder: (BuildContext context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  title: const Text('A to Z'),
                                  onTap: () => Navigator.pop(context, 'a_to_z'),
                                ),
                                ListTile(
                                  title: const Text('Z to A'),
                                  onTap: () => Navigator.pop(context, 'z_to_a'),
                                ),
                                ListTile(
                                  title: const Text('New to Old'),
                                  onTap: () =>
                                      Navigator.pop(context, 'new_to_old'),
                                ),
                                ListTile(
                                  title: const Text('Old to New'),
                                  onTap: () =>
                                      Navigator.pop(context, 'old_to_new'),
                                ),
                              ],
                            );
                          },
                        );
                        if (option != null) {
                          setState(() {
                            _sortOption = option;
                            sortData();
                          });
                        }
                      },
                      child: const Icon(
                        Icons.sort,
                        size: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 26,
            ),
            // Travel list
            Expanded(
              child: _filteredTravelList.isEmpty
                  ? const Center(child: CircularProgressIndicator(color: secondaryColor,))
                  : ListView.builder(
                      itemCount: _filteredTravelList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final travel = _filteredTravelList[index];
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        travel['title'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'PoppinsMedium',
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis ,
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
                                            overflow: TextOverflow.ellipsis ,
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
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
