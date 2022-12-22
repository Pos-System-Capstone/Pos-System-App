import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_onboard/flutter_onboard.dart';

import '../routes/routes_constrants.dart';
import '../util/share_pref.dart';

class OnBoardScreen extends StatefulWidget {
  OnBoardScreen({Key? key}) : super(key: key);

  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

final List<OnBoardModel> onBoardData = [
  const OnBoardModel(
    title: "Set your own goals and get better",
    description: "Goal support your motivation and inspire you to work harder",
    imgUrl: "assets/images/weight.png",
  ),
  const OnBoardModel(
    title: "Track your progress with statistics",
    description:
        "Analyse personal result with detailed chart and numerical values",
    imgUrl: 'assets/images/graph.png',
  ),
  const OnBoardModel(
    title: "Create photo comparisons and share your results",
    description:
        "Take before and after photos to visualize progress and get the shape that you dream about",
    imgUrl: 'assets/images/phone.png',
  ),
];

class _OnBoardScreenState extends State<OnBoardScreen> {
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: OnBoard(
            onBoardData: onBoardData,
            pageController: _pageController,
            // Either Provide onSkip Callback or skipButton Widget to handle skip state
            onSkip: () {
              _onIntroEnd();
            },
            // Either Provide onDone Callback or nextButton Widget to handle done state
            onDone: () {
              _onIntroEnd();
            },
          )),
    );
  }

  void _onIntroEnd() async {
    // set pref that first onboard is false
    // AccountDAO _accountDAO = AccountDAO();
    // var hasLoggedInUser = await _accountDAO.isUserLoggedIn();
    await setIsFirstOnboard(false);
    if (true) {
      // await Get.find<RootViewModel>().startUp();
      Get.offAndToNamed(RouteHandler.HOME);
    } else {
      Get.offAndToNamed(RouteHandler.LOGIN);
    }
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/images/$assetName', width: 350.0),
      alignment: Alignment.bottomCenter,
    );
  }
}
