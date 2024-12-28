import 'package:exploreo/Components/color.dart';
import 'package:flutter/material.dart';

class FoodConnectCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String location;
  final String cost;
  final VoidCallback onTap;

  const FoodConnectCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.location,
    required this.cost,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                height: 70.0,
                width: 70.0,
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'PoppinsMedium',
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey,
                      fontFamily: 'PoppinsRegular',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    '\$${cost.toString()}',
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontFamily: 'PoppinsSemiBold',
                      color: secondaryColor,
                    ),
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
