import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exploreo/Screens/detail_view.dart';

class ExploreTourCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String location;
  final VoidCallback onTap;

  const ExploreTourCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size.width * 0.5, // Adjust card width (square shape)
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15), // Rounded top corners
                ),
                child: Image.network(
                  imageUrl,
                  height: size.width * 0.4, // Square image height
                  width: double.infinity,
                  fit: BoxFit.cover, // Image cover
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Text with Ellipsis overflow
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'PoppinsSemiBold',
                      ),
                      maxLines: 1, // Restrict to one line
                      overflow: TextOverflow.ellipsis, // Show ellipsis on overflow
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
                        // Location Text with Ellipsis overflow
                        Expanded(
                          child: Text(
                            location,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontFamily: 'PoppinsMedium',
                            ),
                            overflow: TextOverflow.ellipsis, // Show ellipsis on overflow
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
  }
}
