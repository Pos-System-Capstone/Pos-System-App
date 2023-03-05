import 'package:pos_apps/view_model/base_view_model.dart';

import '../model/index.dart';

class CartViewModel extends BaseViewModel {
  List<CartItem> _cartList = [];
  int _finalAmount = 0;
  bool _isCartUpdate = false;
  int? _peopleNumber;
  int _totalAmount = 0;
  int _discountAmount = 0;
  int _quantity = 0;

  List<CartItem> get cartList => _cartList;
  int get finalAmount => _finalAmount;
  int get totalAmount => _totalAmount;
  bool get isCartUpdate => _isCartUpdate;
  int? get peopleNumber => _peopleNumber;
  int? get discountAmount => _discountAmount;
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

  void countCartAmount() {
    _totalAmount = 0;
    for (CartItem cart in _cartList) {
      _totalAmount = _totalAmount + cart.totalAmount;
    }
    notifyListeners();
  }

  countCartQuantity() {
    _quantity = 0;
    for (CartItem cart in _cartList) {
      _quantity = _quantity + cart.quantity;
    }
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _totalAmount = _totalAmount - (item.totalAmount);
    _cartList.remove(item);
    countCartAmount();
    countCartQuantity();
    notifyListeners();
  }

  void clearCartData() {
    _cartList = [];
  }
}
