import 'package:flutter/material.dart';
import 'package:exploreo/Models/travel.dart';

class DetailView extends StatefulWidget {
  final int id;
  const DetailView({super.key, required this.id});

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Travel> travelList = Travel.getTravelItems();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: size.height * 0.6,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: GestureDetector(
                onTap: () {
                  // Open full image viewer as popup
                  showDialog(
                    context: context,
                    builder: (context) => FullImagePopup(
                      images: travelList[widget.id].imageUrl,
                    ),
                  );
                },
                child: FittedBox(
                  child: Image.asset(
                    travelList[widget.id].imageUrl[0],
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
                            travelList[widget.id].name,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.w600),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 30,
                              ),
                              Text(
                                travelList[widget.id].rating.toString(),
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
                                color: Color(0xff8f297f),
                              ),
                              const SizedBox(width: 5),
                              RichText(
                                text: TextSpan(
                                  text: r'$',
                                  style: TextStyle(
                                    color: Colors.black87.withOpacity(.5),
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: travelList[widget.id].cost
                                          .toString(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
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
                              RichText(
                                text: TextSpan(
                                  text: travelList[widget.id].location,
                                  style: TextStyle(
                                    color: Colors.black87.withOpacity(.5),
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '(${travelList[widget.id].distance} km)',
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Description
                      Text(
                        travelList[widget.id].description,
                        style: const TextStyle(
                          color: Color(0xff686771),
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Category and post ID
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Category: Travel',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            'Post ID: #p120',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Posted on: 2024/12/12',
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // More photos section
                      const Text(
                        'More Photos',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Displaying images vertically with rounded corners
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: travelList[widget.id].imageUrl.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: GestureDetector(
                                  onTap: () {
                                    // Open full image viewer as popup
                                    showDialog(
                                      context: context,
                                      builder: (context) => FullImagePopup(
                                        images: travelList[widget.id]
                                            .imageUrl,
                                        initialIndex: index,
                                      ),
                                    );
                                  },
                                  child: Image.asset(
                                    travelList[widget.id].imageUrl[index],
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                color: const Color(0xff8f294f),
                              ),
                            ),
                            child: Icon(
                              Icons.favorite_border,
                              color: Color(0xff8f294f),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                color: const Color(0xff8f294f),
                                border: Border.all(
                                  color: const Color(0xff8f294f),
                                ),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
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
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
        onTap: () => Navigator.of(context).pop(), // Close dialog when tapping outside
        child: Stack(
          children: [
            PageView.builder(
              itemCount: images.length,
              controller: PageController(initialPage: initialIndex),
              itemBuilder: (context, index) {
                return Image.asset(
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
