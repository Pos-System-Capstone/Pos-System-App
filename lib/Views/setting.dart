import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool isNotificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('darkMode') ?? false;
      isNotificationsEnabled = prefs.getBool('notifications') ?? true;
    });
  }

  saveSettings(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('General'),
            tiles: [
              SettingsTile.switchTile(
                title: Text('Dark Mode'),
                leading: Icon(Icons.dark_mode),
                onToggle: (bool value) {
                  setState(() {
                    isDarkMode = value;
                  });
                  saveSettings('darkMode', value);
                },
                initialValue: null,
              ),
              SettingsTile.switchTile(
                title: Text('Notifications'),
                leading: Icon(Icons.notifications),
                onToggle: (bool value) {
                  setState(() {
                    isNotificationsEnabled = value;
                  });
                  saveSettings('notifications', value);
                },
                initialValue: null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
