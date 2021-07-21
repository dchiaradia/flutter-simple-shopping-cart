import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Screens/splashScreen.dart';
import 'Screens/dashboard.dart';

void main() => runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      defaultTransition: Transition.native,
      locale: Locale('pt', 'BR'),
      theme: new ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.orange,
        primaryColorLight: Colors.orange[200],
        primaryColorDark: Colors.orange[900],
        backgroundColor: Colors.white,
      ),
      getPages: [
        GetPage(
          name: '/',
          page: () => SplashPage(),
        ),
        GetPage(
          name: '/dashboard',
          page: () => DashboardPage(),
        )
      ],
    ));
