//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    onTap: (int index) {
      if (index == 0) {
        Get.toNamed('/dashboard');
      } else if (index == 1) {
        Get.toNamed('/carrinho').reactive;
      }
    },
  );
}