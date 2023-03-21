import 'package:intl/intl.dart';

String formatPrice(num price) {
  return NumberFormat.simpleCurrency(locale: 'vi').format(price);
}

String formatPriceWithoutUnit(num price) {
  NumberFormat format = NumberFormat("###0.0");
  format.minimumFractionDigits = 0;
  return format.format(price);
}

double convertWithDiscount(double price, double discount, String discountType) {
  if (discountType == 'amount') {
    price = price - discount;
  } else if (discountType == 'percent') {
    price = price - ((discount / 100) * price);
  }
  return price;
}

double calculation(double amount, double discount, String type, int quantity) {
  double calculatedAmount = 0;
  if (type == 'amount') {
    calculatedAmount = discount * quantity;
  } else if (type == 'percent') {
    calculatedAmount = (discount / 100) * (amount * quantity);
  }
  return calculatedAmount;
}

String percentCalculation(num amount) {
  return '${amount * 100}%';
}

String percentageCalculation(
    String price, String discount, String discountType) {
  return '$discount${discountType == 'percent' ? '%' : '\$'} OFF';
}

String formatTime(String time) {
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  String result = time.replaceAll('T', ' ');
  DateTime dateTime = dateFormat.parse(result);
  String formattedDate = DateFormat('HH:mm dd/MM/yyyy').format(dateTime);
  return formattedDate;
}
