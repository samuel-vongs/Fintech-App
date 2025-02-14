import 'package:flutter/material.dart';

class PrayerCharge extends StatefulWidget {
  const PrayerCharge({super.key});

  @override
  _PrayerChargeState createState() => _PrayerChargeState();
}

class _PrayerChargeState extends State<PrayerCharge> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('Prayer Charge')],
      ),
    );
  }
}
