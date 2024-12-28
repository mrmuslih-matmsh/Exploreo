import 'package:flutter/material.dart';

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
          width: size.width * 0.5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Image.network(
                  imageUrl,
                  height: size.width * 0.3,
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
                        fontSize: 14,
                        fontFamily: 'PoppinsMedium',
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        // Location Text with Ellipsis overflow
                        Expanded(
                          child: Text(
                            location,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontFamily: 'PoppinsMedium',
                            ),
                            overflow: TextOverflow.ellipsis,
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
