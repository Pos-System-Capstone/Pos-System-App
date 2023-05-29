// ignore_for_file: unnecessary_import
import 'package:get/get.dart';
import 'package:pos_apps/data/model/response/payment_provider.dart';
import 'package:pos_apps/data/model/response/promotion.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:pos_apps/view_model/base_view_model.dart';
import 'package:pos_apps/views/widgets/other_dialogs/dialog.dart';

import '../data/api/promotion_data.dart';
import '../data/model/index.dart';
import '../enums/view_status.dart';
import 'index.dart';

class CartViewModel extends BaseViewModel {
  List<CartItem> _cartList = [];
  num _finalAmount = 0;
  int? _peopleNumber;
  num _totalAmount = 0;
  num _discountAmount = 0;
  num _productDiscount = 0;
  int _quantity = 0;
  Promotion? selectedPromotion;
  PromotionData? promotionData = PromotionData();
  List<Promotion>? promotions = [];
  List<CartItem> get cartList => _cartList;
  num get finalAmount => _finalAmount;
  num get totalAmount => _totalAmount;
  int? get peopleNumber => _peopleNumber;
  num? get discountAmount => _discountAmount;
  int? get quantity => _quantity;
  num? get productDiscount => _productDiscount;

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

  void getListPromotion() async {
    try {
      setState(ViewStatus.Loading);
      promotions = await promotionData?.getListPromotionOfStore();
      setState(ViewStatus.Completed);
    } catch (e) {
      setState(ViewStatus.Error, e.toString());
    }
  }

  void addToCart(CartItem cartModel) {
    _cartList.add(cartModel);
    checkAvaileblePromotion();
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
    _productDiscount = 0;
    for (CartItem cart in _cartList) {
      _totalAmount = _totalAmount + cart.totalAmount;
      _productDiscount =
          _productDiscount + cart.product.discountPrice! * cart.quantity;
    }
    _finalAmount = _totalAmount - _discountAmount - _productDiscount;
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
    _productDiscount = 0;
    _quantity = 0;
    selectedPromotion = null;
    notifyListeners();
  }

  //UPDATE CART ITEM
  void checkPromotion(Promotion promotion) {
    switch (promotion.type) {
      case PromotionTypeEnums.AMOUNT:
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
      case PromotionTypeEnums.PERCENT:
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
      case PromotionTypeEnums.PRODUCT:
        if (promotion.minConditionAmount! <= _totalAmount) {
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
          if (selectedPromotion?.type != PromotionTypeEnums.PRODUCT) {
            showAlertDialog(
              title: "Lỗi",
              content: "Khuyến mãi không hợp lệ",
            );
          }
        } else {
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
    checkAutoApplyPromotion();
    countCartAmount();
    hideDialog();
    notifyListeners();
  }

  void checkAutoApplyPromotion() {
    List<Promotion>? listAutoApplyPromotion = promotions
        ?.where((element) =>
            element.type == PromotionTypeEnums.AUTOAPPLY &&
            element.isAvailable == true)
        .toList();
    if (listAutoApplyPromotion == null || listAutoApplyPromotion.isEmpty) {
      return;
    } else {
      for (var item in _cartList) {
        for (var autoApplyPromotion in listAutoApplyPromotion) {
          for (var product in autoApplyPromotion.listProductApply!) {
            if (item.product.id == product.productId) {
              item.product.discountPrice =
                  (autoApplyPromotion.discountAmount ?? 0 * item.quantity);
            }
          }
        }
      }
    }
    countCartAmount();
  }

  void checkAvaileblePromotion() {
    checkAutoApplyPromotion();
    if (selectedPromotion == null) {
      return;
    }
    countCartAmount();
    switch (selectedPromotion?.type) {
      case PromotionTypeEnums.AMOUNT:
        if (selectedPromotion!.minConditionAmount! <= _totalAmount) {
          return;
        } else {
          _discountAmount = 0;
          selectedPromotion = null;
        }
        break;
      case PromotionTypeEnums.PERCENT:
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
      case PromotionTypeEnums.PRODUCT:
        if (selectedPromotion!.minConditionAmount! <= _totalAmount) {
          for (var item in _cartList) {
            for (var product in selectedPromotion!.listProductApply!) {
              if (item.product.id == product.productId) {
                return;
              }
            }
          }
          _discountAmount = 0;
          selectedPromotion = null;
        } else {
          _discountAmount = 0;
          selectedPromotion = null;
        }
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
            discount: element.discountPrice! * cart.quantity);
        extraList.add(extra);
      });
      ProductInOrder product = ProductInOrder(
        productInMenuId: cart.product.menuProductId,
        quantity: cart.quantity,
        sellingPrice: cart.product.sellingPrice,
        discount: cart.product.discountPrice! * cart.quantity,
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
      discountAmount: _discountAmount + _productDiscount,
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
