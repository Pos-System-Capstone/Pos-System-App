// ignore_for_file: unnecessary_import

import 'package:flutter/foundation.dart';
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
  List<Promotion> promotionApplyList = [];
  num _finalAmount = 0;
  int? _peopleNumber;
  num _totalAmount = 0;
  num _discountAmount = 0;
  num _productDiscount = 0;
  int _quantity = 0;
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
    checkAvailablePromotion();
    countCartAmount();
    countCartQuantity();
    notifyListeners();
  }

  void updateCart(CartItem cartModel, int cartIndex) {
    _cartList[cartIndex] = cartModel;
    checkAvailablePromotion();
    countCartAmount();
    countCartQuantity();
    notifyListeners();
  }

  void countCartAmount() {
    print(promotionApplyList.length);
    _totalAmount = 0;
    _productDiscount = 0;
    _discountAmount = 0;
    for (CartItem cart in _cartList) {
      _totalAmount = _totalAmount + cart.totalAmount;
      _productDiscount =
          _productDiscount + cart.product.discountPrice! * cart.quantity;
    }
    for (Promotion promotion in promotionApplyList) {
      _discountAmount += ((promotion.discountInOrder ?? 0));
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
    checkAvailablePromotion();
    countCartAmount();
    countCartQuantity();
    notifyListeners();
  }

  bool isPromotionApplied(String promotionId) {
    for (var promotion in promotionApplyList) {
      if (promotion.id == promotionId) {
        return true;
      }
    }
    return false;
  }

  void clearCartData() {
    _cartList = [];
    _finalAmount = 0;
    _totalAmount = 0;
    _discountAmount = 0;
    _productDiscount = 0;
    _quantity = 0;
    promotionApplyList = [];
    notifyListeners();
  }

  bool isPromotionTypeExist(String type) {
    Promotion? res =
        promotionApplyList.firstWhereOrNull((element) => element.type == type);
    if (res == null) {
      return false;
    }
    return true;
  }

  bool isPromotionExist(String id) {
    Promotion? res =
        promotionApplyList.firstWhereOrNull((element) => element.id == id);
    if (res == null) {
      return false;
    }
    return true;
  }

  //UPDATE CART ITEM
  void checkPromotion(Promotion promotion) {
    switch (promotion.type) {
      case PromotionTypeEnums.AMOUNT:
        if (isPromotionTypeExist(promotion.type!)) {
          showAlertDialog(
            title: "Lỗi",
            content: "Loại khuyến mãi này đã được áp dụng rồi",
          );
        } else if (promotion.minConditionAmount! <= _totalAmount) {
          promotion.quantity = 1;
          promotion.discountInOrder = promotion.discountAmount;
          promotionApplyList.add(promotion);
          checkAvailablePromotion();
        } else {
          showAlertDialog(
            title: "Lỗi",
            content: "Khuyến mãi không hợp lệ",
          );
        }
        break;
      case PromotionTypeEnums.PERCENT:
        if (isPromotionTypeExist(promotion.type!)) {
          showAlertDialog(
            title: "Lỗi",
            content: "Loại khuyến mãi này đã được áp dụng rồi",
          );
        } else if (promotion.minConditionAmount! <= _totalAmount) {
          promotion.quantity = 1;
          promotion.discountInOrder =
              (_totalAmount * promotion.discountPercent!) >
                      promotion.maxDiscount!
                  ? promotion.maxDiscount!
                  : (_totalAmount * promotion.discountPercent!);
          promotionApplyList.add(promotion);
          checkAvailablePromotion();
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
            for (var p in promotion.listProductApply!) {
              if (item.product.id == p.productId) {
                int idx = promotionApplyList
                    .indexWhere((element) => element.id == promotion.id);
                if (idx == -1) {
                  promotion.quantity = item.quantity;
                  promotion.discountInOrder =
                      promotion.discountAmount! * promotion.quantity!;
                  promotionApplyList.add(promotion);
                  checkAvailablePromotion();
                } else {
                  promotionApplyList[idx].quantity =
                      (promotionApplyList[idx].quantity! + item.quantity);
                  promotionApplyList[idx].discountInOrder =
                      (promotionApplyList[idx].discountInOrder! +
                          (promotion.discountAmount! * item.quantity));
                  checkAvailablePromotion();
                }
              }
            }
          }
          if (promotion.type != PromotionTypeEnums.PRODUCT) {
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

  void removePromotion(String promotionId) {
    _discountAmount = 0;
    promotionApplyList.removeWhere((element) => element.id == promotionId);
    // checkAutoApplyPromotion();
    checkAvailablePromotion();
    hideDialog();
    notifyListeners();
  }

  // void checkAutoApplyPromotion() {
  //   List<Promotion>? listAutoApplyPromotion = promotions
  //       ?.where((element) =>
  //           element.type == PromotionTypeEnums.AUTOAPPLY &&
  //           element.isAvailable == true)
  //       .toList();
  //   if (listAutoApplyPromotion == null || listAutoApplyPromotion.isEmpty) {
  //     return;
  //   } else {
  //     for (var item in _cartList) {
  //       for (var autoApplyPromotion in listAutoApplyPromotion) {
  //         for (var product in autoApplyPromotion.listProductApply!) {
  //           if (item.product.id == product.productId) {
  //             item.product.discountPrice =
  //                 (autoApplyPromotion.discountAmount ?? 0 * item.quantity);
  //           }
  //         }
  //       }
  //     }
  //   }
  //   countCartAmount();
  // }

  void checkAvailablePromotion() {
    countCartAmount();
    for (var promotion in promotionApplyList) {
      switch (promotion.type) {
        case PromotionTypeEnums.AMOUNT:
          if (promotion.minConditionAmount! <= _totalAmount) {
            continue;
          } else {
            promotionApplyList
                .removeWhere((element) => element.id == promotion.id);
            countCartAmount();
          }
          break;
        case PromotionTypeEnums.PERCENT:
          if (promotion.minConditionAmount! <= _totalAmount) {
            promotion.discountInOrder =
                (_totalAmount * promotion.discountPercent!) >
                        promotion.maxDiscount!
                    ? promotion.maxDiscount!
                    : (_totalAmount * promotion.discountPercent!);
            countCartAmount();
          } else {
            promotionApplyList
                .removeWhere((element) => element.id == promotion.id);
            countCartAmount();
          }
          break;
        case PromotionTypeEnums.PRODUCT:
          if ((promotion.minConditionAmount! * promotion.quantity!) <=
              _totalAmount) {
            for (var item in _cartList) {
              for (var product in promotion.listProductApply!) {
                if (item.product.id == product.productId) {
                  return;
                }
              }
            }
            promotionApplyList
                .removeWhere((element) => element.id == promotion.id);
            countCartAmount();
          } else {
            showAlertDialog(
              title: "Thông báo",
              content: "Khuyến mãi không hợp lệ",
            );
            promotionApplyList
                .removeWhere((element) => element.id == promotion.id);
            countCartAmount();
          }
          break;
        default:
          showAlertDialog(
            title: "Thông báo",
            content: "Khuyến mãi đã bị xoá",
          );
          promotionApplyList
              .removeWhere((element) => element.id == promotion.id);
          countCartAmount();
          break;
      }
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
      promotionList: promotionApplyList
          .map((e) => PromotionList(
              promotionId: e.id,
              promotionName: e.name,
              quantity: e.quantity,
              discountAmount: e.discountInOrder))
          .toList(),
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

  void increasePromotionQuantity(String id) {
    int idx = promotionApplyList.indexWhere((element) => element.id == id);
    if (idx == -1) {
      showAlertDialog(
        title: "Thông báo",
        content: "Khuyến mãi đã bị xoá",
      );
      return;
    }
    promotionApplyList[idx].quantity = (promotionApplyList[idx].quantity! + 1);
    promotionApplyList[idx].discountInOrder =
        (promotionApplyList[idx].discountAmount! *
            promotionApplyList[idx].quantity!);
    checkAvailablePromotion();
  }

  void decreasePromotionQuantity(String id) {
    int idx = promotionApplyList.indexWhere((element) => element.id == id);
    if (idx == -1) {
      showAlertDialog(
        title: "Thông báo",
        content: "Khuyến mãi đã bị xoá",
      );
      return;
    }
    if (promotionApplyList[idx].quantity == 1) {
      removePromotion(id);
      checkAvailablePromotion();
      return;
    } else {
      promotionApplyList[idx].quantity =
          (promotionApplyList[idx].quantity! - 1);
      promotionApplyList[idx].discountInOrder =
          (promotionApplyList[idx].discountAmount! *
              promotionApplyList[idx].quantity!);
      checkAvailablePromotion();
    }
  }

  Promotion? selectedPromotion(String id) {
    for (var promotion in promotionApplyList) {
      if (promotion.id == id) {
        return promotion;
      }
    }
    return null;
  }
}
