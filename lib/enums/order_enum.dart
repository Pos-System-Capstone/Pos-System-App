enum OrderStateEnum {
  CHOOSE_ORDER_TYPE,
  BOOKING_TABLE,
  ORDER_PRODUCT,
  PAYMENT,
  COMPLETE_ORDER
}

enum DeliTypeEnum { TAKE_AWAY, IN_STORE, DELIVERY, NONE }

enum PrinterTypeEnum { bill, stamp }

class DeliType {
  static const String TAKE_AWAY = 'TAKE_AWAY';
  static const String EAT_IN = 'EAT_IN';
  static const String DELIVERY = 'DELIVERY';
}

class OrderState {
  static const String CHOOSE_ORDER_TYPE = ' CHOOSE_ORDER_TYPE';
  static const String BOOKING_TABLE = 'BOOKING_TABLE';
  static const String DELIORDER_PRODUCTVERY = 'ORDER_PRODUCT';
  static const String PAYMENT = 'PAYMENT';
  static const String COMPLETE_ORDER = 'COMPLETE_ORDER';
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

String showOrderType(String type) {
  switch (type) {
    case DeliType.EAT_IN:
      return 'Tai quán';
    case DeliType.TAKE_AWAY:
      return 'Mang đi';
    case DeliType.DELIVERY:
      return 'Giao hàng';
    default:
      return 'Tại quán';
  }
}
