import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos_apps/model/dao/account_dao.dart';
import 'package:pos_apps/model/dto/account_dto.dart';
import 'package:pos_apps/util/share_pref.dart';
import 'package:pos_apps/view_model/login_view_model.dart';

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
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
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
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
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
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            filled: true,
                            isDense: true,
                            labelStyle: Get.textTheme.labelLarge,
                            fillColor: Get.theme.colorScheme.primaryContainer,
                            prefixIcon: Icon(
                              Icons.portrait_rounded,
                              color: Get.theme.colorScheme.onBackground,
                            ),
                            hintText: "Username",
                            hintStyle: Get.textTheme.bodyMedium,
                            enabledBorder: outlineInputBorder,
                            focusedBorder: outlineInputBorder,
                            border: outlineInputBorder,
                            contentPadding: EdgeInsets.all(16),
                            isCollapsed: true),
                        maxLines: 1,
                        cursorColor: Get.theme.colorScheme.onPrimaryContainer,
                        focusNode: _userNameFocus,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        obscureText: true,
                        obscuringCharacter: "*",
                        style: Get.textTheme.bodyMedium,
                        decoration: InputDecoration(
                            hintText: "Password",
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            filled: true,
                            isDense: true,
                            fillColor: Get.theme.colorScheme.primaryContainer,
                            prefixIcon: Icon(
                              Icons.key,
                              color: Get.theme.colorScheme.onBackground,
                            ),
                            enabledBorder: outlineInputBorder,
                            focusedBorder: outlineInputBorder,
                            border: outlineInputBorder,
                            contentPadding: EdgeInsets.all(16),
                            hintStyle: Get.textTheme.bodyMedium,
                            isCollapsed: true),
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
                      style: Get.textTheme.button
                          ?.copyWith(color: Get.theme.colorScheme.background)),
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
          )
        ],
      ),
    );
  }

  login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        error = "";
      });

      AccountDTO? userData = await model.posLogin(userName, password);
      if (userData != null) {
        Get.toNamed("/home");
        final userInfo = await getUserInfo();
        debugPrint("userInfo get tu sharepreference: ${userInfo}");
      }
    }
  }
}