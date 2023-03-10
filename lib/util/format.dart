import 'package:intl/intl.dart';

String formatPrice(int price) {
  return NumberFormat.simpleCurrency(locale: 'vi').format(price);
}

String formatPriceWithoutUnit(double price) {
  NumberFormat format = NumberFormat("###0.00");
  format.minimumFractionDigits = 0;
  return format.format(price);
}

// String convertPrice(double price, {double? discount, String? discountType}) {
//   if (discount != null && discountType != null) {
//     if (discountType == 'amount') {
//       price = price - discount;
//     } else if (discountType == 'percent') {
//       price = price - ((discount / 100) * price);
//     }
//   return '\$'
//       '${(price).toStringAsFixed(Get.find<SplashController>().configModel?.decimalPointSettings ?? 2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
// }
//   }

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
