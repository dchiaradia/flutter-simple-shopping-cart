//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get/get.dart';

import '../Controllers/dashboardController.dart';
import '../Controllers/productsController.dart';
import '../Models/productsModel.dart';

class DashboardController extends GetxController {
  late List<ProductsModel> listaProdutos;

  @override
  void onInit() {
    print('onInit');
    super.onInit();
    getAllProducts();
  }

  @override
  void onReady() {
    print('onReady');
    super.onReady();
  }

  @override
  void onClose() {
    print('onClose');
    super.onClose();
  }

  void getAllProducts() async {
    final produtos = Products();

    List<ProductsModel> retorno = await produtos.getAllProducts();
    this.listaProdutos = retorno;

    update();
  }
}

class DashboardPage extends GetWidget {
  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return _myHeader(context, innerBoxIsScrolled);
        },
        body: _myBody(),
      ),
      //floatingActionButton: cartButtonView(),
      bottomNavigationBar: bottomBar(0),
    );
  }
}

_myHeader(BuildContext BuildContext, bool innerBoxIsScrolled) {
  return <Widget>[
    SliverAppBar(
      floating: true,
      forceElevated: innerBoxIsScrolled,
      pinned: true,
      titleSpacing: 0,
      actionsIconTheme: IconThemeData(opacity: 0.0),
      title: myTitle('Meus produtos'),
    ),
  ];
}

Widget _myBody() {
  return SingleChildScrollView(
    child: Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GetBuilder<DashboardController>(
                builder: (r) => Text(''),
              ),
            ],
          ),
        ),
        Container(),
      ],
    ),
  );
}

Row myTitle(titulo) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Center(
            child: Text(titulo,
                maxLines: 1,
                style: TextStyle(fontSize: 22, color: Colors.white))),
      ),
    ],
  );
}

Widget bottomBar(index) {
  return BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.shopping_basket_outlined),
        label: 'Carrinho',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ],
    currentIndex: index,
    selectedItemColor: Colors.amber[800],
  );
}
