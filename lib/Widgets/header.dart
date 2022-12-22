import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      color: Theme.of(context).primaryColor,
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: WindowTitleBarBox(
            child: Row(
              children: [
                Expanded(
                    child: MoveWindow(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/images/white-icon-passio.png",
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 100),
                        child: Image.asset(
                          "assets/images/white-logo.png",
                          fit: BoxFit.fitWidth,
                          width: 200,
                        ),
                      ),
                      WindowButtons(),
                    ],
                  ),
                )),
              ],
            ),
          )),
    );
  }
}

final buttonColors = WindowButtonColors(
    iconNormal: const Color(0xFF000000),
    mouseOver: const Color(0xFFA6CE39),
    mouseDown: const Color(0xFFA6CE39),
    iconMouseOver: const Color(0xFF6D7175),
    iconMouseDown: const Color(0xFF6D7175));

final closeButtonColors = WindowButtonColors(
    mouseOver: const Color(0xFFD32F2F),
    mouseDown: const Color(0xFFB71C1C),
    iconNormal: const Color(0xFF000000),
    iconMouseOver: Colors.white);

class WindowButtons extends StatefulWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  _WindowButtonsState createState() => _WindowButtonsState();
}

class _WindowButtonsState extends State<WindowButtons> {
  void maximizeOrRestore() {
    setState(() {
      appWindow.maximizeOrRestore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        appWindow.isMaximized
            ? RestoreWindowButton(
                colors: buttonColors,
                onPressed: maximizeOrRestore,
              )
            : MaximizeWindowButton(
                colors: buttonColors,
                onPressed: maximizeOrRestore,
              ),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
