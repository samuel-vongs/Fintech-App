import 'package:fintech_app/services/notifications_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationsController notificationsController =
      Get.put(NotificationsController());

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
        title: Text("Notifications",
            style: GoogleFonts.roboto().copyWith(color: Colors.white)),
        backgroundColor: Color(0xff001c39),
      ),
      body: Obx(() {
        if (notificationsController.notifications.isEmpty) {
          return Center(
              child: Text("No notifications",
                  style: GoogleFonts.roboto()
                      .copyWith(color: Color(0xff001c39), fontSize: 16)));
        }

        return ListView.builder(
          itemCount: notificationsController.notifications.length,
          itemBuilder: (context, index) {
            return Slidable(
              endActionPane: ActionPane(
                motion: ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) =>
                        notificationsController.removeNotification(index),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  notificationsController.notifications[index],
                  style: GoogleFonts.roboto(fontSize: 16),
                ),
                leading: Icon(Icons.notifications, color: Colors.blue),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          notificationsController
              .addNotification("New notification at ${DateTime.now()}");
        },
        backgroundColor: Color(0xff001c39),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
