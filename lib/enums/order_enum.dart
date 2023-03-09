enum OrderStateEnum {
  CHOOSE_ORDER_TYPE,
  BOOKING_TABLE,
  ORDER_PRODUCT,
  PAYMENT,
  COMPLETE_ORDER
}

enum DeliTypeEnum { TAKE_AWAY, IN_STORE, DELIVERY, NONE }

class DeliType {
  static const String TAKE_AWAY = 'TAKE_AWAY';
  static const String IN_STORE = 'IN_STORE';
  static const String DELIVERY = 'DELIVERY';
}

class OrderState {
  static const String CHOOSE_ORDER_TYPE = ' CHOOSE_ORDER_TYPE';
  static const String BOOKING_TABLE = 'BOOKING_TABLE';
  static const String DELIORDER_PRODUCTVERY = 'ORDER_PRODUCT';
  static const String PAYMENT = 'PAYMENT';
  static const String COMPLETE_ORDER = 'COMPLETE_ORDER';
}
