import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../view_model/index.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModel<StartUpViewModel>(
      model: StartUpViewModel(),
      child: ScopedModelDescendant<StartUpViewModel>(
          builder: (context, child, model) {
        return Scaffold(
          body: Center(
            child: Image.asset(
              "assets/images/logo.png",
              width: Get.size.width * 0.2,
            ),
          ),
        );
      }),
    );
  }
}
