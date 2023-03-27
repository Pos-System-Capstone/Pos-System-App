import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/enums/order_enum.dart';
import 'package:pos_apps/view_model/order_view_model.dart';
import 'package:pos_apps/widgets/dialogs/other_dialogs/dialog.dart';
import 'package:pos_apps/widgets/order_process/payment.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../widgets/order_process/cart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModel(
          model: Get.find<OrderViewModel>(),
          child: ScopedModelDescendant<OrderViewModel>(
            builder: (context, child, model) {
              return AddToCartScreen();
            },
          )),
    );
  }
}
