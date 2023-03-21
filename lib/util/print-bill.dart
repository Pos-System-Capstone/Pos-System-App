import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:intl/intl.dart';
import 'package:pos_apps/data/model/response/order_response.dart';
import 'package:pos_apps/util/format.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tiengviet/tiengviet.dart';

Future<void> printBillModel(
    OrderResponseModel order, NetworkPrinter printer) async {
  printer.text('DEER COFFFEE',
      styles: PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
      linesAfter: 1);

  printer.text('Vinhome GrandPark TP Thu Duc, HCM',
      styles: PosStyles(align: PosAlign.center));
  printer.text('Tel: 830-221-1234', styles: PosStyles(align: PosAlign.center));
  printer.text('Web: www.example.com',
      styles: PosStyles(align: PosAlign.center), linesAfter: 1);

  printer.text('HOA DON',
      styles: PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
      linesAfter: 1);
  printer.hr();
  printer.row([
    PosColumn(
        text: 'Ma don',
        width: 4,
        styles: PosStyles(
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        )),
    PosColumn(
        text: order.invoiceId.toString(),
        width: 8,
        styles: PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        )),
  ]);
  printer.row([
    PosColumn(
        text: 'Thoi gian',
        width: 4,
        styles: PosStyles(
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        )),
    PosColumn(
        text: formatTime(order.checkInDate!),
        width: 8,
        styles: PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        )),
  ]);
  printer.hr();
  printer.row([
    PosColumn(text: 'Ten Mon', width: 8),
    PosColumn(text: 'SL', width: 1),
    PosColumn(text: 'Tong', width: 3, styles: PosStyles(align: PosAlign.right)),
  ]);

  List<ProductList>? productList = order.productList;
  for (ProductList product in productList!) {
    printer.text(TiengViet.parse(product.name.toString()),
        styles: PosStyles(align: PosAlign.left));
    printer.row([
      PosColumn(text: '', width: 8, styles: PosStyles(align: PosAlign.left)),
      PosColumn(text: product.quantity.toString(), width: 1),
      PosColumn(
          text: product.totalAmount.toString(),
          width: 3,
          styles: PosStyles(align: PosAlign.right)),
    ]);
    if (product.extras != null) {
      for (var extra in product.extras!) {
        printer.row([
          PosColumn(
              text: "+${TiengViet.parse(extra.name.toString())}",
              width: 9,
              styles: PosStyles(align: PosAlign.left)),
          PosColumn(
              text: "+${TiengViet.parse(extra.sellingPrice.toString())}",
              width: 3,
              styles: PosStyles(align: PosAlign.right)),
        ]);
      }
    }
  }
  printer.hr();
  printer.row([
    PosColumn(
        text: 'Tam tinh',
        width: 4,
        styles: PosStyles(
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        )),
    PosColumn(
        text: order.totalAmount!.toString(),
        width: 8,
        styles: PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        )),
  ]);

  printer.row([
    PosColumn(
        text: 'Giam gia',
        width: 4,
        styles: PosStyles(
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        )),
    PosColumn(
        text: " - ${order.discount!.toString()}",
        width: 8,
        styles: PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        )),
  ]);

  printer.row([
    PosColumn(
        text: 'VAT',
        width: 4,
        styles: PosStyles(
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        )),
    PosColumn(
        text:
            '(${percentCalculation(order.vat!)})${formatPriceWithoutUnit(order.vatAmount!)}',
        width: 8,
        styles: PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        )),
  ]);

  printer.hr();
  printer.row([
    PosColumn(
        text: 'Tong',
        width: 4,
        styles: PosStyles(
          fontType: PosFontType.fontB,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        )),
    PosColumn(
        text: order.finalAmount!.toString(),
        width: 8,
        styles: PosStyles(
          fontType: PosFontType.fontB,
          align: PosAlign.right,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        )),
  ]);

  printer.hr(ch: '=', linesAfter: 1);

  printer.feed(2);
  printer.text('Thank you!',
      styles: PosStyles(align: PosAlign.center, bold: true));

  // printer.text(formatTime(order.checkInDate.toString()),
  //     styles: PosStyles(align: PosAlign.center), linesAfter: 2);

  // Print QR Code from image
  // try {
  //   const String qrData = 'example.com';
  //   const double qrSize = 200;
  //   final uiImg = await QrPainter(
  //     data: qrData,
  //     version: QrVersions.auto,
  //     gapless: false,
  //   ).toImageData(qrSize);
  //   final dir = await getTemporaryDirectory();
  //   final pathName = '${dir.path}/qr_tmp.png';
  //   final qrFile = File(pathName);
  //   final imgFile = await qrFile.writeAsBytes(uiImg!.buffer.asUint8List());
  //   final img = decodeImage(imgFile.readAsBytesSync());

  //   printer.image(img!);
  // } catch (e) {
  //   print(e);
  // }
  // Print QR Code using native function
  printer.qrcode('example.com');
  printer.feed(1);
  printer.cut();
}

Future<void> printDemoReceipt(NetworkPrinter printer) async {
  // Print image
  // final ByteData data = await rootBundle.load('assets/rabbit_black.jpg');
  // final Uint8List bytes = data.buffer.asUint8List();
  // final Image? image = decodeImage(bytes);
  // printer.image(image!);

  printer.text('GROCERYLY',
      styles: PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
      linesAfter: 1);
  printer.text('889  Watson Lane', styles: PosStyles(align: PosAlign.center));
  printer.text('New Braunfels, TX', styles: PosStyles(align: PosAlign.center));
  printer.text('Tel: 830-221-1234', styles: PosStyles(align: PosAlign.center));
  printer.text('Web: www.example.com',
      styles: PosStyles(align: PosAlign.center), linesAfter: 1);

  printer.hr();
  printer.row([
    PosColumn(text: 'Qty', width: 1),
    PosColumn(text: 'Item', width: 7),
    PosColumn(
        text: 'Price', width: 2, styles: PosStyles(align: PosAlign.right)),
    PosColumn(
        text: 'Total', width: 2, styles: PosStyles(align: PosAlign.right)),
  ]);

  printer.row([
    PosColumn(text: '2', width: 1),
    PosColumn(text: 'ONION RINGS', width: 7),
    PosColumn(text: '0.99', width: 2, styles: PosStyles(align: PosAlign.right)),
    PosColumn(text: '1.98', width: 2, styles: PosStyles(align: PosAlign.right)),
  ]);
  printer.row([
    PosColumn(text: '1', width: 1),
    PosColumn(text: 'PIZZA', width: 7),
    PosColumn(text: '3.45', width: 2, styles: PosStyles(align: PosAlign.right)),
    PosColumn(text: '3.45', width: 2, styles: PosStyles(align: PosAlign.right)),
  ]);
  printer.row([
    PosColumn(text: '1', width: 1),
    PosColumn(text: 'SPRING ROLLS', width: 7),
    PosColumn(text: '2.99', width: 2, styles: PosStyles(align: PosAlign.right)),
    PosColumn(text: '2.99', width: 2, styles: PosStyles(align: PosAlign.right)),
  ]);
  printer.row([
    PosColumn(text: '3', width: 1),
    PosColumn(text: 'CRUNCHY STICKS', width: 7),
    PosColumn(text: '0.85', width: 2, styles: PosStyles(align: PosAlign.right)),
    PosColumn(text: '2.55', width: 2, styles: PosStyles(align: PosAlign.right)),
  ]);
  printer.hr();

  printer.row([
    PosColumn(
        text: 'TOTAL',
        width: 6,
        styles: PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        )),
    PosColumn(
        text: '\$10.97',
        width: 6,
        styles: PosStyles(
          align: PosAlign.right,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        )),
  ]);

  printer.hr(ch: '=', linesAfter: 1);

  printer.row([
    PosColumn(
        text: 'Cash',
        width: 8,
        styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    PosColumn(
        text: '\$15.00',
        width: 4,
        styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
  ]);
  printer.row([
    PosColumn(
        text: 'Change',
        width: 8,
        styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    PosColumn(
        text: '\$4.03',
        width: 4,
        styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
  ]);

  printer.feed(2);
  printer.text('Thank you!',
      styles: PosStyles(align: PosAlign.center, bold: true));

  final now = DateTime.now();
  final formatter = DateFormat('MM/dd/yyyy H:m');
  final String timestamp = formatter.format(now);
  printer.text(timestamp,
      styles: PosStyles(align: PosAlign.center), linesAfter: 2);

  // Print QR Code from image
  // try {
  //   const String qrData = 'example.com';
  //   const double qrSize = 200;
  //   final uiImg = await QrPainter(
  //     data: qrData,
  //     version: QrVersions.auto,
  //     gapless: false,
  //   ).toImageData(qrSize);
  //   final dir = await getTemporaryDirectory();
  //   final pathName = '${dir.path}/qr_tmp.png';
  //   final qrFile = File(pathName);
  //   final imgFile = await qrFile.writeAsBytes(uiImg!.buffer.asUint8List());
  //   final img = decodeImage(imgFile.readAsBytesSync());

  //   printer.image(img!);
  // } catch (e) {
  //   print(e);
  // }

  // Print QR Code using native function
  // printer.qrcode('example.com');

  printer.feed(1);
  printer.cut();
}
