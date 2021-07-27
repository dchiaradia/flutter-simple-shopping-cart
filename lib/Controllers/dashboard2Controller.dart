//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:novo/Models/cartItems.dart';
import '../Controllers/defaultController.dart';

import '../Controllers/products.dart';
import '../Controllers/cartController.dart';
import '../Models/productsModel.dart';
import '../Widgets/textFieldSpinner.dart';

class DashboardController extends GetxController {
  late List<ProductsModel> listaProdutos = List<ProductsModel>.empty();
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
    getAllProducts();
    print('onReady');
    super.onReady();
  }

  @override
  void onClose() {
    print('onClose');
    super.onClose();
  }

  void getAllProducts() async {
    print('bucando produtos');
    Products produtos = Products();
    listaProdutos = await produtos.getAllProducts();
    widgetListViewProdutos = await gridViewProducts(listaProdutos);
    update();
  }

  Future<Widget> gridViewProducts(List<ProductsModel> lista) async {
    return Container(
        width: Get.size.width - 10,
        height: Get.size.height,
        margin: EdgeInsets.only(left: 0, right: 0, top: 0),
        child: GridView.builder(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(10.0),
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0),
            itemCount: lista.length,
            itemBuilder: (BuildContext ctx, index) {
              return gridViewProducsItem(lista[index]);
            }));
  }

  Widget gridViewProducsItem(model) {
    print(model.title);
    return Column(
      children: [
        Text(model.title.toString().substring(0, 20).capitalizeFirst!),
        CachedNetworkImage(
          imageUrl: model.image,
          height: 92,
          width: 92,
        ),
        Text('R\$ ${model.price}'),
        TextFieldSpinner(
            id: model.id.toString(),
            initValue: 0,
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
              print(model.title + ' - id:: $id - cont: $e');
              await myCart.saveItem(CartItemsModel(
                  productId: model.id,
                  productName: model.title,
                  productPrice: model.price,
                  productImage: model.image,
                  productQtd: e));
            })
      ],
    );
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

  myHeader(bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        floating: true,
        forceElevated: innerBoxIsScrolled,
        pinned: true,
        titleSpacing: 0,
        actionsIconTheme: IconThemeData(opacity: 0.0),
        title: myTitle('Todos os Produtos'),
      ),
    ];
  }

  Widget myBody() {
    Future<Null> _refreshLocalList() async {
      this.widgetListViewProdutos = loadding(92, 92);
      update();
      getAllProducts();
      print('refreshing atualizando...');
    }

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
                    child: GetBuilder<DashboardController>(
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
      onRefresh: _refreshLocalList,
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
