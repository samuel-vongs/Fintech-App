import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsController extends GetxController {
  var isDarkMode = false.obs;
  var isNotificationsEnabled = true.obs;
  var selectedLanguage = "English".obs;
  var themeMode = "System Default".obs;

  @override
  void onInit() {
    loadSettings();
    super.onInit();
  }

  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool("darkMode") ?? false;
    isNotificationsEnabled.value = prefs.getBool("notifications") ?? true;
    selectedLanguage.value = prefs.getString("language") ?? "English";
    themeMode.value = prefs.getString("themeMode") ?? "System Default";
  }

  Future<void> toggleDarkMode(bool value) async {
    isDarkMode.value = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("darkMode", value);
  }

  Future<void> toggleNotifications(bool value) async {
    isNotificationsEnabled.value = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("notifications", value);
  }

  Future<void> changeLanguage(String language) async {
    selectedLanguage.value = language;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("language", language);
  }

  Future<void> changeTheme(String theme) async {
    themeMode.value = theme;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("themeMode", theme);
  }

  Future<void> openPrivacyPolicy() async {
    const url = "https://yourwebsite.com/privacy-policy";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      Get.snackbar("Error", "Could not open Privacy Policy");
    }
  }

  Future<void> openTermsConditions() async {
    const url = "https://yourwebsite.com/terms";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      Get.snackbar("Error", "Could not open Terms & Conditions");
    }
  }

  Future<void> resetAppData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    loadSettings(); // Reload settings after reset
    Get.snackbar("Reset", "App data has been cleared");
  }
}
