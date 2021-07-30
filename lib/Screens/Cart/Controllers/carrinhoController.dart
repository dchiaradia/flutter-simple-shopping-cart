//import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:novo/Models/products.dart';
import 'package:novo/Data/cartItemsData.dart';
import 'package:novo/Data/productsData.dart';

//import '../Controllers/productsController.dart';
import '../../../Models/defaultController.dart';
import '../../../Models/cartModel.dart';

import '../../../Widgets/textFieldSpinner.dart';
import '../../ProductDetail/View/productDetail.dart';

class CarrinhoController extends GetxController {
  late List<CartItemsData> listaItens;
  Cart myCart = new Cart();
  late Widget widgetListViewProdutos = loadding(92, 92);
  late Widget myCartPrice = Container();
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
    refreshCartPrice();
    super.onReady();
  }

  @override
  void onClose() {
    print('onClose');
    super.onClose();
  }

  getAllProducts() async {
    print('atualizando carrinho...');
    listaItens = await myCart.getProducts();
    update();
    widgetListViewProdutos = await listViewProducts(listaItens);
    update();
    print('carrinho atualizado!');
  }

  void makePedido() async {
    await myCart.makePedido();
    await getAllProducts();
    refreshCartPrice();
    update();
    Get.snackbar("Pedidos Realizado",
        "Pedido realizado com sucesso! Em breve você receberá seu pedido.",
        backgroundColor: Colors.black, colorText: Colors.white);
  }

  void refreshCartPrice() async {
    print('atulizando preço do carrinho');
    double cartPrice = await myCart.getCartPrice();

    if (cartPrice == 0) {
      myCartPrice = Container();
      update();
      return;
    }

    myCartPrice = Container(
      height: 50,
      width: Get.size.width * 0.90,
      alignment: Alignment.center,
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          Text(
            "R\$ ${cartPrice}",
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          Spacer(flex: 3),
          ElevatedButton.icon(
              onPressed: () {
                makePedido();
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              icon: Icon(
                Icons.add_task,
                color: Colors.white,
              ),
              label: Text(
                'Finalizar Pedido',
                style: TextStyle(color: Colors.white),
              )),
          Spacer(flex: 1),
        ],
      ),
    );
    update();
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

  Widget listViewProducts(List<CartItemsData> myList) {
    return Container(
      margin: EdgeInsets.only(left: 0, right: 0, top: 0),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: myList.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return listViewProductsItem(myList[index], context);
        },
      ),
    );
  }

  Widget listViewProductsItem(model, BuildContext context) {
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
                                  new TextFieldSpinner(
                                      id: model.productId.toString(),
                                      key: UniqueKey(),
                                      initValue: model.productQtd,
                                      minValue: 0,
                                      maxValue: 99,
                                      step: 1,
                                      txtHeight: 32,
                                      txtWidth: 65,
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
                                        await myCart.saveItem(CartItemsData(
                                            productId: model.productId,
                                            productName: model.productName,
                                            productPrice: model.productPrice,
                                            productImage: model.productImage,
                                            productQtd: e));
                                        if (e == 0) {
                                          //sleep(Duration(seconds: 1));
                                          await refreshLocalList();
                                        }
                                        refreshCartPrice();
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
            onTap: () async {
              Products produto = Products();
              List<ProductsModel> productModel =
                  await produto.find(model.productId);

              ProductsModel modelo = productModel[0];
              showCupertinoModalBottomSheet(
                expand: true,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => ProductDetailSheet(
                    modelo.category!,
                    modelo.title!,
                    modelo.description!,
                    modelo.price!,
                    modelo.image!),
              );
              update();
            }));
  }

  myHeader(bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        title: Text("Meu Carrinho"),
        forceElevated: innerBoxIsScrolled,
        pinned: true,
        centerTitle: true,
        titleSpacing: 0,
        actionsIconTheme: IconThemeData(opacity: 0.0),
      )
    ];
  }

  Future<Null> refreshLocalList() async {
    this.widgetListViewProdutos = loadding(92, 92);
    update();
    print('Iniciando atualização forçada...');
    await getAllProducts();
    update();
  }

  Widget myBody() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: GetBuilder<CarrinhoController>(
              builder: (r) => this.widgetListViewProdutos,
            ),
          ),
          GestureDetector(
            child: GetBuilder<CarrinhoController>(
              builder: (r) => this.myCartPrice,
            ),
            onTap: () {
              print('clicou');
              refreshCartPrice();
            },
          ),
        ],
      ),
    );
  }

  Widget myCardPriceCart() {
    return GestureDetector(
      child: GetBuilder<CarrinhoController>(
        builder: (r) => this.myCartPrice,
      ),
      onTap: () {
        print('clicou');
        refreshCartPrice();
      },
    );
  }
}
