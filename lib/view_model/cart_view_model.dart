// ignore_for_file: unnecessary_import
import 'package:get/get.dart';
import 'package:pos_apps/data/model/response/payment_provider.dart';
import 'package:pos_apps/data/model/response/promotion.dart';
import 'package:pos_apps/view_model/base_view_model.dart';
import 'package:pos_apps/views/widgets/other_dialogs/dialog.dart';

import '../data/model/index.dart';
import 'index.dart';

class CartViewModel extends BaseViewModel {
  List<CartItem> _cartList = [];
  num _finalAmount = 0;
  int? _peopleNumber;
  num _totalAmount = 0;
  num _discountAmount = 0;
  int _quantity = 0;
  Promotion? selectedPromotion;

  List<CartItem> get cartList => _cartList;
  num get finalAmount => _finalAmount;
  num get totalAmount => _totalAmount;
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

  void addToCart(CartItem cartModel) {
    _cartList.add(cartModel);
    countCartAmount();
    countCartQuantity();
    notifyListeners();
  }

  void updateCart(CartItem cartModel, int cartIndex) {
    _cartList[cartIndex] = cartModel;
    checkAvaileblePromotion();
    countCartAmount();
    countCartQuantity();
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
    checkAvaileblePromotion();
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
    selectedPromotion = null;
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

  void checkPromotion(Promotion promotion) {
    switch (promotion.type) {
      case "Amount":
        if (promotion.minConditionAmount! <= _totalAmount) {
          _discountAmount = promotion.discountAmount!;
          selectedPromotion = promotion;
          countCartAmount();
          hideDialog();
        } else {
          showAlertDialog(
            title: "Lỗi",
            content: "Khuyến mãi không hợp lệ",
          );
        }
        break;
      case "Percent":
        if (promotion.minConditionAmount! <= _totalAmount) {
          _discountAmount = (_totalAmount * promotion.discountPercent!);
          if (_discountAmount > promotion.maxDiscount!) {
            _discountAmount = promotion.maxDiscount!;
          }
          selectedPromotion = promotion;
          countCartAmount();
          hideDialog();
        } else {
          showAlertDialog(
            title: "Lỗi",
            content: "Khuyến mãi không hợp lệ",
          );
        }
        break;
      case "Product":
        for (var item in _cartList) {
          for (var product in promotion.listProductApply!) {
            if (item.product.id == product.productId) {
              _discountAmount = promotion.discountAmount!;
              selectedPromotion = promotion;
              countCartAmount();
              hideDialog();
              break;
            }
          }
        }
        if (selectedPromotion?.type != "Product") {
          showAlertDialog(
            title: "Lỗi",
            content: "Khuyến mãi không hợp lệ",
          );
        }
        break;
      default:
        showAlertDialog(
          title: "Lỗi",
          content: "Khuyến mãi không hợp lệ",
        );
        break;
    }
    notifyListeners();
  }

  void removePromotion() {
    _discountAmount = 0;
    selectedPromotion = null;
    countCartAmount();
    hideDialog();
    notifyListeners();
  }

  void checkAvaileblePromotion() {
    if (selectedPromotion == null) {
      return;
    }
    countCartAmount();
    switch (selectedPromotion?.type) {
      case "Amount":
        if (selectedPromotion!.minConditionAmount! <= _totalAmount) {
          return;
        } else {
          _discountAmount = 0;
          selectedPromotion = null;
        }
        break;
      case "Percent":
        if (selectedPromotion!.minConditionAmount! <= _totalAmount) {
          _discountAmount =
              (_totalAmount * selectedPromotion!.discountPercent!);
          if (_discountAmount > selectedPromotion!.maxDiscount!) {
            _discountAmount = selectedPromotion!.maxDiscount!;
          }
          countCartAmount();
        } else {
          _discountAmount = 0;
          selectedPromotion = null;
        }
        break;
      case "Product":
        for (var item in _cartList) {
          for (var product in selectedPromotion!.listProductApply!) {
            if (item.product.id == product.productId) {
              return;
            }
          }
        }
        _discountAmount = 0;
        selectedPromotion = null;
        break;
      default:
        showAlertDialog(
          title: "Thông báo",
          content: "Khuyến mãi đã bị xoá",
        );
        _discountAmount = 0;
        selectedPromotion = null;
        break;
    }
    notifyListeners();
  }

  Future<void> createOrder() async {
    String deliType = Get.find<OrderViewModel>().deliveryType;
    List<ProductInOrder> productList = <ProductInOrder>[];
    for (CartItem cart in _cartList) {
      List<ExtraInOrder> extraList = <ExtraInOrder>[];
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
        sellingPrice: cart.product.sellingPrice,
        note: cart.attributes == null && cart.note == null
            ? null
            : ("${cart.attributes!.map((e) => e.value).join(" ")} ${cart.note ?? ''}"),
        extras: extraList,
      );
      productList.add(product);
    }
    OrderModel order = OrderModel(
      orderType: deliType,
      productsList: productList,
      totalAmount: _totalAmount,
      discountAmount: _discountAmount,
      finalAmount: _finalAmount,
      promotionId: selectedPromotion == null ? null : selectedPromotion?.id,
    );
    bool res = false;
    Get.find<OrderViewModel>().placeOrder(order).then((value) => {
          res = value,
          if (res == true) {clearCartData()}
        });
  }

  List<PaymentProvider?> getListPayment() {
    List<PaymentProvider?> listPayment = [];
    listPayment = Get.find<OrderViewModel>().listPayment;
    return listPayment;
  }
}
