// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum DeliTypeEnum { TAKE_AWAY, IN_STORE, DELIVERY, NONE }

enum PrinterTypeEnum { bill, stamp }

class DeliType {
  TakeAway takeAway = TakeAway();
  EatIn eatIn = EatIn();
  Delivery delivery = Delivery();
  Topup topup = Topup();
}

class TakeAway {
  String type = 'TAKE_AWAY';
  IconData icon = Icons.home;
  String label = 'Mang đi';
  Color color = Colors.amber;
}

class EatIn {
  String type = 'EAT_IN';
  IconData icon = Icons.store;
  String label = 'Tại quán';
  Color color = Colors.cyan;
}

class Delivery {
  String type = 'DELIVERY';
  IconData icon = Icons.delivery_dining;
  String label = 'Giao hàng';
  Color color = Colors.teal;
}

class Topup {
  String type = 'TOP_UP';
  IconData icon = Icons.credit_card;
  String label = 'Nạp thẻ';
}

class OrderStatusEnum {
  static const String PENDING = 'PENDING';
  static const String CANCELED = 'CANCELED';
  static const String PAID = 'PAID';
}

String showOrderStatus(String status) {
  switch (status) {
    case OrderStatusEnum.PENDING:
      return 'Đang thực hiện';
    case OrderStatusEnum.CANCELED:
      return 'Đã huỷ';
    case OrderStatusEnum.PAID:
      return 'Đã hoàn thành';
    default:
      return 'Đang thực hiện';
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
  } else if (type == deliType.topup.type) {
    return deliType.topup;
  } else {
    return deliType.eatIn;
  }
}

String showPaymentStatusEnum(String status) {
  switch (status) {
    case PaymentStatusEnum.PENDING:
      return 'Chưa thanh toán';
    case PaymentStatusEnum.FAIL:
      return 'Thất bại';
    case PaymentStatusEnum.PAID:
      return 'Đã thanh toán';
    default:
      return 'Không có thông tin';
  }
}

class PaymentStatusEnum {
  static const String FAIL = 'Fail';
  static const String PAID = 'PAID';
  static const String PENDING = 'PENDING';
}

class PaymentTypeEnums {
  static const String CASH = 'CASH';
  static const String VIETQR = 'VIETQR';
  static const String ZALOPAY = 'ZALOPAY';
  static const String VNPAY = 'VNPAY';
  static const String MOMO = 'MOMO';
  static const String BANKING = 'BANKING';
  static const String VISA = 'VISA';
  static const String POINTIFY = 'POINTIFY';
}

enum PaymentTypeEnum { CASH, VIETQR, ZALOPAY, VNPAY }

var a = PaymentTypeEnum.CASH.toString();

class PromotionTypeEnums {
  static const String AMOUNT = 'Amount';
  static const String PRODUCT = 'Product';
  static const String PERCENT = 'Percent';
  static const String AUTOAPPLY = 'AutoApply';
}
