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
import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:get/get.dart';
import 'package:image/image.dart';
import 'package:intl/intl.dart';
import 'package:network_tools/network_tools.dart';
import 'package:pos_apps/enums/view_status.dart';
import 'package:pos_apps/util/share_pref.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../widgets/Dialogs/other_dialogs/dialog.dart';
import 'base_view_model.dart';

/// Network Printer
class NetworkPrinterViewModel extends BaseViewModel {
  String selectedIp = '';
  List<String> devices = [];
  String? selectedDevice;
  int selectedPort = 9100;

  NetworkPrinter? networkPrinter;

  PrinterManager printerManager = PrinterManager.instance;
  UsbPrinterConnector usbPrinterConnector = UsbPrinterConnector.instance;
  List<PrinterDevice> printerDevices = [];
  PrinterDevice? selectedPrinterDevices;
  //Create an instance of printer

  scanPrinter(PrinterType type) {
    setState(ViewStatus.Loading);
    printerDevices.clear();
    print('Progress for finding printers');
    // Find printers
    usbPrinterConnector.discovery().listen((device) {
      print('Found device: ${device.name}');
      print('Found device address: ${device.address}');
      print('Found device productId: ${device.productId}');
      print('Found device vendor ID: ${device.vendorId}');
      print('Found device type: ${device.operatingSystem}');
      printerDevices.add(device);
    }, onDone: () {
      print('Finished scanning');
      setState(ViewStatus.Completed);
      notifyListeners();
    }, onError: ((dynamic e) {
      showAlertDialog(title: 'Unexpected exception');
    }));
    notifyListeners();
  }

  void selectDevice(PrinterDevice device) async {
    selectedPrinterDevices = device;
    notifyListeners();
  }

  connectDevice(PrinterDevice selectedPrinter, PrinterType type,
      {bool reconnect = false, bool isBle = false, String? ipAddress}) async {
    selectedPrinterDevices = selectedPrinter;
    switch (type) {
      case PrinterType.usb:
        printerManager.connect(
            type: PrinterType.usb,
            model: UsbPrinterInput(
                name: selectedPrinter.name,
                productId: selectedPrinter.productId,
                vendorId: selectedPrinter.vendorId));
        break;
      case PrinterType.network:
        printerManager.connect(
            type: PrinterType.network,
            model: TcpPrinterInput(ipAddress: selectedPrinter.address!));
        break;
      default:
        break;
    }
    printReceiveTest();
    printerManager.disconnect(type: PrinterType.usb);
  }

  sendBytesToPrint(List<int> bytes, PrinterType type) async {
    printerManager.send(type: type, bytes: bytes);
  }

  void printEscPos(
    List<int> bytes,
    Generator generator,
    PrinterType type,
  ) async {
    if (selectedPrinterDevices == null) return;
    switch (type) {
      case PrinterType.usb:
        bytes += generator.feed(2);
        bytes += generator.cut();
        await printerManager.connect(
            type: PrinterType.usb,
            model: UsbPrinterInput(
                name: selectedPrinterDevices?.name,
                productId: selectedPrinterDevices?.productId,
                vendorId: selectedPrinterDevices?.vendorId));
        break;
      case PrinterType.bluetooth:
        bytes += generator.cut();
        await printerManager.connect(
            type: PrinterType.bluetooth,
            model: BluetoothPrinterInput(
                name: selectedPrinterDevices?.name,
                address: selectedPrinterDevices!.address!,
                isBle: true,
                autoConnect: false));
        // if (Platform.isAndroid) pendingTask = bytes;
        break;
      case PrinterType.network:
        bytes += generator.feed(2);
        bytes += generator.cut();
        await printerManager.connect(
            type: PrinterType.network,
            model:
                TcpPrinterInput(ipAddress: selectedPrinterDevices!.address!));
        break;
      default:
    }
    if (type == PrinterType.bluetooth && Platform.isAndroid) {
      //   if (_currentStatus == BTStatus.connected) {
      //     printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
      //     pendingTask = null;
      //   }
      // } else {
      //   printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
      // }
    }
  }

  Future printReceiveTest() async {
    List<int> bytes = [];
    const PaperSize paper = PaperSize.mm58;
    final profile = await CapabilityProfile.load();
    // Xprinter XP-N160I
    // PaperSize.mm80 or PaperSize.mm58
    final generator = Generator(paper, profile);
    bytes += generator.setGlobalCodeTable('CP1252');
    bytes += generator.text('Test Print',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Product 1');
    bytes += generator.text('Product 2');
    printerManager.send(type: PrinterType.usb, bytes: bytes);
    print("Print Done");
  }

  void discover(String ip, String port) async {
    setState(ViewStatus.Loading);
    devices.clear();
    selectedIp = ip;
    final String subnet = ip.substring(0, ip.lastIndexOf('.'));
    selectedPort = int.parse(port);
    print('subnet:\t$subnet, port:\t$selectedPort');
// Register DartPingIOS
    if (GetPlatform.isIOS) {
      DartPingIOS.register();
    }
// Create ping object with desired args

    final stream = HostScanner.scanDevicesForSinglePort(subnet, selectedPort,
        progressCallback: (progress) {
      print('Progress for host discovery : $progress');
    });
    stream.listen((ActiveHost host) async {
      //Same host can be emitted multiple times
      //Use Set<ActiveHost> instead of List<ActiveHost>
      String ip = host.address;

      print('Found device: $ip');
      devices.add(host.address);
    }, onDone: () {
      print('Finished scanning');
      setState(ViewStatus.Completed);
      notifyListeners();
    }, onError: ((dynamic e) {
      showAlertDialog(title: 'Unexpected exception');
    }));
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

  void connectPrinter(String printerIp) async {
    selectedDevice = printerIp;
    const PaperSize paper = PaperSize.mm58;
    final profile = await CapabilityProfile.load();
    // final printer = NetworkPrinter(paper, profile);
    networkPrinter = NetworkPrinter(paper, profile);

    final PosPrintResult res =
        await networkPrinter!.connect(printerIp, port: 9100);

    if (res == PosPrintResult.success) {
      // DEMO RECEIPT
      await testReceipt(networkPrinter!);
      // TEST PRINT
      // await testReceipt(printer);
      networkPrinter!.disconnect();
    }
    showAlertDialog(title: res.msg, content: "Ket noi thanh cong");

    // final snackBar =
    //     GetSnackBar(titleText: Text(res.msg, textAlign: TextAlign.center));
    // Get.showSnackbar(snackBar);
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
      printer.disconnect();
    }
    showAlertDialog(title: res.msg, content: "In thành công");

    // final snackBar =
    //     GetSnackBar(titleText: Text(res.msg, textAlign: TextAlign.center));
    // Get.showSnackbar(snackBar);
  }

  // ************************ (end) Printer Commands ************************
}
