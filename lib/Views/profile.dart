import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Cover image
          Container(
            height: 200.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/cover.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Profile image and name
          Positioned(
            top: 40.0,
            left: 20.0,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40.0,
                  backgroundImage: AssetImage('assets/profile.jpg'),
                ),
                SizedBox(width: 10.0),
                Text(
                  'John Doe',
                  style: TextStyle(fontSize: 24.0),
                ),
              ],
            ),
          ),
          // Other widgets
        ],
      ),
    );
  }
}
