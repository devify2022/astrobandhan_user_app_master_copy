import 'package:astrobandhan/datasource/model/astromall/order_model.dart';
import 'package:astrobandhan/datasource/model/astromall/product_model.dart';
import 'package:astrobandhan/helper/helper.dart';
import 'package:astrobandhan/provider/astromall_provider.dart';
import 'package:astrobandhan/screens/dashboard/dashboard_screen.dart';
import 'package:astrobandhan/utils/app_colors.dart';
import 'package:astrobandhan/utils/text.styles.dart';
import 'package:astrobandhan/widgets/custom_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentRequestScreen extends StatefulWidget {
  final UserOrder userOrder;
  final ProductModel productModel;
  const PaymentRequestScreen(
      {super.key, required this.userOrder, required this.productModel});

  @override
  State<PaymentRequestScreen> createState() => _PaymentRequestScreenState();
}

class _PaymentRequestScreenState extends State<PaymentRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kBackgroundColor),
        centerTitle: true,
        title: Text("CHECKOUT",
            style: poppinsStyle600SemiBold.copyWith(fontSize: 17)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Consumer<AstromallProvider>(builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildProductDetails(widget.productModel),
                const SizedBox(height: 20),
                _buildUserDetails(widget.userOrder),
                const SizedBox(height: 20),
                _buildPaymentDetails(widget.userOrder),
                const SizedBox(height: 20),
                CustomButtons.saveButton(
                  onPressed: provider.isLoading
                      ? null
                      : () {
                          provider.createOrder(widget.userOrder, (value) {
                            if (value) {
                              Helper.toReplacementScreenSlideRightToLeft(
                                  context, DashboardScreen());
                            }
                          });
                        },
                  text: provider.isLoading
                      ? "Processing...".toUpperCase()
                      : "PAY NOW",
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildProductDetails(ProductModel product) {
    return Row(
      children: [
        Container(
          height: 134,
          width: 134,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.topLeft,
              colors: gradientColors,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: CachedNetworkImage(
            imageUrl: product.image ?? "",
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.productName ?? "",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                product.productDescription ?? "",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white60,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Price: ₹${product.originalPrice}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    if (product.displayPrice != null)
                      TextSpan(
                        text: '₹${product.displayPrice}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserDetails(UserOrder orderDetails) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'User Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        _buildAmountDetails('Name:', orderDetails.name),
        _buildAmountDetails('Phone:', orderDetails.phone),
        _buildAmountDetails('Email:', orderDetails.email),
        _buildAmountDetails('City:', orderDetails.city),
        _buildAmountDetails('State:', orderDetails.state),
      ],
    );
  }

  Widget _buildPaymentDetails(UserOrder product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        _buildAmountDetails('Delivery Date:', '26 Jan, 2024'),
        _buildAmountDetails('GST:', '₹00'),
        _buildAmountDetails('Delivery Fee:', '₹00'),
        //_buildAmountDetails('Total:', '₹${totalPrice}'),
        _buildAmountDetails('Total:', '₹${product.totalPrice}'),
      ],
    );
  }

  Widget _buildAmountDetails(String text, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w300,
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
