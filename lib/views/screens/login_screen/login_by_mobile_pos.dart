import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos_apps/view_model/login_view_model.dart';
import '../../../data/api/index.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  // late LogInController controller;
  late OutlineInputBorder outlineInputBorder;
  late FocusNode _userNameFocus;
  final _formKey = GlobalKey<FormState>();
  AccountData accountDao = AccountData();
  LoginViewModel model = LoginViewModel();
  String error = "";
  String userName = "deerstaff";
  String password = "123456";
  bool _passwordVisible = false;
  final _formUserNameFieldController = TextEditingController();
  final _formPasswordFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userNameFocus = FocusNode();
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
    if (context.isPortrait) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/cash-register.png",
                      width: Get.size.width * 0.4,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Đăng nhập POS',
                      style: Get.textTheme.titleLarge,
                    ),
                    SizedBox(height: 8),

                    //LOGIN FORM
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // USERNAME FORM FIELD
                          TextFormField(
                            controller: _formUserNameFieldController,
                            style: Get.textTheme.labelMedium,
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
                                        color: Get
                                            .theme.colorScheme.primaryContainer,
                                        width: 2.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Get
                                            .theme.colorScheme.primaryContainer,
                                        width: 2.0)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Get
                                            .theme.colorScheme.primaryContainer,
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

                          SizedBox(height: 8),

                          //PASSWORD FORM FIELD
                          TextFormField(
                            controller: _formPasswordFieldController,
                            obscureText: !_passwordVisible,
                            obscuringCharacter: "*",
                            style: Get.textTheme.bodyMedium,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Password must not be empty!";
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
                                        color: Get
                                            .theme.colorScheme.primaryContainer,
                                        width: 2.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Get
                                            .theme.colorScheme.primaryContainer,
                                        width: 2.0)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Get
                                            .theme.colorScheme.primaryContainer,
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
                    SizedBox(
                      width: Get.width,
                      height: 48,
                      child: FilledButton.tonal(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            model.posLogin(userName, password);
                          }
                        },
                        child:
                            Text("Đăng nhập", style: Get.textTheme.titleMedium),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: Get.size.width * 0.25,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Đăng nhập POS',
                        style: Get.textTheme.displaySmall,
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
                              style: Get.textTheme.bodyMedium,
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
                                  hintText: "Tên đăng nhập",
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
                                  hintText: "Mật khẩu",
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
                      SizedBox(
                        width: Get.width,
                        height: 48,
                        child: FilledButton.tonal(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              model.posLogin(userName, password);
                            }
                          },
                          child: Text("Đăng nhập",
                              style: Get.textTheme.titleMedium),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                Image.asset(
                  "assets/images/cash-register.png",
                  width: Get.size.width * 0.3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
