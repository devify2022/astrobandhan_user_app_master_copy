import 'package:astrobandhan/datasource/model/astromall/order_model.dart';
import 'package:astrobandhan/datasource/model/astromall/product_model.dart';
import 'package:astrobandhan/datasource/model/auth/login_user_model.dart';
import 'package:astrobandhan/helper/helper.dart';
import 'package:astrobandhan/provider/astromall_provider.dart';
import 'package:astrobandhan/screens/astromall/payment_request_screen.dart';
import 'package:astrobandhan/utils/app_colors.dart';
import 'package:astrobandhan/utils/text.styles.dart';
import 'package:astrobandhan/widgets/custom_button.dart';
import 'package:astrobandhan/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final ProductModel product;

  const CheckoutScreen({super.key, required this.product});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  static const _gradientColors = [
    Color.fromRGBO(170, 255, 0, 0.4),
    Color.fromRGBO(60, 0, 255, 0.4),
  ];

  final _formKey = GlobalKey<FormState>();
  late var _uid = "";
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  LoginUserModel userInfo = LoginUserModel();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      userInfo = providerAuth.authRepo.getUserInfoData();
      _uid = userInfo.id ?? "";
      _nameController.text = userInfo.name ?? "";
      _phoneController.text = userInfo.phone ?? "";
      providerAstromall
          .initialQuantityAndPrice(widget.product.originalPrice ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar:  AppBar(
        iconTheme: IconThemeData(color: kBackgroundColor),
        centerTitle: true,
        title: Text("CHECKOUT",
            style: poppinsStyle600SemiBold.copyWith(fontSize: 17)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                 
                _buildProductDetails(product),
                const SizedBox(height: 20),
                _buildQuantityControls(product),
                const SizedBox(height: 20),
                _buildAddressDetails(),
                const SizedBox(height: 20),
                _buildSummaryDetails(product),
                const SizedBox(height: 30),
                Consumer<AstromallProvider>(builder: (context, provider, child) {
                  return CustomButtons.saveButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_nameController.text.isEmpty) {
                          showToastMessage('Name is required');
                        } else if (_phoneController.text.isEmpty ||
                            _phoneController.text == "") {
                          showToastMessage('Phone is required');
                        } else if (_emailController.text.isEmpty ||
                            _emailController.text == "") {
                          showToastMessage('Email is required');
                        } else if (_locationController.text.isEmpty ||
                            _locationController.text == "") {
                          showToastMessage('Location is required');
                        } else if (_stateController.text.isEmpty ||
                            _stateController.text == "") {
                          showToastMessage('State is required');
                        } else if (_cityController.text.isEmpty ||
                            _cityController.text == "") {
                          showToastMessage('City is required');
                        } else {
                          Helper.toReplacementScreenSlideLeftToRight(
                              context,
                              PaymentRequestScreen(
                                productModel: widget.product,
                                userOrder: UserOrder(
                                    email: _emailController.text,
                                    userId: _uid,
                                    name: _nameController.text,
                                    city: _cityController.text,
                                    state: _stateController.text,
                                    phone: _phoneController.text,
                                    address: _locationController.text,
                                    productId: product.id ?? "",
                                    deliveryDate: DateTime.now(),
                                    quantity: provider.productQuantity,
                                    totalPrice: provider.totalPrice.toDouble()),
                              ));
                        }
                      }
                    },
                    text: 'PROCEED',
                  );
                }),
                       
                ],
              ),
            ),
          )
        ),
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
              colors: _gradientColors,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Image.network(
            product.image ?? "",
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.broken_image,
              size: 50,
              color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.productName ?? 'Product Name',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                product.productDescription ?? 'No description available.',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white60,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Text(
                'Price: ₹${product.originalPrice}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              if (product.originalPrice != null)
                Text(
                  '₹${product.displayPrice}',
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
    );
  }

  Widget _buildQuantityControls(ProductModel product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Quantity:',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        Consumer<AstromallProvider>(builder: (context, provider, child) {
          return Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  provider.decementProductQuantity();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                  fixedSize: const Size(32, 32),
                  padding: EdgeInsets.zero,
                  elevation: 4,
                ),
                child: const Icon(
                  Icons.remove,
                  color: Colors.black,
                  size: 16,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '${provider.productQuantity}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  provider.incrimentProductQantity();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                  fixedSize: const Size(32, 32),
                  padding: EdgeInsets.zero,
                  elevation: 4,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 16,
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildAddressDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Address Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: _nameController,
          hintText: 'Enter your name',
          validation: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: _phoneController,
          hintText: 'Enter your phone number',
          validation: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: _emailController,
          hintText: 'Enter your email ID',
          validation: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: _locationController,
          hintText: 'Enter your location',
          validation: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: _stateController,
          hintText: 'Enter your state',
          validation: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: _cityController,
          hintText: 'Enter your city',
          validation: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSummaryDetails(
    ProductModel product,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Summary',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        _buildSummaryRow('Price per item:', '₹${product.originalPrice}'),
        Consumer<AstromallProvider>(builder: (context, provider, child) {
          return _buildSummaryRow('Quantity:', '${provider.productQuantity}');
        }),
        Consumer<AstromallProvider>(builder: (context, provider, child) {
          return _buildSummaryRow(
              'Total Price:', '₹${provider.totalPrice}');
        }),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class NextScreen extends StatelessWidget {
  final Map<String, dynamic> product;
  final int totalPrice;
  final int quantity;
  final Map<String, String> userDetails;

  const NextScreen({
    super.key,
    required this.product,
    required this.totalPrice,
    required this.quantity,
    required this.userDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Thank you, ${userDetails['name']}! Total: ₹$totalPrice for $quantity items.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
