import 'package:flutter/material.dart';

class SkillCard extends StatelessWidget {
  final String name;
  final String location;
  final String rating;
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'PoppinsSemiBold',
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      location,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xff686771),
                        fontFamily: 'PoppinsMedium',
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 20,
                        ),
                        Text(
                          rating,
                          style: const TextStyle(
                            fontSize: 14,
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
    );
  }
}
