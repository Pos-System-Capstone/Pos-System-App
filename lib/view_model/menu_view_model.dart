import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    currentMenu = Menu();
  }

  Future<void> getMenuOfStore() async {
    setState(ViewStatus.Loading);
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
    Get.find<OrderViewModel>().getListPayment();
    setState(ViewStatus.Completed);
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
    List<Product> listChilds = childProducts!
        .where((element) => element.parentProductId == productId)
        .toList();

    List<Product> listChildsSorted = [];
    for (Product item in listChilds) {
      if (item.size == ProductSizeEnum.SMALL) {
        listChildsSorted.add(item);
      }
    }
    for (Product item in listChilds) {
      if (item.size == ProductSizeEnum.MEDIUM) {
        listChildsSorted.add(item);
      }
    }
    for (Product item in listChilds) {
      if (item.size == ProductSizeEnum.LARGE) {
        listChildsSorted.add(item);
      }
    }
    return listChildsSorted;
  }

  List<Product>? getExtraProductByNormalProduct(Product product) {
    return extraProducts
        ?.where(
            (element) => product.extraCategoryIds!.contains(element.categoryId))
        .toList();
  }

  List<Category>? getExtraCategoryByNormalProduct(Product product) {
    List<Category> listExtraCategory = [];
    for (Category item in currentMenu!.categories!) {
      if (product.extraCategoryIds!.contains(item.id)) {
        listExtraCategory.add(item);
      }
    }
    return listExtraCategory;
  }

  List<Product> getProductsByCategory(String? categoryId) {
    return extraProducts!
        .where((element) => element.categoryId == categoryId)
        .toList();
  }
}
