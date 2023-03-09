import 'package:flutter/material.dart';
import 'package:pos_apps/data/model/index.dart';
import 'package:pos_apps/view_model/index.dart';

import '../data/api/index.dart';
import '../enums/product_enum.dart';
import '../enums/view_status.dart';

class MenuViewModel extends BaseViewModel {
  late Menu? currentMenu;
  MenuData? menuData;
  List<Product>? normalProducts = [];
  List<Product>? extraProducts = [];
  List<Product>? childProducts = [];
  List<Product>? productsFilter = [];

  MenuViewModel() {
    menuData = MenuData();
  }

  Future<void> getMenuOfStore() async {
    currentMenu = await menuData?.getMenuOfStore();
    normalProducts = currentMenu?.products!
        .where((element) =>
            element.type == ProductTypeEnum.SINGLE ||
            element.type == ProductTypeEnum.PARENT)
        .toList();
    extraProducts = currentMenu?.products!
        .where((element) => element.type == ProductTypeEnum.EXTRA)
        .toList();
    childProducts = currentMenu?.products!
        .where((element) => element.type == ProductTypeEnum.CHILD)
        .toList();
    productsFilter = normalProducts;
    debugPrint('normalProducts: ${normalProducts!.length}');
    debugPrint('extraProducts: ${extraProducts!.length}');
    debugPrint('childProducts: ${childProducts!.length}');
    notifyListeners();
  }

  void handleChangeFilterProductByCategory(String? categoryId) {
    if (categoryId == null) {
      productsFilter = normalProducts;
      notifyListeners();
    } else {
      productsFilter = normalProducts
          ?.where((element) => element.categoryId == categoryId)
          .toList();
      notifyListeners();
    }
  }

  List<Product>? getChildProductByParentProduct(String? productId) {
    return childProducts
        ?.where((element) => element.parentProductId == productId)
        .toList();
  }

  List<Product>? getExtraProductByNormalProduct(Product product) {
    return extraProducts
        ?.where(
            (element) => product.extraCategoryIds!.contains(element.categoryId))
        .toList();
  }
}
