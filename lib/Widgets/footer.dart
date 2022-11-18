import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 166, 206, 57),
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Phiên bản: 0.0.1",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Icon(Icons.wifi),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(DateFormat.jm().format(DateTime.now()).toString(),
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      Text(DateFormat.yMd().format(DateTime.now()).toString(),
                          style: TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  )
                ],
              ),
            ],
          )),
    );
  }
}
