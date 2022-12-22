import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/routes/routes_constrants.dart';
import 'package:pos_apps/Widgets/AppBar/default_appbar.dart';
import 'package:pos_apps/Widgets/footer.dart';
import 'package:pos_apps/Widgets/header.dart';

class LoginByPos extends StatefulWidget {
  const LoginByPos({super.key});

  @override
  State<LoginByPos> createState() => _LoginByPosState();
}

class _LoginByPosState extends State<LoginByPos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header(),
          Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              width: MediaQuery.of(context).size.width * 0.38,
              height: MediaQuery.of(context).size.width * 0.25,
              child: Padding(
                // padding: const EdgeInsets.all(30.0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TITLE OF FORM
                    const Text(
                      "Đăng Nhập",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),

                    //USERNAME TO LOGIN
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Tài khoản",
                              style: TextStyle(color: Colors.grey[600])),
                          const TextField(
                              decoration: InputDecoration(
                                  hintText: "user1",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        ],
                      ),
                    ),

                    // PASSWORD TO LOGIN
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Mật khẩu",
                              style: TextStyle(color: Colors.grey[600])),
                          const TextField(
                              decoration: InputDecoration(
                                  hintText: "*****",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0)))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.005,
                    ),

                    // LOGIN BUTTON
                    SizedBox(
                      height: MediaQuery.of(context).size.width *
                          0.04, //height of button
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () =>
                              {Get.offAndToNamed(RouteHandler.HOME)},
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              // minimumSize: const Size.fromHeight(60),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)))),
                          child: Text(
                            "ĐĂNG NHẬP",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Footer()
        ],
      ),
    );
  }
}
