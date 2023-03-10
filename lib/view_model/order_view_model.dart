import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/data/model/response/order_response.dart';
import 'package:pos_apps/enums/order_enum.dart';
import 'package:pos_apps/util/share_pref.dart';
import 'package:pos_apps/view_model/cart_view_model.dart';
import 'package:pos_apps/view_model/index.dart';

import '../data/api/order_api.dart';
import '../data/model/index.dart';

class OrderViewModel extends BaseViewModel {
  late OrderStateEnum currentState;
  int selectedTable = 0;
  DeliTypeEnum deliveryType = DeliTypeEnum.NONE;
  Cart? currentCart;
  late OrderAPI api = OrderAPI();
  OrderResponseModel? orderResponseModel;

  OrderViewModel() {
    currentState = OrderStateEnum.CHOOSE_ORDER_TYPE;
    api = OrderAPI();
  }

  void changeState(OrderStateEnum newState) {
    currentState = newState;
    notifyListeners();
  }

  void chooseDeliveryType(DeliTypeEnum type) {
    deliveryType = type;
    changeState(OrderStateEnum.BOOKING_TABLE);
    notifyListeners();
  }

  void chooseTable(int table) {
    selectedTable = table;
    changeState(OrderStateEnum.ORDER_PRODUCT);
    notifyListeners();
  }

  void clearOrderState() {
    selectedTable = 0;
    deliveryType = DeliTypeEnum.NONE;
    Get.find<CartViewModel>().clearCartData();
    changeState(OrderStateEnum.CHOOSE_ORDER_TYPE);
    notifyListeners();
  }

  Future<void> placeOrder(OrderModel order) async {
    Account? userInfo = await getUserInfo();
    var res = await api.placeOrder(order, userInfo!.storeId);
    print(res.toString());
    OrderResponseModel? orderRes =
        await getOrderByStore(userInfo.storeId, res.toString());
    if (orderRes != null) {
      orderResponseModel = orderRes;
      changeState(OrderStateEnum.PAYMENT);
      if (Get.isDialogOpen!) {
        Get.back();
      }
    } else {
      orderResponseModel = null;
    }
    notifyListeners();
  }

  Future<OrderResponseModel?> getOrderByStore(
      String storeId, String orderId) async {
    // Account? userInfo = await getUserInfo();
    OrderResponseModel res = await api.getOrderOfStore(storeId, orderId);
    print(res.toString());
    return res;
  }

  // void addProductToCart(Product product)  {
  //   List<ProductDTO> listChoices = [];
  //   if (master.type == ProductType.MASTER_PRODUCT) {
  //     Map choice = new Map();
  //     for (int i = 0; i < affectPriceContent.keys.toList().length; i++) {
  //       choice[affectPriceContent.keys.elementAt(i)] =
  //           selectedAttributes[affectPriceContent.keys.elementAt(i)];
  //     }

  //     ProductDTO dto = master.getChildByAttributes(choice);
  //     listChoices.add(dto);
  //   }

  //   if (this.extra != null) {
  //     for (int i = 0; i < extra.keys.length; i++) {
  //       if (extra[extra.keys.elementAt(i)]) {
  //         print(extra.keys.elementAt(i).type);
  //         listChoices.add(extra.keys.elementAt(i));
  //       }
  //     }
  //   }

  //   String description = "";
  //   CartItem item = new CartItem(master, listChoices, description, count);

  //   if (master.type == ProductType.GIFT_PRODUCT) {
  //     AccountViewModel account = Get.find<AccountViewModel>();
  //     if (account.currentUser == null) {
  //       await account.fetchUser();
  //     }

  //     double totalBean = account.currentUser.point;

  //     Cart cart = showOnHome ? await getCart() : await getMart();
  //     if (cart != null) {
  //       cart.items.forEach((element) {
  //         if (element.master.type == ProductType.GIFT_PRODUCT) {
  //           totalBean -= (element.master.price * element.quantity);
  //         }
  //       });
  //     }

  //     if (totalBean < (master.price * count)) {
  //       await showStatusDialog("assets/images/global_error.png",
  //           "Không đủ Bean", "Số bean hiện tại không đủ");
  //       return;
  //     }
  //   }

  //   print("Item: " + item.master.productInMenuId.toString());

  //   showOnHome ? await addItemToCart(item) : await addItemToMart(item);
  //   await AnalyticsService.getInstance()
  //       .logChangeCart(item.master, item.quantity, true);
  //   hideDialog();
  //   if (backToHome) {
  //     Get.find<OrderViewModel>().prepareOrder();
  //     Get.back(result: true);
  //   } else {
  //     Get.find<OrderViewModel>().prepareOrder();
  //   }
  // }
}
