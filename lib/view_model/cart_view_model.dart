import 'dart:math';

import 'package:get/get.dart';
import 'package:pos_apps/view_model/base_view_model.dart';

import '../data/model/index.dart';
import 'index.dart';

class CartViewModel extends BaseViewModel {
  List<CartItem> _cartList = [];
  num _finalAmount = 0;
  bool _isCartUpdate = false;
  int? _peopleNumber;
  num _totalAmount = 0;
  num _discountAmount = 0;
  int _quantity = 0;

  List<CartItem> get cartList => _cartList;
  num get finalAmount => _finalAmount;
  num get totalAmount => _totalAmount;
  bool get isCartUpdate => _isCartUpdate;
  int? get peopleNumber => _peopleNumber;
  num? get discountAmount => _discountAmount;
  int? get quantity => _quantity;

  set setPeopleNumber(int value) {
    _peopleNumber = value;
  }

  set setTotalAmount(int value) {
    _totalAmount = value;
  }

  int isExistInCart(
    int productId,
    String? variationType,
    bool isUpdate,
    int? cartIndex,
  ) {
    for (int index = 0; index < _cartList.length; index++) {
      if (_cartList[index].product.id == productId) {
        if ((isUpdate && index == cartIndex)) {
          return -1;
        } else {
          return index;
        }
      }
    }
    return -1;
  }

  int getCartIndex(int productID) {
    for (int index = 0; index < _cartList.length; index++) {
      if (_cartList[index].product.id == productID) {
        return index;
      }
    }
    return -1;
  }

  void addToCart(CartItem cartModel) {
    _cartList.add(cartModel);
    countCartAmount();
    countCartQuantity();
    print(_cartList.length);
    notifyListeners();
  }

  void updateCart(CartItem cartModel, int cartIndex) {
    _cartList[cartIndex] = cartModel;
    countCartAmount();
    countCartQuantity();
    print(_cartList.length);
    notifyListeners();
  }

  void countCartAmount() {
    _totalAmount = 0;
    for (CartItem cart in _cartList) {
      _totalAmount = _totalAmount + cart.totalAmount;
    }
    _finalAmount = _totalAmount - _discountAmount;
    notifyListeners();
  }

  countCartQuantity() {
    _quantity = 0;
    for (CartItem cart in _cartList) {
      _quantity = _quantity + cart.quantity;
    }
    notifyListeners();
  }

  void removeFromCart(int idx) {
    _totalAmount = _totalAmount - (_cartList[idx].totalAmount);
    _cartList.remove(_cartList[idx]);
    countCartAmount();
    countCartQuantity();
    notifyListeners();
  }

  void clearCartData() {
    _cartList = [];
    _finalAmount = 0;
    _totalAmount = 0;
    _discountAmount = 0;
    _quantity = 0;
    notifyListeners();
  }

  //UPDATE CART ITEM

  CartItem countCartItemAmount(CartItem cartItem) {
    cartItem.totalAmount = cartItem.product.sellingPrice! * quantity!;
    cartItem = addExtraCartItemAmount(cartItem);
    return cartItem;
  }

  CartItem addExtraCartItemAmount(CartItem cartItem) {
    for (int index = 0; index < cartItem.extras!.length; index++) {
      cartItem.totalAmount += cartItem.extras![index].sellingPrice!;
    }
    return cartItem;
  }

  void createOrder() {
    String deliType = Get.find<OrderViewModel>().deliveryType;
    List<ProductInOrder> productList = <ProductInOrder>[];
    List<ExtraInOrder> extraList = <ExtraInOrder>[];
    for (CartItem cart in _cartList) {
      cart.extras?.forEach((element) {
        ExtraInOrder extra = ExtraInOrder(
          productInMenuId: element.menuProductId,
          quantity: 1,
          sellingPrice: element.sellingPrice,
        );
        extraList.add(extra);
      });
      ProductInOrder product = ProductInOrder(
        productInMenuId: cart.product.menuProductId,
        quantity: cart.quantity,
        sellingPrice: cart.totalAmount,
        note: cart.note,
        extras: extraList,
      );
      productList.add(product);
    }
    OrderModel order = OrderModel(
      payment: "CASH",
      orderType: deliType,
      productsList: productList,
      totalAmount: _totalAmount,
      discountAmount: _discountAmount,
      finalAmount: _finalAmount,
    );
    print(order.toJson());
    Get.find<OrderViewModel>().placeOrder(order);
    Get.isDialogOpen ?? Get.back();
    clearCartData();
  }
}
