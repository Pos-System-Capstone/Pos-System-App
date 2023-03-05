import 'package:get/get.dart';
import 'package:pos_apps/enums/product_enum.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:pos_apps/view_model/menu_view_model.dart';

import '../model/index.dart';
import 'cart_view_model.dart';

class ProductViewModel extends BaseViewModel {
  int? totalAmount;
  Product? productInCart;
  int quantity = 1;
  List<Product> extras = [];
  String? notes;

  void addProductToCartItem(Product product) {
    productInCart = product;
    print(productInCart!.name);
    countAmount();
    print(totalAmount);
    notifyListeners();
  }

  void addProductToCart() {
    CartItem cartItem = CartItem(
      productInCart!,
      quantity,
      totalAmount!,
      note: notes,
      extras: extras,
    );
    Get.find<CartViewModel>().addToCart(cartItem);
    Get.back();
  }

  void increaseQuantity() {
    quantity += 1;
    countAmount();
    notifyListeners();
  }

  void decreaseQuantity() {
    if (quantity == 1) {
      return;
    }
    quantity -= 1;
    countAmount();
    notifyListeners();
  }

  void addOrRemoveExtra(Product extra) {
    print(isExtraExist(extra).toString());
    if (isExtraExist(extra)) {
      extras.removeWhere((element) => element.id == extra.id);
      countAmount();
    } else {
      extras.add(extra);
      countAmount();
    }
    print(extras.length);
    notifyListeners();
  }

  countAmount() {
    totalAmount = productInCart!.sellingPrice! * quantity;
    addExtraAmount();
  }

  addExtraAmount() {
    for (int index = 0; index < extras.length; index++) {
      totalAmount = totalAmount! + extras[index].sellingPrice!;
    }
    notifyListeners();
  }

  bool isExtraExist(Product extra) {
    for (int index = 0; index < extras.length; index++) {
      if (extras[index].id == extra.id) {
        return true;
      }
    }

    return false;
  }
}
