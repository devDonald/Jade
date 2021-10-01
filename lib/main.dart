import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medcare/src/auth/login_doctor.dart';
import 'package:medcare/src/auth/user_login.dart';
import 'package:medcare/src/doctor/doctor_home.dart';
import 'package:medcare/src/doctor/list_chats.dart';
import 'package:medcare/src/screens/about_us.dart';
import 'package:medcare/src/screens/chat_history.dart';
import 'package:medcare/src/screens/contact.dart';
import 'package:medcare/src/screens/jade_chat.dart';
import 'package:medcare/src/screens/services.dart';
import 'package:medcare/src/screens/users_home.dart';

import 'src/welcomePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: 'Jade',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
          bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
      routes: {
        '/welcome': (context) => WelcomePage(),
        '/login1': (context) => UserLogin(),
        '/login2': (context) => LoginDoctor(),
        '/home': (context) => UsersHome(),
        '/home2': (context) => DoctorHome(),
        '/chat': (context) => JadeChat(),
        '/history': (context) => ChatHistory(),
        '/appointments': (context) => ChatList(),
        '/about': (context) => AboutUs(),
        '/services': (context) => Services(),
        '/contact': (context) => Contact(),
      },
    );
  }
}
