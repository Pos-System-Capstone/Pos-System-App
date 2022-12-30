import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
