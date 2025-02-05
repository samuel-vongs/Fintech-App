import 'package:fintech_app/services/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsController settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        title: Text("Settings",
            style: GoogleFonts.roboto().copyWith(color: Colors.white)),
        backgroundColor: Color(0xff001c39),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Obx(() => SwitchListTile(
                title:
                    Text("Dark Mode", style: GoogleFonts.roboto(fontSize: 16)),
                value: settingsController.isDarkMode.value,
                onChanged: (value) => settingsController.toggleDarkMode(value),
              )),
          Obx(() => SwitchListTile(
                title: Text("Enable Notifications",
                    style: GoogleFonts.roboto(fontSize: 16)),
                value: settingsController.isNotificationsEnabled.value,
                onChanged: (value) =>
                    settingsController.toggleNotifications(value),
              )),
          ListTile(
            title: Text("Language", style: GoogleFonts.roboto(fontSize: 16)),
            trailing: Obx(() => DropdownButton<String>(
                  value: settingsController.selectedLanguage.value,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      settingsController.changeLanguage(newValue);
                    }
                  },
                  items: ["English", "French", "Spanish"].map((String lang) {
                    return DropdownMenuItem<String>(
                      value: lang,
                      child: Text(lang),
                    );
                  }).toList(),
                )),
          ),
          Divider(),
          ListTile(
            title:
                Text("Privacy Policy", style: GoogleFonts.roboto(fontSize: 16)),
            trailing: Icon(Icons.privacy_tip),
            onTap: () => settingsController.openPrivacyPolicy(),
          ),
          ListTile(
            title: Text("Terms & Conditions",
                style: GoogleFonts.roboto(fontSize: 16)),
            trailing: Icon(Icons.description),
            onTap: () => settingsController.openTermsConditions(),
          ),
          ListTile(
            title: Text("About App", style: GoogleFonts.roboto(fontSize: 16)),
            subtitle:
                Text("Version 1.0.0", style: GoogleFonts.roboto(fontSize: 14)),
            trailing: Icon(Icons.info_outline),
          ),
          Divider(),
        ],
      ),
    );
  }
}
