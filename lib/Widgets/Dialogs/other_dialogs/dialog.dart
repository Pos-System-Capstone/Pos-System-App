import 'package:flutter/material.dart';

import 'package:get/get.dart';

Future<void> showChooseDeliTypeDialog() async {
  hideDialog();
  await Get.dialog(Dialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0))),
    child: Container(
      width: MediaQuery.of(Get.overlayContext!).size.width * 0.5,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.background,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Get.theme.colorScheme.shadow,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Chọn hình thức giao hàng",
            style: Get.textTheme.headline6,
          ),
          Divider(
            color: Get.theme.colorScheme.onBackground,
          ),
          Container(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                deliveryOptionButton(
                  "Giao hàng",
                  Icons.delivery_dining,
                  () => hideDialog(),
                ),
                deliveryOptionButton(
                  "Tại cửa hàng",
                  Icons.store,
                  () => hideDialog(),
                ),
                deliveryOptionButton(
                  "Mang về",
                  Icons.coffee_maker_outlined,
                  () => hideDialog(),
                ),
              ],
            ),
          )),
        ],
      ),
    ),
  ));
}

Widget deliveryOptionButton(String title, IconData icon, Function() onTap) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 140,
        height: 140,
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, size: 56),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    title,
                    style: Get.textTheme.bodyText1,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

// void showLoadingDialog() {
//   hideDialog();
//   Get.defaultDialog(
//       barrierDismissible: true,
//       title: "Chờ mình xý nha...",
//       content: WillPopScope(
//         onWillPop: () {},
//         child: Container(
//           padding: const EdgeInsets.all(8),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Image(
//                 width: 72,
//                 height: 72,
//                 image: AssetImage("assets/images/loading.gif"),
//               ),
//             ],
//           ),
//         ),
//       ),
//       titleStyle: BeanOiTheme.typography.h2);
// }

// Future<bool> showErrorDialog(
//     {String errorTitle = "Có một chút trục trặc nhỏ!!"}) async {
//   hideDialog();
//   bool result = false;
//   await Get.dialog(
//       Dialog(
//         backgroundColor: Colors.white,
//         elevation: 8.0,
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(16.0))),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Align(
//               alignment: Alignment.topRight,
//               child: IconButton(
//                 icon: Icon(
//                   AntDesign.closecircleo,
//                   color: Colors.red,
//                 ),
//                 onPressed: () {
//                   hideDialog();
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(1, 0, 1, 0),
//               child: Text(
//                 errorTitle,
//                 textAlign: TextAlign.center,
//                 style: Get.theme.textTheme.headline2,
//               ),
//             ),
//             SizedBox(
//               height: 8,
//             ),
//             Image(
//               width: 96,
//               height: 96,
//               image: AssetImage("assets/images/error.png"),
//             ),
//             SizedBox(
//               height: 8,
//             ),
//             Container(
//               width: double.infinity,
//               child: FlatButton(
//                 color: kPrimary,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.only(
//                         bottomRight: Radius.circular(16),
//                         bottomLeft: Radius.circular(16))),
//                 onPressed: () {
//                   result = true;
//                   hideDialog();
//                 },
//                 child: Padding(
//                   padding: EdgeInsets.only(top: 16, bottom: 16),
//                   child: Text(
//                     "Thử lại",
//                     style: Get.theme.textTheme.headline4
//                         .copyWith(color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       barrierDismissible: true);
//   return result;
// }

// Future<int> showOptionDialog(String text,
//     {String firstOption, String secondOption}) async {
//   // hideDialog();
//   int option;
//   await Get.dialog(
//     WillPopScope(
//       onWillPop: () {},
//       child: Dialog(
//         backgroundColor: Colors.white,
//         elevation: 8.0,
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(16.0))),
//         child: Stack(
//           clipBehavior: Clip.none,
//           children: [
//             Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Align(
//                   alignment: Alignment.topLeft,
//                   child: IconButton(
//                     icon: Icon(
//                       AntDesign.closecircleo,
//                       color: Colors.red,
//                     ),
//                     onPressed: () {
//                       option = 0;
//                       hideDialog();
//                     },
//                   ),
//                 ),
//                 SizedBox(
//                   height: 54,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     text,
//                     style: Get.theme.textTheme.headline4,
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 16,
//                 ),
//                 Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                       border: Border(
//                     top: BorderSide(
//                       color: Colors.grey[300],
//                     ),
//                   )),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: FlatButton(
//                           // color: Colors.grey,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.only(
//                             // bottomRight: Radius.circular(16),
//                             bottomLeft: Radius.circular(16),
//                           )),
//                           child: Padding(
//                             padding:
//                                 const EdgeInsets.only(top: 16.0, bottom: 16.0),
//                             child: Center(
//                               child: Text(
//                                 firstOption ?? "Hủy",
//                                 style: Get.theme.textTheme.headline4
//                                     .copyWith(color: Colors.grey),
//                               ),
//                             ),
//                           ),
//                           onPressed: () {
//                             option = 0;
//                             hideDialog();
//                           },
//                         ),
//                       ),
//                       Expanded(
//                         child: FlatButton(
//                           color: kPrimary,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.only(
//                               bottomRight: Radius.circular(16),
//                               // bottomLeft: Radius.circular(16),
//                             ),
//                           ),
//                           child: Padding(
//                             padding:
//                                 const EdgeInsets.only(top: 16.0, bottom: 16.0),
//                             child: Center(
//                               child: Text(
//                                 secondOption ?? "Đồng ý",
//                                 style: Get.theme.textTheme.headline4
//                                     .copyWith(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                           onPressed: () {
//                             option = 1;
//                             hideDialog();
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Positioned(
//               top: -54,
//               right: -8,
//               child: Image(
//                 image: AssetImage("assets/images/option.png"),
//                 width: 160,
//                 height: 160,
//               ),
//             )
//           ],
//         ),
//       ),
//     ),
//     barrierDismissible: true,
//   );
//   return option;
// }

void hideDialog() {
  if (Get.isDialogOpen ?? false) {
    Get.back();
  }
}

void hideSnackbar() {
  if (Get.isSnackbarOpen) {
    Get.back();
  }
}

// Future<void> showTimeDialog(RootViewModel model) async {
//   await Get.dialog(
//       ScopedModel(
//         model: model,
//         child: ScopedModelDescendant<RootViewModel>(
//             builder: (context, child, model) {
//           List<Widget> timeSlots = new List();
//           model.currentStore.timeSlots.forEach((element) {
//             // int fromHour = double.parse(element.from.split(":")[0]).toInt();
//             // int fromMinute = double.parse(element.from.split(":")[1]).toInt();
//             //
//             // int toHour = double.parse(element.from.split(":")[0]).toInt();
//             // int toMinute = double.parse(element.from.split(":")[1]).toInt();
//
//             timeSlots.add(
//               RadioListTile(
//                 activeColor: Colors.red,
//                 value: element.menuId,
//                 title: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text.rich(
//                       TextSpan(
//                         text: "Bắt đầu: ",
//                         children: [
//                           TextSpan(
//                             text: "${element.from.substring(0, 5)}",
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 color:
//                                     element.available ? kPrimary : Colors.grey),
//                           )
//                         ],
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 13,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 4,
//                     ),
//                     Text.rich(
//                       TextSpan(
//                         text: "Chốt đơn: ",
//                         children: [
//                           TextSpan(
//                             text: "${element.to.substring(0, 5)}",
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 color:
//                                     element.available ? kPrimary : Colors.grey),
//                           )
//                         ],
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 13,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 groupValue: model.tmpTimeSlot.menuId,
//                 onChanged: (value) {
//                   model.selectTimeSlot(value);
//                 },
//               ),
//             );
//           });
//           String recieveDate = "Hôm nay";
//           DateTime currentDate = DateTime.now();
//           int hour =
//               double.parse(model.tmpTimeSlot.arrive.split(":")[0]).toInt();
//           int minute =
//               double.parse(model.tmpTimeSlot.arrive.split(":")[1]).toInt();
//           DateTime recieveTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(
//               "${currentDate.year}-${currentDate.month}-${currentDate.day} $hour:$minute:00");
//           print(recieveTime.toString());
//           if (recieveTime.compareTo(currentDate) < 0) {
//             recieveDate = "Ngày mai";
//           }
//
//           return WillPopScope(
//             onWillPop: () {},
//             child: Dialog(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(8.0))),
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(
//                       child: Text(
//                         "Đặt lúc",
//                         style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 8,
//                     ),
//                     Text.rich(
//                         TextSpan(
//                             text: "🔔 Dự kiến giao: $recieveDate vào ",
//                             children: [
//                               TextSpan(
//                                   text:
//                                       "${model.tmpTimeSlot.arrive.substring(0, 5)}",
//                                   style: TextStyle(
//                                       color: Colors.orange,
//                                       fontWeight: FontWeight.bold))
//                             ]),
//                         style: TextStyle(fontSize: 14)),
//                     SizedBox(
//                       height: 4,
//                     ),
//                     ...timeSlots,
//                     Container(
//                       width: double.infinity,
//                       child: FlatButton(
//                           padding: EdgeInsets.all(8),
//                           textColor: Colors.white,
//                           color: kPrimary,
//                           shape: RoundedRectangleBorder(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(8))),
//                           onPressed: () {
//                             model.confirmTimeSlot();
//                           },
//                           child: Text("Đồng ý")),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//       barrierDismissible: true);
// }

// Future<String> inputDialog(String title, String buttonTitle,
//     {String value, int maxLines = 6}) async {
//   hideDialog();
//   TextEditingController controller = TextEditingController(text: value);
//   await Get.dialog(
//     Dialog(
//       backgroundColor: Colors.white,
//       elevation: 8.0,
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(16.0))),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Flexible(
//                     child: Text(
//                       title,
//                       style: Get.theme.textTheme.headline2,
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(
//                       AntDesign.closecircleo,
//                       color: Colors.red,
//                     ),
//                     onPressed: () {
//                       if (value == null || value.isEmpty) {
//                         controller.clear();
//                       } else {
//                         controller.text = value;
//                       }
//                       hideDialog();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 // height: 10,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.all(Radius.circular(8)),
//                     border: Border.all(color: kPrimary)),
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
//                   child: TextFormField(
//                     controller: controller,
//                     decoration: InputDecoration(
//                         border: InputBorder.none,
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             Icons.clear,
//                             size: 16,
//                             color: Colors.grey,
//                           ),
//                           onPressed: () {
//                             controller.clear();
//                           },
//                         )),
//                     style: Get.theme.textTheme.headline4
//                         .copyWith(color: Colors.grey),
//                     keyboardType: TextInputType.multiline,
//                     maxLines: maxLines,
//                     autofocus: true,
//                     onFieldSubmitted: (value) {
//                       controller.text = value;
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 8,
//             ),
//             Container(
//               width: double.infinity,
//               child: FlatButton(
//                 color: kPrimary,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.only(
//                         bottomRight: Radius.circular(16),
//                         bottomLeft: Radius.circular(16))),
//                 onPressed: () {
//                   hideDialog();
//                 },
//                 child: Padding(
//                   padding: EdgeInsets.only(top: 16, bottom: 16),
//                   child: Text(
//                     buttonTitle,
//                     style: Get.theme.textTheme.headline4
//                         .copyWith(color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//     barrierDismissible: true,
//   );
//   return controller.text;
// }
