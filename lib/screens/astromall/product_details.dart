import 'package:astrobandhan/datasource/model/astromall/product_model.dart';
import 'package:astrobandhan/helper/helper.dart';
import 'package:astrobandhan/screens/astromall/astromall_checkout.dart';
import 'package:astrobandhan/utils/app_colors.dart';
import 'package:astrobandhan/utils/text.styles.dart';
import 'package:astrobandhan/widgets/custom_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:readmore/readmore.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  static const _gradientColors = [
    Color.fromRGBO(170, 255, 0, 0.4),
    Color.fromRGBO(60, 0, 255, 0.4),
  ];
  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: kBackgroundColor),
        centerTitle: true,
        title: Text("PRODUCT DETAILS",
            style: poppinsStyle600SemiBold.copyWith(fontSize: 17)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.topLeft,
                      colors: _gradientColors,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Color.fromRGBO(170, 255, 0, 0.50),
                      width: 0.4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(8.0), // Adjust padding as needed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "${product.rating}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Inter',
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                              12.0), // Adjust the radius as needed
                          child: CachedNetworkImage(
                            imageUrl: '${product.image}',
                            fit: BoxFit.cover,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Gap(10),
                Text(product.productName ?? "",
                    style: poppinsStyle500Medium.copyWith(fontSize: 20)),
                Gap(10),
                ReadMoreText(
                  product.productDescription ?? "",
                  trimLines: 3,
                  colorClickableText: Colors.white,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Read More',
                  trimExpandedText: 'Read Less',
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    color: Colors.white54,
                  ),
                ),
                Gap(30),
                CustomButtons.saveButton(
                    onPressed: () {
                      Helper.toReplacementScreenSlideLeftToRight(
                          context, CheckoutScreen(product: product,));
                    },
                    text: 'BUY NOW'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
