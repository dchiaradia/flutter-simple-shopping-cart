import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Models/products.dart';
import '../../Dashboard/View/dashboard.dart';

class SplashPage extends StatelessWidget {
  String appName = 'APP NAME';
  int splashTime = 5;

  SplashPage() {
    startTimeout();
  }

  startTimeout() async {
    //executo a funcao de popular a tabela de produtos, depois redireciono para pagina de dashboard
    Products produto = new Products();
    await produto.populate();
    return Timer(Duration(seconds: splashTime), changeScreen);
  }

  changeScreen() {
    //Get.toNamed('/dashboard');
    Get.offAll(DashboardPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _newBody(),
    );
  }

  Widget _newBody() {
    final titulo = Text(
      appName,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );

    final txtPoweredBy = Text(
      'Powered By:',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
    );

    final txtCompanyName = Text(
      '@chiaradia.com.br',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );

    return Stack(
      children: [
        Positioned(
          top: Get.size.height / 2,
          width: Get.size.width,
          child: Align(
            alignment: Alignment.center,
            child: titulo,
          ),
        ),
        Positioned(
            bottom: 40,
            width: Get.size.width,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [txtPoweredBy, txtCompanyName],
                ))),
      ],
    );
  }
}
