import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos_apps/model/dao/account_dao.dart';
import 'package:pos_apps/model/dto/account_dto.dart';
import 'package:pos_apps/routes/routes_constrants.dart';
import 'package:pos_apps/util/share_pref.dart';
import 'package:pos_apps/view_model/login_view_model.dart';
import 'package:pos_apps/widgets/header_footer/header.dart';
import 'dart:io' show Platform;

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  // late LogInController controller;
  late OutlineInputBorder outlineInputBorder;
  late FocusNode _userNameFocus;
  late FocusNode _passwordFocus;

  final _formKey = GlobalKey<FormState>();
  AccountDAO accountDao = AccountDAO();
  LoginViewModel model = LoginViewModel();
  String error = "";
  String userName = "";
  String password = "";
  bool _passwordVisible = false;
  final _formUserNameFieldController = TextEditingController();
  final _formPasswordFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // theme = AppTheme.theme;
    // mTheme = MaterialTheme.learningTheme;
    // controller = FxControllerStore.putOrFind(LogInController());
    _userNameFocus = FocusNode();
    _passwordFocus = FocusNode();
    _passwordVisible = false;

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
      body: Column(
        children: [
          Platform.isWindows ? Header() : SizedBox(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Login to \nRESO POS',
                        style: Get.textTheme.displayLarge,
                      ),
                      SizedBox(height: 32),

                      //LOGIN FORM
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // USERNAME FORM FIELD
                            TextFormField(
                              controller: _formUserNameFieldController,
                              style: Get.textTheme.button,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(" "),
                              ],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Username must not be empty!";
                                } else if (value.length > 50) {
                                  return "Username's max length is 50";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) => {
                                setState(
                                  () => userName = value,
                                )
                              },
                              decoration: InputDecoration(
                                  hintText: "Username",
                                  hintStyle: Get.textTheme.bodyMedium,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  filled: true,
                                  isDense: true,
                                  labelStyle: Get.textTheme.labelLarge,
                                  fillColor: Get.theme.colorScheme.background,
                                  prefixIcon: Icon(
                                    Icons.portrait_rounded,
                                    color: Get.theme.colorScheme.onBackground,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      _formUserNameFieldController.text = "";
                                    },
                                    icon: Icon(Icons.clear),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: Get.theme.colorScheme
                                              .primaryContainer,
                                          width: 2.0)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: Get.theme.colorScheme
                                              .primaryContainer,
                                          width: 2.0)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: Get.theme.colorScheme
                                              .primaryContainer,
                                          width: 2.0)),
                                  contentPadding: EdgeInsets.all(16),
                                  isCollapsed: true,
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: Get.theme.colorScheme.error,
                                          width: 2.0))),
                              maxLines: 1,
                              focusNode: _userNameFocus,
                            ),

                            SizedBox(height: 16),

                            //PASSWORD FORM FIELD
                            TextFormField(
                              controller: _formPasswordFieldController,
                              obscureText: !_passwordVisible,
                              obscuringCharacter: "*",
                              style: Get.textTheme.bodyMedium,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Password must not be empty!";
                                } else if (value.length < 6) {
                                  return "Password must be at least 6 characters";
                                } else if (value.length > 50) {
                                  return "Password's max length is 50 characters";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: ((value) => setState(() {
                                    password = value;
                                  })),
                              decoration: InputDecoration(
                                  hintText: "Password",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  filled: true,
                                  isDense: true,
                                  fillColor: Get.theme.colorScheme.background,
                                  prefixIcon: Icon(
                                    Icons.key,
                                    color: Get.theme.colorScheme.onBackground,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  )
                                  // IconButton(
                                  //   onPressed:
                                  //       _formPasswordFieldController.clear,
                                  //   icon: Icon(Icons.clear),
                                  // )
                                  ,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: Get.theme.colorScheme
                                              .primaryContainer,
                                          width: 2.0)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: Get.theme.colorScheme
                                              .primaryContainer,
                                          width: 2.0)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: Get.theme.colorScheme
                                              .primaryContainer,
                                          width: 2.0)),
                                  contentPadding: EdgeInsets.all(16),
                                  hintStyle: Get.textTheme.bodyMedium,
                                  isCollapsed: true,
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: Get.theme.colorScheme.error,
                                          width: 2.0))),
                              maxLines: 1,
                              cursorColor: Get.theme.colorScheme.onBackground,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // Foreground color
                          // ignore: deprecated_member_use
                          minimumSize: const Size.fromHeight(45),
                          onPrimary: Theme.of(context).colorScheme.onPrimary,
                          // Background color
                          // ignore: deprecated_member_use
                          // primary: Theme.of(context).colorScheme.primary,
                          primary: Theme.of(context).colorScheme.primary,
                        ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                        onPressed: () {
                          login();
                        },
                        child: Text("Login",
                            style: Get.textTheme.button?.copyWith(
                                color: Get.theme.colorScheme.background)),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {},
                              child: Text("Forgot Password ?",
                                  style: Get.textTheme.bodyText2?.copyWith(
                                      decoration: TextDecoration.none,
                                      color: Get.theme.primaryColor))),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                Image.asset(
                  "assets/images/cash-register.png",
                  width: 350,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  login() async {
    if (_formKey.currentState!.validate()) {
      AccountDTO? userData = await model.posLogin(userName, password);
      if (userData != null) {
        Get.toNamed(RouteHandler.HOME);
        final userInfo = await getUserInfo();
        debugPrint("userInfo get tu sharepreference: ${userInfo}");
      }
    }
  }
}
