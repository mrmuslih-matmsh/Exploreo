import 'package:flutter/material.dart';

class FeaturedCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String location;
  final VoidCallback onTap;

  const FeaturedCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double cardWidth = 220.0;
    double cardHeight = cardWidth * 0.4;

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(24),
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                child: Container(
                  width: cardWidth - 40,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, .5),
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'PoppinsMedium',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            location,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'PoppinsRegular',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}
