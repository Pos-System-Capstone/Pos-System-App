import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/routes/routes_constrants.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  // late LogInController controller;
  late OutlineInputBorder outlineInputBorder;
  GlobalKey<FormState> _formKey = new GlobalKey();
  late FocusNode _userNameFocus;
  late FocusNode _passwordFocus;

  @override
  void initState() {
    super.initState();
    // theme = AppTheme.theme;
    // mTheme = MaterialTheme.learningTheme;
    // controller = FxControllerStore.putOrFind(LogInController());
    _userNameFocus = FocusNode();
    _passwordFocus = FocusNode();
    outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width * 0.2,
            MediaQuery.of(context).size.height * 0.2,
            MediaQuery.of(context).size.width * 0.2,
            0),
        padding: EdgeInsets.fromLTRB(16, 36, 16, 16),
        child: ListView(
          children: [
            Text(
              'Hello Again! \nWelcome back',
              style: Get.textTheme.headline4,
            ),
            SizedBox(height: 32),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    style: Get.textTheme.button,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        isDense: true,
                        labelStyle: Get.textTheme.labelLarge,
                        fillColor: Get.theme.colorScheme.primaryContainer,
                        prefixIcon: Icon(
                          Icons.mail_outline,
                          color: Get.theme.colorScheme.onBackground,
                        ),
                        hintText: "UserName",
                        enabledBorder: outlineInputBorder,
                        focusedBorder: outlineInputBorder,
                        border: outlineInputBorder,
                        contentPadding: EdgeInsets.all(16),
                        hintStyle: Get.textTheme.bodyText2,
                        isCollapsed: true),
                    maxLines: 1,
                    cursorColor: Get.theme.colorScheme.onPrimaryContainer,
                    focusNode: _userNameFocus,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    style: Get.textTheme.bodyText2,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        isDense: true,
                        fillColor: Get.theme.colorScheme.primaryContainer,
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Get.theme.colorScheme.onBackground,
                        ),
                        hintText: "Password",
                        enabledBorder: outlineInputBorder,
                        focusedBorder: outlineInputBorder,
                        border: outlineInputBorder,
                        contentPadding: EdgeInsets.all(16),
                        hintStyle: Get.textTheme.bodyText2,
                        isCollapsed: true),
                    maxLines: 1,
                    cursorColor: Get.theme.colorScheme.onBackground,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: () {},
            //   child: Text("Login", style: Get.textTheme.button),
            //   style: ButtonStyle(backgroundColor: Get.theme.colorScheme.primar),
            // ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                // Foreground color
                // ignore: deprecated_member_use
                onPrimary: Theme.of(context).colorScheme.onPrimary,
                // Background color
                // ignore: deprecated_member_use
                primary: Theme.of(context).colorScheme.primary,
              ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
              onPressed: () {
                Get.offAndToNamed(RouteHandler.NAV);
              },
              child: Text("Login",
                  style: Get.textTheme.button
                      ?.copyWith(color: Get.theme.colorScheme.background)),
            ),
            // FxButton.block(
            //   elevation: 0,
            //   borderRadiusAll: mTheme.buttonRadius.large,
            //   onPressed: () {
            //     controller.login();
            //   },
            //   splashColor: mTheme.onPrimary.withAlpha(30),
            //   backgroundColor: mTheme.primary,
            //   child: FxText.l1(
            //     "Sign In",
            //     color: mTheme.onPrimary,
            //   ),
            // ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {},
                    child: Text("Forgot Password ?",
                        style: Get.textTheme.bodyText2?.copyWith(
                            decoration: TextDecoration.underline,
                            color: Get.theme.primaryColor))),
                // FxButton.text(
                //   onPressed: () {
                //     controller.goToForgotPasswordScreen();
                //   },
                //   padding: FxSpacing.zero,
                //   splashColor: mTheme.primary.withAlpha(40),
                //   child: FxText.b3("Forgot your Password ?",
                //       color: mTheme.primary,
                //       decoration: TextDecoration.underline),
                // ),
                TextButton(
                    onPressed: () {},
                    child: Text("Sign up",
                        style: Get.textTheme.bodyText2?.copyWith(
                            decoration: TextDecoration.underline,
                            color: Get.theme.primaryColor))),
                // FxButton.text(
                //   onPressed: () {
                //     controller.goToRegisterScreen();
                //   },
                //   padding: FxSpacing.zero,
                //   splashColor: mTheme.primary.withAlpha(40),
                //   child: FxText.b3(
                //     "Sign up",
                //     color: mTheme.primary,
                //     decoration: TextDecoration.underline,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
