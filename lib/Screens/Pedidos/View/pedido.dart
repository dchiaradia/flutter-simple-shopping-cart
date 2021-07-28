//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/pedidosController.dart';

class PedidoPage extends GetWidget {
  final PedidoController controller = Get.put(PedidoController());

  @override
  Widget build(BuildContext context) {
    controller.getAllPedidos();

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return controller.myHeader(innerBoxIsScrolled);
        },
        body: controller.myBody(),
      ),
      bottomNavigationBar: controller.myBottomBar(2),
    );
  }
}
