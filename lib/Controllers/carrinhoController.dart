//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:novo/Models/cartItems.dart';

//import '../Controllers/productsController.dart';
import '../Controllers/defaultController.dart';
import '../Controllers/cartController.dart';
import '../Models/productsModel.dart';
import '../Widgets/textFieldSpinner.dart';

class CarrinhoController extends GetxController {
  late List<CartItemsModel> listaItens;
  Cart myCart = new Cart();
  late Widget widgetListViewProdutos = loadding(92, 92);

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
    this.getAllProducts();
    super.onReady();
  }

  @override
  void onClose() {
    print('onClose');
    super.onClose();
  }

  void getAllProducts() async {
    print('atualizando carrinho');
    listaItens = await myCart.getProducts();
    widgetListViewProdutos = await listViewProducts(listaItens);
    update();
    print('carrinho atualizado');
  }

  Widget loadding(double height, double width) {
    return Container(
      child: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.green[100],
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                ),
                height: height,
                width: width,
              )
            ]),
      ),
    );
  }

  Widget listViewProducts(List<CartItemsModel> myList) {
    return Container(
      margin: EdgeInsets.only(left: 0, right: 0, top: 0),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: myList.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return listViewProductsItem(myList[index]);
        },
      ),
    );
  }

  Widget listViewProductsItem(model) {
    return Container(
      margin: EdgeInsets.only(bottom: 0),
      //height: 250,
      width: Get.size.width - 10,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 16),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(
                                left: 0, top: 0, right: 0, bottom: 0),
                            child: CachedNetworkImage(
                                imageUrl: model.productImage,
                                height: 92,
                                width: 92)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: Get.size.width * 0.6,
                          child: Text(
                            model.productName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                          width: Get.size.width * 0.6,
                          child: Text(
                            "R\$ " + model.productPrice.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            TextFieldSpinner(
                                id: model.id.toString(),
                                initValue: model.productQtd,
                                minValue: 0,
                                maxValue: 99,
                                step: 1,
                                removeIcon: const Icon(
                                  Icons.remove_circle,
                                  size: 32,
                                  color: Colors.red,
                                ),
                                addIcon: const Icon(
                                  Icons.add_circle,
                                  size: 32,
                                  color: Colors.green,
                                ),
                                onChange: (id, e) async {
                                  print(model.productName +
                                      ' - id:: $id - cont: $e');
                                  await myCart.saveItem(CartItemsModel(
                                      productId: model.productId,
                                      productName: model.productName,
                                      productPrice: model.productPrice,
                                      productImage: model.productImage,
                                      productQtd: e));
                                  if (e == 0) {
                                    refreshLocalList();
                                  }
                                })
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  myHeader(bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        floating: true,
        forceElevated: innerBoxIsScrolled,
        pinned: true,
        titleSpacing: 0,
        actionsIconTheme: IconThemeData(opacity: 0.0),
        title: myTitle('Meu Carrinho'),
      ),
    ];
  }

  Future<Null> refreshLocalList() async {
    this.widgetListViewProdutos = loadding(92, 92);
    print('refreshing atualizando...');
    update();
    getAllProducts();
  }

  Widget myBody() {
    return RefreshIndicator(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: GetBuilder<CarrinhoController>(
                      builder: (r) => this.widgetListViewProdutos,
                    ),
                  ),
                ],
              ),
            ),
            Container(),
          ],
        ),
      ),
      onRefresh: refreshLocalList,
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
}
