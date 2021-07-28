//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/carrinhoController.dart';

class CarrinhoPage extends GetWidget {
  final CarrinhoController controller = Get.put(CarrinhoController());

  @override
  Widget build(BuildContext context) {
    controller.getAllProducts();

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return controller.myHeader(innerBoxIsScrolled);
        },
        body: controller.myBody(),
      ),
      floatingActionButton: controller.myCardPriceCart(),
      bottomNavigationBar: controller.myBottomBar(1),
    );
  }
}
