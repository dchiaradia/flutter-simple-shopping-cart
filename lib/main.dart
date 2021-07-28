import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Screens/splashScreen/View/splashScreen.dart';
import 'Screens/Dashboard/View/dashboard.dart';

import 'Screens/Cart/View/carrinho.dart';

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
            maintainState: false,
            preventDuplicates: true,
            transition: Transition.rightToLeftWithFade),
        GetPage(
          name: '/carrinho',
          page: () => CarrinhoPage(),
        ),
      ],
    ));
