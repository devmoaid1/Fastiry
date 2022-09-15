import 'package:efood_multivendor/data/repository/category_repo.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/response/category_model.dart';
import '../../../data/model/response/product_model.dart';

class CategoryViewModel extends GetxController implements GetxService {
  final CategoryRepo categoryRepo;

  CategoryViewModel({@required this.categoryRepo});

  RxBool _isLoading = false.obs;
  bool _secondaryLoading = false;

  int _subCategoryIndex = 0;

  List<Product> _categoryProducts = [];

  List<Product> _subCategoryPrducts = [];

  List<CategoryModel> _subCategories = [];

  RxBool get isLoading => _isLoading;
  bool get secondaryLoading => _secondaryLoading;

  List<Product> get categoryProducts => _categoryProducts;
  List<Product> get subCategoryPrducts => _subCategoryPrducts;
  List<CategoryModel> get subCategories => _subCategories;
  int get subCategoryIndex => _subCategoryIndex;

  void initCategoryScreen(String categoryId) {
    if (_isLoading.isFalse) {
      _isLoading.toggle();
    }

    _subCategoryIndex = 0;
    _subCategories.clear();
    _categoryProducts.clear();
    getSubCategories(categoryId);
    getCategoryProducts(categoryId);
    // if (_isLoading.isTrue) {
    //   _isLoading.toggle();
    // }

    update();
  }

  Future<List<CategoryModel>> getSubCategories(String categoryId) async {
    try {
      final response = await categoryRepo.getSubCategoryList(categoryId);

      if (response.statusCode == 200) {
        _subCategories.clear();
        _subCategories.add(CategoryModel(
            id: int.parse(categoryId),
            parentId: int.parse(categoryId),
            name: "all".tr));
        response.body.forEach((subCategory) {
          _subCategories.add(CategoryModel.fromJson(subCategory));
        });
      }

      update();
    } catch (err) {
      showCustomSnackBar(err);
    }
    return _subCategories;
  }

  Future<void> getCategoryProducts(String id) async {
    try {
      Response response;

      response = await categoryRepo.getCategoryProductList(id, 1, 'all');

      if (response.statusCode == 200) {
        _categoryProducts.clear();
        _categoryProducts.addAll(ProductModel.fromJson(response.body).products);
      }
      // _isLoading = false;
    } catch (err) {
      showCustomSnackBar(err);
    }

    if (_isLoading.isTrue) {
      _isLoading.toggle();
    }
    update();
  }

  void setSubCategoryIndex(int index, String categoryId) {
    _subCategoryIndex = index;
    _secondaryLoading = true;
    getCategoryProducts(categoryId);
    _secondaryLoading = false;
    update();
  }
}
