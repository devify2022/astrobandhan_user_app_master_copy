import 'dart:convert';

import 'package:astrobandhan/datasource/model/astrologer_model.dart';
import 'package:astrobandhan/datasource/model/astromall/order_model.dart';
import 'package:astrobandhan/datasource/model/astromall/product_category.dart';
import 'package:astrobandhan/datasource/model/astromall/product_model.dart';
import 'package:astrobandhan/datasource/model/base/api_response.dart';
import 'package:astrobandhan/datasource/repository/astromall_repo.dart';
import 'package:astrobandhan/helper/helper.dart';
import 'package:flutter/foundation.dart';

class AstromallProvider extends ChangeNotifier {
  final AstromallRepo astromallRepo;

  AstromallProvider({required this.astromallRepo});

  bool isLoading = false;
  bool bottomLoading = false;
  List<AstrologerModel> astrologers = [];
  int page = 1;
  bool hasNextData = false;
  int _productQuantity = 0;
  int _totalPrice = 0;
  int get totalPrice => _totalPrice;
  int get productQuantity => _productQuantity;
  List<ProductCategoryModel> category = [];
  int productOrginalPrice = 0;
  initialQuantityAndPrice(int orginalPrice) {
    _totalPrice = orginalPrice;
    productOrginalPrice = orginalPrice;
    _productQuantity = 1;
    notifyListeners();
  }

  getProdutCategory() async {
    category.clear();
    isLoading = true;
    ApiResponse apiResponse = await astromallRepo.getPoductCategory();

    isLoading = false;
    if (apiResponse.response.statusCode == 200) {
      apiResponse.response.data['data'].forEach((e) {
        category.add(ProductCategoryModel.fromJson(e));
      });
    } else {
      showToastMessage(apiResponse.error.message);
    }
    notifyListeners();
  }

  List<ProductModel> allproduct = [];
  getAllProduct() async {
    allproduct.clear();
    isLoading = true;
    ApiResponse apiResponse = await astromallRepo.getAllproduct();

    isLoading = false;
    if (apiResponse.response.statusCode == 200) {
      apiResponse.response.data['data'].forEach((e) {
        allproduct.add(ProductModel.fromJson(e));
      });
    } else {
      showToastMessage(apiResponse.error.message);
    }
    notifyListeners();
  }

  createOrder(UserOrder order,Function callback) async {
    allproduct.clear();
    isLoading = true;
    ApiResponse apiResponse = await astromallRepo.createOrder(order);
    isLoading = false;
    if (apiResponse.response.statusCode == 201) {
      showToastMessage(apiResponse.response.data["message"], isError: false);
    callback(true);
    } else {
      //  showToastMessage(apiResponse.error.message);
      // String error = jsonDecode(apiResponse.response.data["message"]);
      callback(false);
      showToastMessage(apiResponse.error);
    }
    notifyListeners();
  }

  int categoryIndex = 0;
  changeCategoryIndex(index) {
    categoryIndex = index;

    notifyListeners();
    filterProductByCategory(index);

    notifyListeners();
  }

  List<ProductModel> filterproduct = [];

  filterProductByCategory(int index) {
    filterproduct.clear();
    notifyListeners();
    filterproduct
        .addAll(allproduct.where((e) => e.category == category[index].id));

    notifyListeners();
  }

  incrimentProductQantity() {
    _productQuantity++;
    _totalPrice = 0;
    _totalPrice = (_productQuantity * productOrginalPrice);
    notifyListeners();
  }

  decementProductQuantity() {
    if (_productQuantity > 1) {
      _productQuantity--;
      _totalPrice = (_productQuantity * productOrginalPrice);
      notifyListeners();
    }
  }
}
