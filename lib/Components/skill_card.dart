import 'package:flutter/material.dart';

class SkillCard extends StatelessWidget {
  final String name;
  final String location;
  final double rating;
  final String imageUrl;
  final VoidCallback onTap;

  const SkillCard({
    Key? key,
    required this.name,
    required this.location,
    required this.rating,
    required this.imageUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0), // Optional margin
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.fill,
                height: 55.0,
                width: 55.0,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'PoppinsMedium',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded( // Use Expanded here to ensure location text doesn't overflow
                        child: Text(
                          location,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontFamily: 'PoppinsMedium',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 23,
                            color: Colors.amber,
                          ),
                          Text(
                            '$rating',
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
  }
}
