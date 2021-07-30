//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novo/Screens/Dashboard/View/dashboard.dart';
import 'package:novo/Screens/Cart/View/carrinho.dart';
import 'package:novo/Screens/Pedidos/View/pedido.dart';

Widget bottomBar(index) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    currentIndex: index,
    selectedItemColor: Colors.amber[800],
    unselectedItemColor: Colors.grey,
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.shopping_basket_outlined),
        label: 'Carrinho',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.list_outlined),
        label: 'Pedidos',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ],
    onTap: (int index) {
      if (index == 0) {
        //Get.toNamed('/dashboard');
        Get.offAll(DashboardPage());
      } else if (index == 1) {
        //Get.toNamed('/carrinho');
        Get.offAll(CarrinhoPage());
      } else if (index == 2) {
        Get.offAll(PedidoPage());
      }
      print(index);
    },
  );
}
