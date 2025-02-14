// import 'package:flutter/material.dart';

// class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController otpController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   late TabController _tabController;

//   bool isCodeSent = false;
//   bool isOtpComplete = false;
//   bool isEmailLoginComplete = false;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.addListener(() {
//       if (_tabController.indexIsChanging) {
//         resetInputs();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     phoneController.dispose();
//     otpController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   void resetInputs() {
//     setState(() {
//       phoneController.clear();
//       otpController.clear();
//       emailController.clear();
//       passwordController.clear();
//       isCodeSent = false;
//       isOtpComplete = false;
//       isEmailLoginComplete = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 // Header with logo
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     children: [
//                       Align(
//                         alignment: Alignment.topLeft,
//                         child: IconButton(
//                           icon: Icon(Icons.close, size: 28, color: Colors.black),
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => WelcomePage()),
//                             );
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       Image.asset(
//                         'assets/logo.png', // Replace with your logo path
//                         height: 60,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 // Tabs (Phone Number / Email)
//                 DefaultTabController(
//                   length: 2,
//                   child: Column(
//                     children: [
//                       TabBar(
//                         controller: _tabController,
//                         indicatorColor: Colors.red,
//                         labelColor: Colors.red,
//                         unselectedLabelColor: Colors.black,
//                         tabs: [
//                           Tab(
//                             text: 'Phone No.',
//                             icon: Icon(Icons.phone_android),
//                           ),
//                           Tab(
//                             text: 'Email',
//                             icon: Icon(Icons.email),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 20),
//                       SizedBox(
//                         height: MediaQuery.of(context).size.height *
//                             0.3, // Reduced height
//                         child: TabBarView(
//                           controller: _tabController,
//                           children: [
//                             // Phone Number Tab
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 16.0, vertical: 10),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   TextField(
//                                     controller: phoneController,
//                                     keyboardType: TextInputType.phone,
//                                     decoration: InputDecoration(
//                                       labelText: 'Phone Number',
//                                       prefixIcon:
//                                           Icon(Icons.phone, color: Colors.red),
//                                       border: OutlineInputBorder(),
//                                     ),
//                                   ),
//                                   SizedBox(height: 16),
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                         child: TextField(
//                                           controller: otpController,
//                                           keyboardType: TextInputType.number,
//                                           onChanged: (value) => setState(() {
//                                             isOtpComplete =
//                                                 otpController.text.length == 6;
//                                           }),
//                                           decoration: InputDecoration(
//                                             labelText: 'Enter Code',
//                                             prefixIcon: Icon(Icons.lock,
//                                                 color: Colors.red),
//                                             border: OutlineInputBorder(),
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(width: 10),
//                                       ElevatedButton(
//                                         style: ElevatedButton.styleFrom(
//                                           backgroundColor: isCodeSent
//                                               ? Colors.red.withOpacity(0.5)
//                                               : Colors.grey[300],
//                                         ),
//                                         onPressed: () {
//                                           if (phoneController.text.trim().isEmpty) {
//                                             ScaffoldMessenger.of(context)
//                                                 .showSnackBar(
//                                               SnackBar(
//                                                   content: Text(
//                                                       "Please enter your phone number")),
//                                             );
//                                             return;
//                                           }
//                                           setState(() {
//                                             isCodeSent = true;
//                                           });
//                                           FocusScope.of(context).unfocus();
//                                           print('OTP sent to ${phoneController.text.trim()}');
//                                         },
//                                         child: Text(
//                                           isCodeSent
//                                               ? 'Re-get Code'
//                                               : 'Get Code',
//                                           style: GoogleFonts.poppins(
//                                             color: isCodeSent
//                                                 ? Colors.red
//                                                 : Colors.grey,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(height: 10),
//                                   Align(
//                                     alignment: Alignment.centerRight,
//                                     child: TextButton(
//                                       onPressed: () {
//                                         // Forgot password action
//                                       },
//                                       child: Text(
//                                         'Forgot your password?',
//                                         style: GoogleFonts.poppins(
//                                             color: Colors.grey),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             // Email Tab
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 16.0, vertical: 10),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   TextField(
//                                     controller: emailController,
//                                     keyboardType: TextInputType.emailAddress,
//                                     onChanged: (value) => setState(() {
//                                       isEmailLoginComplete =
//                                           emailController.text.isNotEmpty &&
//                                               passwordController.text.isNotEmpty;
//                                     }),
//                                     decoration: InputDecoration(
//                                       labelText: 'Email',
//                                       prefixIcon:
//                                           Icon(Icons.email, color: Colors.red),
//                                       border: OutlineInputBorder(),
//                                     ),
//                                   ),
//                                   SizedBox(height: 16),
//                                   TextField(
//                                     controller: passwordController,
//                                     obscureText: true,
//                                     onChanged: (value) => setState(() {
//                                       isEmailLoginComplete =
//                                           emailController.text.isNotEmpty &&
//                                               passwordController.text.isNotEmpty;
//                                     }),
//                                     decoration: InputDecoration(
//                                       labelText: 'Password',
//                                       prefixIcon: Icon(Icons.lock, color: Colors.red),
//                                       border: OutlineInputBorder(),
//                                     ),
//                                   ),
//                                   SizedBox(height: 10),
//                                   Align(
//                                     alignment: Alignment.centerRight,
//                                     child: TextButton(
//                                       onPressed: () {
//                                         // Forgot password action
//                                       },
//                                       child: Text(
//                                         'Forgot your password?',
//                                         style: GoogleFonts.poppins(
//                                             color: Colors.grey),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Login Button and Register Section
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Column(
//                     children: [
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           minimumSize: Size(double.infinity, 50),
//                           backgroundColor: isOtpComplete || isEmailLoginComplete
//                               ? Colors.red
//                               : Colors.grey[300],
//                         ),
//                         onPressed: isOtpComplete || isEmailLoginComplete
//                             ? () {
//                                 // Login action
//                               }
//                             : null,
//                         child: Text(
//                           'Login',
//                           style: GoogleFonts.poppins(
//                             color: isOtpComplete || isEmailLoginComplete
//                                 ? Colors.white
//                                 : Colors.grey,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                     ],
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Have no account yet?',
//                       style:
//                           GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => SignupScreen()),
//                         );
//                       },
//                       child: Text(
//                         'Sign Up',
//                         style: GoogleFonts.poppins(
//                             color: Colors.red, fontSize: 12),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
