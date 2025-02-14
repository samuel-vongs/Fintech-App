import 'package:fintech_app/screens/user_profile.screen.dart';
import 'package:fintech_app/services/auth_service.dart';
import 'package:fintech_app/spirit-nerds/prayer_charge.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../screens/transaction_history_screen.dart';

class SpiritNerdsScreen extends StatefulWidget {
  const SpiritNerdsScreen({super.key});

  @override
  _SpiritNerdsScreenState createState() => _SpiritNerdsScreenState();
}

class _SpiritNerdsScreenState extends State<SpiritNerdsScreen> {
  int _selectedIndex = 0; // For bottom navigation bar

  // Bottom navigation bar items
  static const List<Widget> _widgetOptions = <Widget>[
    HomeContent(), // Main home content
    TransactionHistoryScreen(
        userId: 'currentUserId'), // Replace with dynamic userId
    UserProfileScreen(),
    PrayerCharge(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Map<String, String>? userData;

  Future<void> fetchUserData() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userDetails = await authService.fetchCredentialsFromFirestore();
    if (userDetails != null) {
      setState(() {
        userData = userDetails;
      });
    }
  }

  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    Provider.of<User?>(context);

    return SafeArea(
      child: AdvancedDrawer(
        drawer: Drawer(),
        controller: _advancedDrawerController,
        backdropColor: Colors.black,
        child: Scaffold(
          drawer: Drawer(),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 80,
            flexibleSpace: Container(
              height: 80,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/header.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      drawerControl();
                    },
                    icon: Icon(
                      Icons.menu,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Hi,',
                            style: GoogleFonts.roboto().copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            userData?['userName'] ?? 'Sammy',
                            style: GoogleFonts.roboto().copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '!',
                            style: GoogleFonts.roboto().copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Good morning',
                        style: GoogleFonts.roboto().copyWith(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.message,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_none,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.black,
          body: _widgetOptions.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.grey,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.surround_sound),
                label: 'Sounds',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.music),
                label: 'Music',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.power),
                label: 'Prayer chants',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.deepOrange,
            unselectedItemColor: Colors.white,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  void drawerControl() {
    _advancedDrawerController.showDrawer();
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        resetInputs();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void resetInputs() {
    setState(() {});
  }

  List<Map<String, String>> sermons = [
    {
      'title': 'Separated Unto God - 2024',
      'preacher': 'Apostle Arome Osayi',
      'likes': '4',
      'plays': '1',
      'downloads': '2',
    },
    {
      'title': 'Exploring God',
      'preacher': 'Apostle Arome Osayi',
      'likes': '6',
      'plays': '1',
      'downloads': '7',
    },
    {
      'title': 'Ways of Altars',
      'preacher': 'Apostle Arome Osayi',
      'likes': '7',
      'plays': '1',
      'downloads': '3',
    },
    {
      'title': 'Exploring God',
      'preacher': 'Apostle Arome Osayi',
      'likes': '6',
      'plays': '1',
      'downloads': '7',
    },
    {
      'title': 'Ways of Altars',
      'preacher': 'Apostle Arome Osayi',
      'likes': '7',
      'plays': '1',
      'downloads': '3',
    },
    {
      'title': 'Exploring God',
      'preacher': 'Apostle Arome Osayi',
      'likes': '6',
      'plays': '1',
      'downloads': '7',
    },
    {
      'title': 'Ways of Altars',
      'preacher': 'Apostle Arome Osayi',
      'likes': '7',
      'plays': '1',
      'downloads': '3',
    },
    {
      'title': 'Exploring God',
      'preacher': 'Apostle Arome Osayi',
      'likes': '6',
      'plays': '1',
      'downloads': '7',
    },
    {
      'title': 'Ways of Altars',
      'preacher': 'Apostle Arome Osayi',
      'likes': '7',
      'plays': '1',
      'downloads': '3',
    },
    {
      'title': 'Exploring God',
      'preacher': 'Apostle Arome Osayi',
      'likes': '6',
      'plays': '1',
      'downloads': '7',
    },
    {
      'title': 'Ways of Altars',
      'preacher': 'Apostle Arome Osayi',
      'likes': '7',
      'plays': '1',
      'downloads': '3',
    },
    // Add more sermons here...
  ];

  List<Map<String, String>> preachers = [
    {
      'preacher': 'Apostle Arome Osayi',
      'number': '908',
    },
    {
      'preacher': 'Apostle Benjamin Borno',
      'number': '708',
    },
    {
      'preacher': 'Apostle Gideon Odoma',
      'number': '890',
    },
  ];

  @override
  Widget build(BuildContext context) {
    Provider.of<User?>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick links',
              style: GoogleFonts.roboto().copyWith(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(50, 40),
                      backgroundColor: Colors.grey.shade900,
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                    ),
                    onPressed: () {},
                    label: Text(
                      'Recent Downloads',
                      style: GoogleFonts.roboto().copyWith(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: Icon(
                      Icons.download_rounded,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(50, 40),
                      backgroundColor: Colors.grey.shade900,
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                    ),
                    onPressed: () {},
                    label: Text(
                      'Upload Sermons',
                      style: GoogleFonts.roboto().copyWith(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: Icon(
                      Icons.upload_rounded,
                      color: Colors.yellowAccent,
                    ),
                  ),
                ],
              ),
            ),
            DefaultTabController(
              length: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabBar(
                    labelPadding: EdgeInsets.symmetric(horizontal: 10),
                    tabAlignment: TabAlignment.center,
                    dividerColor: Colors.transparent,
                    labelStyle: GoogleFonts.roboto().copyWith(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    physics: BouncingScrollPhysics(),
                    controller: _tabController,
                    indicatorColor: Colors.deepOrange,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey.shade500,
                    tabs: [
                      Tab(
                        text: 'New Sermons',
                      ),
                      Tab(
                        text: 'Favourite Preachers',
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 1.3,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: sermons.length,
                          itemBuilder: (context, index) {
                            return buildNewSermons(
                              sermons[index]['title'] ?? '',
                              sermons[index]['preacher'] ?? '',
                              sermons[index]['likes'] ?? '',
                              sermons[index]['plays'] ?? '',
                              sermons[index]['downloads'] ?? '',
                              Icons.play_circle_fill,
                              Icons.favorite,
                              Icons.download_rounded,
                              Icons.play_arrow,
                              Icons.more_vert,
                            );
                          },
                        ),
                        Column(
                          children: [
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: preachers.length,
                              itemBuilder: (context, index) {
                                return buildFavouritePreachers(
                                  preachers[index]['preacher'] ?? '',
                                  preachers[index]['number'] ?? '',
                                  ' Sermons',
                                  '  |  ',
                                  Icons.play_circle_fill,
                                );
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton.icon(
                              iconAlignment: IconAlignment.end,
                              onPressed: () {},
                              label: Text(
                                'Add More Preachers',
                                style: GoogleFonts.roboto().copyWith(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              icon: Icon(
                                FontAwesomeIcons.plus,
                                color: Colors.white,
                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 50),
                                backgroundColor: Colors.deepOrange,
                                shape: ContinuousRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNewSermons(
    String label,
    String label2,
    String label3,
    String label4,
    String label5,
    IconData icon,
    IconData icon2,
    IconData icon3,
    IconData icon4,
    IconData icon5,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Card(
            clipBehavior: Clip.hardEdge,
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/header.jpg'),
                      fit: BoxFit.cover)),
            ),
          ),
          SizedBox(
            width: 3,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: GoogleFonts.roboto().copyWith(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  label2,
                  style: GoogleFonts.roboto().copyWith(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Row(
                  children: [
                    Icon(
                      icon2,
                      size: 16,
                      color: Colors.grey.shade500,
                    ),
                    Text(
                      label3,
                      style: GoogleFonts.roboto().copyWith(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Icon(
                      icon3,
                      size: 16,
                      color: Colors.grey.shade500,
                    ),
                    Text(
                      label4,
                      style: GoogleFonts.roboto().copyWith(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Icon(
                      icon4,
                      size: 16,
                      color: Colors.grey.shade500,
                    ),
                    Text(
                      label5,
                      style: GoogleFonts.roboto().copyWith(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              icon,
              size: 35,
              color: Colors.deepOrange,
            ),
          ),
          Icon(
            icon5,
            size: 30,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget buildFavouritePreachers(
    String label,
    String label2,
    String label3,
    String label4,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/header.jpg',
                  fit: BoxFit.cover,
                  height: 70,
                  width: 70,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.roboto().copyWith(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          label2,
                          style: GoogleFonts.roboto().copyWith(
                            fontSize: 10,
                            color: Colors.deepOrange,
                          ),
                        ),
                        Text(
                          label3,
                          style: GoogleFonts.roboto().copyWith(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  icon,
                  size: 35,
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
