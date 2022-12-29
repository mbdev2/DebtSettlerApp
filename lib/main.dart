import 'package:debtsettler_v4/Gospodinjstvo/Models/Uporabnik_model.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Screens/AddNakup.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Screens/NakupovalnaLista.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Screens/UserInfo.dart';
import 'package:debtsettler_v4/Home/Screens/Home.dart';
import 'package:debtsettler_v4/LandingPages/Screens/LandingPage.dart';
import 'package:debtsettler_v4/LandingPages/Screens/Login.dart';
import 'package:debtsettler_v4/LandingPages/Screens/Registration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:debtsettler_v4/Gospodinjstvo/Screens/Gospodinjstvo.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Screens/Zgodovina.dart';
import 'package:debtsettler_v4/Gospodinjstvo/Services/Gospodinjstvo_services.dart';
import 'Storage/StorageItem_model.dart';
import 'Storage/Storage_services.dart';
import 'package:hexcolor/hexcolor.dart';



// INICIALZIZACIJA SAFE STORAGE-a
final storage = StorageService();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Color _primaryColor = HexColor('#FFFFFF');
  final Color _accentColor = HexColor('#FFFFFF');

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Debtsettler',
      theme: ThemeData(
        // This is the theme of your application.
        primaryColor: _primaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: HexColor('#ffffff'),
          shape: const BeveledRectangleBorder()
        ),
        cardColor: HexColor('#d3e5e6'),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: _accentColor),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyAppController(),
        '/landingPage': (context) => const LandingPage(),
        '/login': (context) => const Login(),
        '/registration': (context) => const Registration(),
        '/home': (context) => const Home(),
        '/userInfo': (context) => const UserInfo(),
        //'/addNakup': (context) => const AddNakup(),
      },
    );
  }
}

class MyAppController extends StatelessWidget {
  const MyAppController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    isLogged(context);
    return Scaffold(
        body: Center(
          child: SvgPicture.asset('assets/Icons/Group 6.svg'),
        )
    );
  }
}

Future isLogged(BuildContext context) async {
  var prijavljenUporabnik = await storage.readSecureData('prijavljenUporabnik');
  //print("PRIJAVLJEN UPORABNIK: $prijavljenUporabnik");
  if (prijavljenUporabnik == null) {
    Navigator.pushNamedAndRemoveUntil(
        context,
        '/landingPage',
        (route) => false
    );
  } else {
    Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false);
  }
}
