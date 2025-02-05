import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsController extends GetxController {
  var notifications = <String>[].obs;

  @override
  void onInit() {
    loadNotifications();
    super.onInit();
  }

  Future<void> loadNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notifications.value = prefs.getStringList("notifications") ?? [];
  }

  Future<void> addNotification(String message) async {
    notifications.insert(0, message);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("notifications", notifications);
  }

  Future<void> removeNotification(int index) async {
    notifications.removeAt(index);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("notifications", notifications);
  }
}
