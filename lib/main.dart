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
        dividerTheme: DividerThemeData(
          thickness: 0.5,
          indent: 0,
          endIndent: 0,
          color: Colors.blue[900],
        ),
        primaryColor: Colors.blue[900],
        primaryColorLight: Colors.blue[200],
        primaryColorDark: Colors.indigo[900],
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
