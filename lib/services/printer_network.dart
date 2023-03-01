// // ignore: import_of_legacy_library_into_null_safe
// import 'package:esc_pos_printer/esc_pos_printer.dart';
// import 'package:ping_discover_network/ping_discover_network.dart';

// import '../model/pos_styles.dart';

// // NetworkAnalyzer.discover pings PORT:IP one by one according to timeout.
// // NetworkAnalyzer.discover2 pings all PORT:IP addresses at once.
// final String subnet =
//     ip.toString().substring(0, ip.toString().lastIndexOf('.'));
// const int port = 80;
// final stream = NetworkAnalyzer.discover2(
//   '192.168.0',
//   port,
//   timeout: Duration(milliseconds: 5000),
// );

// int found = 0;
// // ignore: use_function_type_syntax_for_parameters

// void discoverAvailableNetworkDevice() {
//   stream.listen((NetworkAddress addr) {
//     if (addr.exists) {
//       found++;
//       print('Found device: ${addr.ip}:$port');
//     }
//   }).onDone(() => print('Finish. Found $found device(s)'));
// }

// void getLocalIp() {
//   stream.listen((NetworkAddress addr) {
//     if (addr.exists) {
//       print('Found device: ${addr.ip}');
//     }
//   });
// }

// void checkPortRange(String subnet, int fromPort, int toPort) {
//   if (fromPort > toPort) {
//     return;
//   }

//   print('port ${fromPort}');

//   final stream = NetworkAnalyzer.discover2(subnet, fromPort);

//   stream.listen((NetworkAddress addr) {
//     if (addr.exists) {
//       print('Found device: ${addr.ip}:${fromPort}');
//     }
//   }).onDone(() {
//     checkPortRange(subnet, fromPort + 1, toPort);
//   });
// }

// // checkPortRange('192.168.0', 400, 410);

// // void testReceipt(NetworkPrinter printer) {
// //   printer.text(
// //       'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
// //   printer.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
// //       styles: PosStyles(codeTable: 'CP1252'));
// //   printer.text('Special 2: blåbærgrød', styles: PosStyles(codeTable: 'CP1252'));

// //   printer.text('Bold text', styles: PosStyles(bold: true));
// //   printer.text('Reverse text', styles: PosStyles(reverse: true));
// //   printer.text('Underlined text',
// //       styles: PosStyles(underline: true), linesAfter: 1);
// //   printer.text('Align left', styles: PosStyles(align: PosAlign.left));
// //   printer.text('Align center', styles: PosStyles(align: PosAlign.center));
// //   printer.text('Align right',
// //       styles: PosStyles(align: PosAlign.right), linesAfter: 1);

// //   printer.text('Text size 200%',
// //       styles: PosStyles(
// //         height: PosTextSize.size2,
// //         width: PosTextSize.size2,
// //       ));

// //   printer.feed(2);
// //   printer.cut();
// // }
// void findPrinter() async {
//   // Find network printers
//   final Stream<NetworkAddress> stream = NetworkAnalyzer.discover2(
//     '192.168.0', // IP address prefix
//     9100, // Printer port
//   );
//   stream.listen((NetworkAddress addr) {
//     if (addr.exists) {
//       print('Found device: ${addr.ip}');
//     }
//   });

//   // Connect to printer
//   // final PrinterNetworkManager printerManager = PrinterNetworkManager();
//   // printerManager.selectPrinter('192.168.0.123', port: 9100);

//   // // Generate ticket
//   // final Ticket ticket = Ticket(PaperSize.mm80);
//   // ticket.text('Hello World!');

//   // // Print ticket
//   // await printerManager.printTicket(ticket);
// }
