import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

String formatPrice(num price, {num discount = 0}) {
  NumberFormat format = NumberFormat("#,###.##");
  format.minimumFractionDigits = 0;
  // final format = NumberFormat.currency(
  //   locale: 'vi_VN',
  //   symbol: '',
  //   decimalDigits: 0,
  // );
  return format.format(price);
}

Widget priceWidget(num price, TextStyle? style, {num discount = 0}) {
  if (discount == 0) {
    return Text(formatPrice(price, discount: discount), style: style);
  } else {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("(${formatPrice(price)})",
            style: style?.copyWith(decoration: TextDecoration.lineThrough)),
        SizedBox(width: 2),
        Text(
          formatPrice(price, discount: discount),
          style: style,
        ),
      ],
    );
  }
}

String convertPrice(num price, {num discount = 0}) {
  price = price - discount;
  return '\$'
      '${(price).toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
}

String formatPriceWithoutUnit(num price) {
  NumberFormat format = NumberFormat("#,###.##");
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
  return '${(amount * 100).toStringAsFixed(0)}%';
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

String formatOnlyTime(String time) {
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  String result = time.replaceAll('T', ' ');
  DateTime dateTime = dateFormat.parse(result);
  String formattedDate = DateFormat('HH:mm').format(dateTime);
  return formattedDate;
}

String formatOnlyDate(String time) {
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  String result = time.replaceAll('T', ' ');
  DateTime dateTime = dateFormat.parse(result);
  String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
  return formattedDate;
}

String formatTimeOnly(String time) {
  DateTime dateTime = DateFormat("HH:mm:ss").parse(time);
  String formattedDate = DateFormat('HH:mm').format(dateTime);
  return formattedDate;
}
