import 'package:fintech_app/firebase_options.dart';
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
import 'package:fintech_app/screens/user_profile.screen.dart';
import 'package:fintech_app/services/auth_service.dart';
import 'package:fintech_app/services/payment_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        '/user-profile': (context) => UserProfileScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/settings': (context) => SettingsScreen(),
        '/notifications': (context) => NotificationScreen(),
      },
    );
  }
}
