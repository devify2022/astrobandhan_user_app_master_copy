import 'package:astrobandhan/helper/helper.dart';
import 'package:astrobandhan/provider/astromall_provider.dart';
import 'package:astrobandhan/screens/astromall/product_details.dart';
import 'package:astrobandhan/screens/astromall/widget/product_card.dart';
import 'package:astrobandhan/screens/astromall/widget/product_category.dart';
import 'package:astrobandhan/utils/app_colors.dart';
import 'package:astrobandhan/utils/text.styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class AstromallScreen extends StatefulWidget {
  const AstromallScreen({super.key});

  @override
  State<AstromallScreen> createState() => _AstromallScreenState();
}

class _AstromallScreenState extends State<AstromallScreen> {
  @override
  void initState() {
   WidgetsBinding.instance.addPostFrameCallback((_) async{
      final provider = Provider.of<AstromallProvider>(context, listen: false);
     await provider.getProdutCategory();
     await  provider.getAllProduct();
     await  provider.filterProductByCategory(0);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: kBackgroundColor),
        centerTitle: true,
        title: Text("ASTROMALL",
            style: poppinsStyle600SemiBold.copyWith(fontSize: 17)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: SingleChildScrollView(
          child:
              Consumer<AstromallProvider>(builder: (context, provder, child) {
            return provder.isLoading?Center(child: CircularProgressIndicator()) :Column(
              children: [
                Gap(10),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: provder.category.length,
                      itemBuilder: (context, index) {
                        final category = provder.category[index];
                        return AstomallTapWidget(
                          isSelected: index == provder.categoryIndex,
                          title: category.categoryName ?? "",
                          callback: () {
                            provder.changeCategoryIndex(index);
                          },
                        );
                      }),
                ),
                Gap(10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600
                        ? 4
                        : 2, // Responsive
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: .6, // Adjust for different aspect ratios
                  ),
                  itemCount: provder.filterproduct.length,
                  itemBuilder: (context, index) {
                    final product = provder.filterproduct[index];
                    return ProductCard(
                        imageUrl: product.image ?? "",
                        title: product.productName ?? "",
                        description: product.productDescription ?? "",
                        originalPrice: product.displayPrice!.toDouble(),
                        offerPrice: product.originalPrice!.toDouble(),
                        onTap: () {
                          Helper.toReplacementScreenSlideLeftToRight(
                              context, ProductDetailScreen(product: product,));
                        });
                  },
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}
