import 'package:get/get.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:pos_apps/data/model/index.dart';
import '../data/model/cart_model.dart';

class ProductViewModel extends BaseViewModel {
  ProductList productInCart = ProductList();
  List<Attribute> listAttribute = Get.find<RootViewModel>().listAttribute;
  List<Category>? listCategory = Get.find<MenuViewModel>().categories;
  void addProductToCartItem(Product product) {
    productInCart = ProductList(
        productInMenuId: product.menuProductId,
        parentProductId: product.parentProductId,
        name: product.name,
        type: product.type,
        quantity: 1,
        code: product.code,
        categoryCode: listCategory!
            .firstWhereOrNull((element) => element.id == product.categoryId)
            ?.code,
        sellingPrice: product.sellingPrice,
        totalAmount: product.sellingPrice,
        finalAmount: product.sellingPrice,
        discount: 0,
        extras: [],
        attributes: []);
    for (var attribute in listAttribute) {
      productInCart.attributes!
          .add(Attributes(name: attribute.name, value: ""));
    }
    countAmount();
    notifyListeners();
  }

  void addProductToCart() {
    Get.find<CartViewModel>().addToCart(productInCart);
    Get.back();
  }

  void setAttributes(Attributes attribute) {
    bool isExist = false;
    for (var element in productInCart.attributes!) {
      if (element.name == attribute.name) {
        element.value = attribute.value;
        isExist = true;
      }
    }
    if (isExist == false) {
      productInCart.attributes!.add(attribute);
    }
    notifyListeners();
  }

  void increaseQuantity() {
    productInCart.quantity = (productInCart.quantity! + 1);
    if (productInCart.extras != null) {
      for (var e in productInCart.extras!) {
        e.quantity = productInCart.quantity;
        e.totalAmount = e.sellingPrice! * e.quantity!;
      }
    }
    countAmount();
    notifyListeners();
  }

  void decreaseQuantity() {
    if (productInCart.quantity == 0) {
      return;
    }
    productInCart.quantity = (productInCart.quantity! - 1);
    if (productInCart.extras != null) {
      for (var e in productInCart.extras!) {
        e.quantity = productInCart.quantity;
        e.totalAmount = e.sellingPrice! * e.quantity!;
      }
    }
    countAmount();
    notifyListeners();
  }

  void addOrRemoveExtra(Product extra) {
    if (isExtraExist(extra.menuProductId!)) {
      productInCart.extras?.removeWhere(
          (element) => element.productInMenuId == extra.menuProductId);
      countAmount();
    } else {
      productInCart.extras?.add(Extras(
          productInMenuId: extra.menuProductId,
          name: extra.name,
          quantity: productInCart.quantity,
          totalAmount: extra.sellingPrice! * productInCart.quantity!,
          sellingPrice: extra.sellingPrice));
      countAmount();
    }
    notifyListeners();
  }

  countAmount() {
    productInCart.totalAmount =
        productInCart.sellingPrice! * productInCart.quantity!;
    addExtraAmount();
    productInCart.finalAmount =
        productInCart.totalAmount! - productInCart.discount!;
  }

  addExtraAmount() {
    for (int index = 0; index < productInCart.extras!.length; index++) {
      productInCart.totalAmount = productInCart.totalAmount! +
          productInCart.extras![index].totalAmount!;
    }
    notifyListeners();
  }

  void setNotes(String note) {
    productInCart.note = note;
    notifyListeners();
  }

  bool isExtraExist(String id) {
    for (int index = 0; index < productInCart.extras!.length; index++) {
      if (productInCart.extras![index].productInMenuId == id) {
        return true;
      }
    }
    return false;
  }

  void getCartItemToUpdate(ProductList cartItem) {
    // countAmount();
    productInCart = cartItem;
    notifyListeners();
  }

  void updateCartItemInCart(int idx) {
    ProductList cartItem = productInCart;
    Get.find<CartViewModel>().updateCart(cartItem, idx);
    Get.back();
  }

  void deleteCartItemInCart(int idx) {
    Get.find<CartViewModel>().removeFromCart(idx);
    Get.back();
  }
}
