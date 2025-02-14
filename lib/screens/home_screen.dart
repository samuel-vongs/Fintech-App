import 'package:fintech_app/screens/user_profile.screen.dart';
import 'package:fintech_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'send_money_screen.dart';
import 'transaction_history_screen.dart';
import 'deposit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // For bottom navigation bar

  // Bottom navigation bar items
  static const List<Widget> _widgetOptions = <Widget>[
    HomeContent(), // Main home content
    TransactionHistoryScreen(
        userId: 'currentUserId'), // Replace with dynamic userId
    UserProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<User?>(context);

    return SafeArea(
      child: Scaffold(
        // backgroundColor: const Color.fromARGB(255, 0, 23, 49),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.circleUser),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xff001c39),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  bool isBalanceVisible = true; // To toggle balance visibility
  Map<String, String>? userData;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userDetails = await authService.fetchCredentialsFromFirestore();
    if (userDetails != null) {
      setState(() {
        userData = userDetails;
        profileImageUrl =
            userDetails['profileImage']; // Fetching the profile image URL
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<User?>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: profileImageUrl != null
                        ? NetworkImage(
                            profileImageUrl!) // Displaying the fetched profile image
                        : AssetImage('assets/profile.png') as ImageProvider,
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Text(
                    'Hello,',
                    style: GoogleFonts.roboto().copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff001c39)),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    userData?['userName'] ?? 'Loading...',
                    style: GoogleFonts.roboto().copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff001c39)),
                  ),
                  SizedBox(
                    width: 80,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/notifications');
                    },
                    icon: Icon(
                      Icons.notifications,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                    icon: Icon(
                      Icons.settings,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            // 001c39
            // Wallet Balance
            SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                Image.asset('assets/visa.png'),
                Padding(
                  padding: const EdgeInsets.only(top: 98, left: 200, right: 25),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: Color(0xff001c39),
                        shape: ContinuousRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DepositScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Deposit',
                      style: GoogleFonts.roboto().copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 145, left: 25, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '₦ ',
                              style: GoogleFonts.roboto().copyWith(
                                  fontSize:
                                      35, // Larger font size for the naira symbol
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff001c39)),
                            ),
                            TextSpan(
                              text: isBalanceVisible
                                  ? '100,000.00' // Replace with dynamic balance
                                  : '******',
                              style: GoogleFonts.roboto().copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isBalanceVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            isBalanceVisible = !isBalanceVisible;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Features Grid
            SizedBox(
              height: 20,
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Color(0xff001c39), width: 2),
                iconSize: 30,
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                elevation: 5,
                minimumSize: Size(double.infinity, 50), // Extend horizontally
              ),
              onPressed: () {},
              label: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add a new card',
                    style: GoogleFonts.roboto().copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff001c39)),
                  ),
                  SizedBox(width: 8), // Add space between icon and text
                  Icon(
                    Icons.add,
                    color: Color(0xff001c39),
                  ),
                ],
              ),
              iconAlignment: IconAlignment.end,
            ),
            SizedBox(
              height: 30,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Column(
                    children: [
                      OutlinedButton.icon(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(90, 90),
                          side: BorderSide(color: Colors.orange, width: 2),
                          elevation: 5,
                          padding: EdgeInsets.symmetric(
                            vertical: 20,
                          ),
                          shape: CircleBorder(),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DepositScreen(),
                            ),
                          );
                        },
                        label: Icon(
                          Icons.account_balance_wallet,
                          color: Color(0xff001c39),
                          size: 45,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Deposit',
                        style: GoogleFonts.roboto().copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff001c39),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        softWrap: true,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      OutlinedButton.icon(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(90, 90),
                          side: BorderSide(color: Colors.orange, width: 2),
                          elevation: 5,
                          padding: EdgeInsets.symmetric(
                            vertical: 20,
                          ),
                          shape: CircleBorder(),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SendMoneyScreen(
                                senderId: '',
                              ),
                            ),
                          );
                        },
                        label: Icon(
                          Icons.send,
                          color: Color(0xff001c39),
                          size: 45,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Transfer',
                        style: GoogleFonts.roboto().copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff001c39),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        softWrap: true,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      OutlinedButton.icon(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(90, 90),
                          side: BorderSide(color: Colors.orange, width: 2),
                          elevation: 5,
                          padding: EdgeInsets.symmetric(
                            vertical: 20,
                          ),
                          shape: CircleBorder(),
                        ),
                        onPressed: () {},
                        label: Icon(
                          FontAwesomeIcons.arrowDown,
                          color: Color(0xff001c39),
                          size: 45,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Withdraw',
                        style: GoogleFonts.roboto().copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff001c39),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        softWrap: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Bill Payments',
              style: GoogleFonts.roboto().copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff001c39)),
            ),
            SizedBox(
              height: 16,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Column(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            side: BorderSide(color: Colors.orange),
                            elevation: 5,
                            backgroundColor: Color(0xff001c39),
                            padding: EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                            shape: ContinuousRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)))),
                        onPressed: () {},
                        label: Icon(
                          FontAwesomeIcons.solidLightbulb,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Electricity\nBill',
                        style: GoogleFonts.roboto().copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff001c39),
                            height: 0.9),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            side: BorderSide(color: Colors.orange),
                            elevation: 5,
                            backgroundColor: Color(0xff001c39),
                            padding: EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                            shape: ContinuousRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)))),
                        onPressed: () {},
                        label: Icon(
                          FontAwesomeIcons.wifi,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Internet\nRecharge',
                        style: GoogleFonts.roboto().copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          height: 0.9,
                          color: Color(0xff001c39),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            side: BorderSide(color: Colors.orange),
                            elevation: 5,
                            backgroundColor: Color(0xff001c39),
                            padding: EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                            shape: ContinuousRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)))),
                        onPressed: () {},
                        label: Icon(
                          FontAwesomeIcons.tv,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Cable\nBill',
                        style: GoogleFonts.roboto().copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          height: 0.9,
                          color: Color(0xff001c39),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            side: BorderSide(color: Colors.orange),
                            elevation: 5,
                            backgroundColor: Color(0xff001c39),
                            padding: EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                            shape: ContinuousRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)))),
                        onPressed: () {},
                        label: Icon(
                          FontAwesomeIcons.signal,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Mobile\nRecharge',
                        style: GoogleFonts.roboto().copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          height: 0.9,
                          color: Color(0xff001c39),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            side: BorderSide(color: Colors.orange),
                            elevation: 5,
                            backgroundColor: Color(0xff001c39),
                            padding: EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                            shape: ContinuousRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)))),
                        onPressed: () {},
                        label: Icon(
                          FontAwesomeIcons.list,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'More',
                        style: GoogleFonts.roboto().copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          height: 2.0,
                          color: Color(0xff001c39),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
