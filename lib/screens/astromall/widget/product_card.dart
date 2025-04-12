import 'package:astrobandhan/utils/text.styles.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final double originalPrice;
  final double offerPrice;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.originalPrice,
    required this.offerPrice,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white, // Replace with kBackgroundColor if defined
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 150,
              width: double.infinity,
              child: CachedNetworkImage(
               
                imageUrl: imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                overflow: TextOverflow.ellipsis,
                title,
                style: poppinsStyle600SemiBold.copyWith(color: Colors.black),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: latoStyle300Light.copyWith(color: Colors.black38,fontSize: 12),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text(
                    "₹$offerPrice",
                    style:
                        poppinsStyle600SemiBold.copyWith(color: Colors.black,),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "₹$originalPrice",
                    style:
                        poppinsStyle600SemiBold.copyWith(color: Colors.black54,
                      decoration: TextDecoration.lineThrough,
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
