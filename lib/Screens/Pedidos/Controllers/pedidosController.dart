//import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:novo/Controllers/pedidos.dart';
import 'package:novo/Models/pedidosModel.dart';
import '../../../Controllers/defaultController.dart';

class PedidoController extends GetxController {
  late Widget widgetListViewPedidos = Container();
  late List<PedidosModel> listaPedidos;
  Pedidos myPedido = new Pedidos();

  Widget myBottomBar(index) {
    return bottomBar(index);
  }

  @override
  void onInit() {
    print('onInit');
    super.onInit();
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

  Future<void> getAllPedidos() async {
    print('Buscando todos os pedidos...');
    List<PedidosModel> listaPedidos = await myPedido.getAllPedidos();
    widgetListViewPedidos = await listViewPedidos(listaPedidos);
    update();
    print('Listagem de Pedidos Concluida!');
  }

  myHeader(bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        floating: true,
        forceElevated: innerBoxIsScrolled,
        pinned: true,
        titleSpacing: 0,
        actionsIconTheme: IconThemeData(opacity: 0.0),
        title: myTitle('Meus Pedidos'),
      ),
    ];
  }

  Widget myBody() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: GetBuilder<PedidoController>(
                    builder: (r) => this.widgetListViewPedidos,
                  ),
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

  Widget listViewPedidos(List<PedidosModel> myList) {
    return Container(
      margin: EdgeInsets.only(left: 0, right: 0, top: 0),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: myList.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return listViewPedidosItem(myList[index], context);
        },
      ),
    );
  }

  Widget listViewPedidosItem(model, BuildContext context) {
    final DateTime dtPedido =
        DateTime.fromMillisecondsSinceEpoch(model.dtPedido);
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
    final String dtPedidoFormatada = formatter.format(dtPedido);

    return Container(
        margin: EdgeInsets.only(bottom: 0),
        //height: 250,
        width: Get.size.width - 10,
        child: GestureDetector(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 16),
                  child: Column(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: Get.size.width * 0.6,
                            child: Text(
                              model.id.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black),
                            ),
                          ),
                          Container(
                            width: Get.size.width * 0.6,
                            child: Text(
                              "Pedido realizado em \n" + dtPedidoFormatada,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {}));
  }
}
