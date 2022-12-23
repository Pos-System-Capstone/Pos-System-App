import 'dart:core';

import 'package:pos_apps/enums/order_enum.dart';
import 'package:pos_apps/view_model/index.dart';

class OrderViewModel extends BaseViewModel {
  late OrderStateEnum currentState;
  late int numberOfTable;
  int selectedTable = 0;
  DeliTypeEnum deliveryType = DeliTypeEnum.NONE;

  OrderViewModel() {
    currentState = OrderStateEnum.CHOOSE_ORDER_TYPE;
    numberOfTable = 40;
  }

  void changeState(OrderStateEnum newState) {
    currentState = newState;
    notifyListeners();
  }

  void chooseDeliveryType(DeliTypeEnum type) {
    deliveryType = type;
    notifyListeners();
  }

  void chooseTable(int table) {
    selectedTable = table;
    currentState = OrderStateEnum.ORDER_PRODUCT;
    notifyListeners();
  }

  void clearOrderState() {
    selectedTable = 0;
    deliveryType = DeliTypeEnum.NONE;
    notifyListeners();
  }
}
