/*
 * esc_pos_printer
 * Created by Andrey Ushakov
 * 
 * Copyright (c) 2019-2020. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'dart:async';
import 'dart:io';
import 'dart:typed_data' show Uint8List;
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:image/image.dart';
import 'package:intl/intl.dart';
import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:pos_apps/enums/view_status.dart';
import 'package:pos_apps/util/share_pref.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../widgets/Dialogs/other_dialogs/dialog.dart';
import 'base_view_model.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';

/// Network Printer
class NetworkPrinterViewModel extends BaseViewModel {
  String selectedIp = '';
  List<String> devices = [];
  String? selectedDevice;
  int selectedPort = 9100;
  List<PrinterDevice> printerDevices = [];
  PrinterDevice? selectedPrinter;
  UsbPrinterInfo? selectedUsbPrinter;
  TcpPrinterInfo? selectedTcpPrinter;
  StreamSubscription<PrinterDevice>? _subscription;

  PrinterManager printerManager = PrinterManager.instance;

  void printerScan(PrinterType type, {bool isBle = false}) {
    // Find printers
    setState(ViewStatus.Loading);
    printerDevices.clear();
    printerManager.discovery(type: type, isBle: isBle).listen((device) {
      printerDevices.add(device);
      // connectDevice(selectedPrinter, type);
    });
    setState(ViewStatus.Completed);
  }

  // void scan(PrinterType type) {
  //   setState(ViewStatus.Loading);
  //   devices.clear();
  //   _subscription = printerManager.discovery(type: type).listen((device) {
  //     switch (type) {
  //       case PrinterType.network:
  //         printerDevices.add(device);
  //         break;
  //       default:
  //     }
  //     // devices.add(BluetoothPrinter(
  //     //   deviceName: device.name,
  //     //   address: device.address,
  //     //   isBle: _isBle,
  //     //   vendorId: device.vendorId,
  //     //   productId: device.productId,
  //     //   typePrinter: defaultPrinterType,
  //     // ));
  //   });
  //   setState(ViewStatus.Completed);
  // }

  void selectDevice(PrinterDevice device, PrinterType type) async {
    if (selectedPrinter != null) {
      if ((device.address != selectedPrinter!.address) ||
          (type == PrinterType.usb &&
              selectedPrinter!.vendorId != device.vendorId)) {
        await printerManager.disconnect(type: type);
      }
    }
    print(selectedPrinter!.name);
    selectedPrinter = device;
  }

  void connectDevice(PrinterDevice selectedPrinter, PrinterType type,
      {bool reconnect = false, bool isBle = false, String? ipAddress}) async {
    switch (type) {
      // only windows and android
      case PrinterType.usb:
        await printerManager.connect(
            type: type,
            model: UsbPrinterInput(
                name: selectedPrinter.name,
                productId: selectedPrinter.productId,
                vendorId: selectedPrinter.vendorId));
        break;
      // only iOS and android
      // case PrinterType.bluetooth:
      //   await PrinterManager.instance.connect(
      //       type: type,
      //       model: BluetoothPrinterInput(
      //           name: selectedPrinter.name,
      //           address: selectedPrinter.address!,
      //           isBle: isBle,
      //           autoConnect: reconnect));
      //   break;
      case PrinterType.network:
        await printerManager.connect(
            type: type,
            model: TcpPrinterInput(
                ipAddress: ipAddress ?? selectedPrinter.address!));
        break;
      default:
    }
  }

  void disconnectPrinterDevice(PrinterType type) async {
    await printerManager.disconnect(type: type);
  }

  void sendBytesToPrint(List<int> bytes, PrinterType type) async {
    printerManager.send(type: type, bytes: bytes);
  }

  Future printReceiveTest(PrinterType type) async {
    List<int> bytes = [];
    const PaperSize paper = PaperSize.mm58;
    final profile = await CapabilityProfile.load();
    // final printer = NetworkPrinter(paper, profile);
    // Xprinter XP-N160I
    // final profile = await CapabilityProfile.load(name: 'XP-N160I');
    // PaperSize.mm80 or PaperSize.mm58
    final generator = Generator(paper, profile);
    bytes += generator.setGlobalCodeTable('CP1252');
    bytes += generator.text('DEER COFFEE',
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes += generator.text('S2.02 Vinhome Grand Park',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('91 Nguyen Huu Canh, HCM',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('SDT: 0123456789',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('Web: www.deercoffee.com',
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);

    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(text: 'Sl', width: 1),
      PosColumn(text: 'Sp', width: 7),
      PosColumn(
          text: 'Gia', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(
          text: 'Tong', width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);

    bytes += generator.row([
      PosColumn(text: '2', width: 1),
      PosColumn(text: 'ONION RINGS', width: 7),
      PosColumn(
          text: '0.99', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(
          text: '1.98', width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: '1', width: 1),
      PosColumn(text: 'PIZZA', width: 7),
      PosColumn(
          text: '3.45', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(
          text: '3.45', width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: '1', width: 1),
      PosColumn(text: 'SPRING ROLLS', width: 7),
      PosColumn(
          text: '2.99', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(
          text: '2.99', width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: '3', width: 1),
      PosColumn(text: 'CRUNCHY STICKS', width: 7),
      PosColumn(
          text: '0.85', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(
          text: '2.55', width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.hr();

    bytes += generator.row([
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

    bytes += generator.hr(ch: '=', linesAfter: 1);

    bytes += generator.row([
      PosColumn(
          text: 'Cash',
          width: 8,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
      PosColumn(
          text: '\$15.00',
          width: 4,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'Change',
          width: 8,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
      PosColumn(
          text: '\$4.03',
          width: 4,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    ]);

    bytes += generator.feed(2);
    bytes += generator.text('Thank you!',
        styles: PosStyles(align: PosAlign.center, bold: true));

    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    bytes += generator.text(timestamp,
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

    //   bytes += generator.image(img!);
    // } catch (e) {
    //   print(e);
    // }

    // Print BarCode
    final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    bytes += generator.barcode(Barcode.upcA(barData));
    bytes += generator.feed(2);
    // Print QR Code using native function
    bytes += generator.qrcode('example.com', size: QRSize.Size6);
    bytes += generator.cut();
    printEscPos(bytes, generator, type);
  }

  /// print ticket
  void printEscPos(
      List<int> bytes, Generator generator, PrinterType type) async {
    // if (selectedUsbPrinter == null) return;
    if (selectedPrinter == null) return;
    switch (type) {
      case PrinterType.usb:
        bytes += generator.feed(2);
        bytes += generator.cut();
        await printerManager.connect(
            type: type,
            model: UsbPrinterInput(
                name: selectedPrinter?.name,
                productId: selectedPrinter?.productId,
                vendorId: selectedPrinter?.vendorId));
        setState(ViewStatus.Completed);
        break;
      // case PrinterType.bluetooth:
      //   bytes += generator.cut();
      //   await printerManager.connect(
      //       type: bluetoothPrinter.typePrinter,
      //       model: BluetoothPrinterInput(
      //           name: bluetoothPrinter.deviceName,
      //           address: bluetoothPrinter.address!,
      //           isBle: bluetoothPrinter.isBle ?? false,
      //           autoConnect: _reconnect));
      //   pendingTask = null;
      //   if (Platform.isAndroid) pendingTask = bytes;
      //   break;
      case PrinterType.network:
        bytes += generator.feed(2);
        bytes += generator.cut();
        await printerManager.connect(
            type: type,
            model: TcpPrinterInput(ipAddress: selectedPrinter!.address!));
        break;
      default:
    }
    if (type == PrinterType.bluetooth && Platform.isAndroid) {
      // if (currentStatus == BTStatus.connected) {
      //   printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
      //   pendingTask = null;
      // }
    } else if (type == PrinterType.usb && Platform.isWindows) {
      printerManager.send(type: type, bytes: bytes);
    } else {
      print("test Printer NETWORK");
      printerManager.send(type: type, bytes: bytes);
      printerManager.disconnect(type: type);
    }
  }

  void discover(String ip, String port) async {
    setState(ViewStatus.Loading);
    devices.clear();
    selectedIp = ip;
    final String subnet = ip.substring(0, ip.lastIndexOf('.'));
    selectedPort = int.parse(port);
    print('subnet:\t$subnet, port:\t$selectedPort');
    final stream = NetworkAnalyzer.discover2(subnet, selectedPort);
    stream.listen((NetworkAddress addr) {
      if (addr.exists) {
        print('Found device: ${addr.ip}');
        devices.add(addr.ip);
      }
    })
      ..onDone(() {
        print('Finished scanning');
        setState(ViewStatus.Completed);
        notifyListeners();
      })
      ..onError((dynamic e) {
        showAlertDialog(title: 'Unexpected exception');
      });
  }

  void savePrinterDevice(String device) {
    selectedDevice = device;
    setPrinterDeviceIP(device);
    notifyListeners();
  }

  void deletePrinter() {
    selectedDevice = null;
    deletePrinterDeviceIP();
    notifyListeners();
  }

  bool isDeviceSaved(String currentDevice) {
    // Future<String?> ip = getPrinterDeviceIP();
    if (currentDevice == selectedDevice) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> testReceipt(NetworkPrinter printer) async {
    printer.text(
        'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    printer.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
        styles: PosStyles(codeTable: 'CP1252'));
    printer.text('Special 2: blåbærgrød',
        styles: PosStyles(codeTable: 'CP1252'));

    printer.text('Bold text', styles: PosStyles(bold: true));
    printer.text('Reverse text', styles: PosStyles(reverse: true));
    printer.text('Underlined text',
        styles: PosStyles(underline: true), linesAfter: 1);
    printer.text('Align left', styles: PosStyles(align: PosAlign.left));
    printer.text('Align center', styles: PosStyles(align: PosAlign.center));
    printer.text('Align right',
        styles: PosStyles(align: PosAlign.right), linesAfter: 1);

    printer.row([
      PosColumn(
        text: 'col3',
        width: 3,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col6',
        width: 6,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col3',
        width: 3,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
    ]);

    printer.text('Text size 200%',
        styles: PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));

    // Print image
    // final ByteData data = await rootBundle.load('assets/logo.png');
    // final Uint8List bytes = data.buffer.asUint8List();
    // final Image? image = decodeImage(bytes);
    // printer.image(image!);
    // Print image using alternative commands
    // printer.imageRaster(image);
    // printer.imageRaster(image, imageFn: PosImageFn.graphics);

    // Print barcode
    final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    printer.barcode(Barcode.upcA(barData));

    // Print mixed (chinese + latin) text. Only for printers supporting Kanji mode
    // printer.text(
    //   'hello ! 中文字 # world @ éphémère &',
    //   styles: PosStyles(codeTable: PosCodeTable.westEur),
    //   containsChinese: true,
    // );

    printer.feed(2);
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
    printer.text('New Braunfels, TX',
        styles: PosStyles(align: PosAlign.center));
    printer.text('Tel: 830-221-1234',
        styles: PosStyles(align: PosAlign.center));
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
      PosColumn(
          text: '0.99', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(
          text: '1.98', width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);
    printer.row([
      PosColumn(text: '1', width: 1),
      PosColumn(text: 'PIZZA', width: 7),
      PosColumn(
          text: '3.45', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(
          text: '3.45', width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);
    printer.row([
      PosColumn(text: '1', width: 1),
      PosColumn(text: 'SPRING ROLLS', width: 7),
      PosColumn(
          text: '2.99', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(
          text: '2.99', width: 2, styles: PosStyles(align: PosAlign.right)),
    ]);
    printer.row([
      PosColumn(text: '3', width: 1),
      PosColumn(text: 'CRUNCHY STICKS', width: 7),
      PosColumn(
          text: '0.85', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(
          text: '2.55', width: 2, styles: PosStyles(align: PosAlign.right)),
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

  void testPrint(String printerIp) async {
    const PaperSize paper = PaperSize.mm58;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);

    final PosPrintResult res = await printer.connect(printerIp, port: 9100);

    if (res == PosPrintResult.success) {
      // DEMO RECEIPT
      await printDemoReceipt(printer);
      // TEST PRINT
      // await testReceipt(printer);
      // printer.disconnect();
    }
    showAlertDialog(title: res.msg, content: "In thành công");

    // final snackBar =
    //     GetSnackBar(titleText: Text(res.msg, textAlign: TextAlign.center));
    // Get.showSnackbar(snackBar);
  }

  // ************************ (end) Printer Commands ************************
}
