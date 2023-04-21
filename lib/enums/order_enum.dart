// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum DeliTypeEnum { TAKE_AWAY, IN_STORE, DELIVERY, NONE }

enum PrinterTypeEnum { bill, stamp }

class DeliType {
  TakeAway takeAway = TakeAway();
  EatIn eatIn = EatIn();
  Delivery delivery = Delivery();
}

class TakeAway {
  String type = 'TAKE_AWAY';
  IconData icon = Icons.home;
  String label = 'Mang đi';
}

class EatIn {
  String type = 'EAT_IN';
  IconData icon = Icons.store;
  String label = 'Tại quán';
}

class Delivery {
  String type = 'DELIVERY';
  IconData icon = Icons.delivery_dining;
  String label = 'Giao hàng';
}

class OrderStatusEnum {
  static const String PENDING = 'PENDING';
  static const String CANCELED = 'CANCELED';
  static const String PAID = 'PAID';
}

String showOrderStatus(String status) {
  switch (status) {
    case OrderStatusEnum.PENDING:
      return 'Chờ thanh toán';
    case OrderStatusEnum.CANCELED:
      return 'Đã huỷ';
    case OrderStatusEnum.PAID:
      return 'Đã thanh toán';
    default:
      return 'Chờ thanh toán';
  }
}

dynamic showOrderType(String type) {
  DeliType deliType = DeliType();
  if (type == deliType.takeAway.type) {
    return deliType.takeAway;
  } else if (type == deliType.eatIn.type) {
    return deliType.eatIn;
  } else if (type == deliType.delivery.type) {
    return deliType.delivery;
  } else {
    return deliType.eatIn;
  }
}
