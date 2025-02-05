import 'package:fintech_app/screens/airtime_data_screen.dart';
import 'package:fintech_app/screens/deposit_screen.dart';
import 'package:fintech_app/screens/forgot_password_screen.dart';
import 'package:fintech_app/screens/home_screen.dart';
import 'package:fintech_app/screens/login_screen.dart';
import 'package:fintech_app/screens/notifications_screen.dart';
import 'package:fintech_app/screens/receive_money_screen.dart';
import 'package:fintech_app/screens/save_money_screen.dart';
import 'package:fintech_app/screens/settings_screen.dart';
import 'package:fintech_app/screens/sign_up_screen.dart';
import 'package:fintech_app/screens/splash_screen.dart';
import 'package:fintech_app/services/auth_service.dart';
import 'package:fintech_app/services/payment_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider(create: (_) => PaymentService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fintech App',
      theme: ThemeData(
        primarySwatch: MaterialColor(
          0xff001c39,
          {
            50: Color(0xffe0e0e0),
            100: Color(0xffb3b3b3),
            200: Color(0xff808080),
            300: Color(0xff4d4d4d),
            400: Color(0xff262626),
            500: Color(0xff001c39),
            600: Color(0xff001c39),
            700: Color(0xff001c39),
            800: Color(0xff001c39),
            900: Color(0xff001c39),
          },
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/welcome': (context) => WelcomePage(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomeScreen(),
        '/deposit': (context) => DepositScreen(),
        '/receive': (context) => ReceiveMoneyScreen(),
        '/save': (context) => SaveMoneyScreen(),
        '/airtime': (context) => AirtimeDataScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/settings': (context) => SettingsScreen(),
        '/notifications': (context) => NotificationScreen(),
      },
    );
  }
}
