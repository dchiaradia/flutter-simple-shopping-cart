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
  late Widget myCartPrice = Container();

  String typeView = 'listView';

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
    getAllProducts();
    refreshCartPrice();

    super.onReady();
  }

  @override
  void onClose() {
    print('onClose');
    super.onClose();
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
          Spacer(flex: 1),
          Icon(
            Icons.shopping_basket_outlined,
            color: Colors.white,
          ),
          Spacer(),
          Text(
            "R\$ ${cartPrice}",
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          Spacer(flex: 2),
        ],
      ),
    );
    update();
  }

  void getAllProducts() async {
    print('bucando produtos');
    Products produtos = Products();
    listaProdutos = await produtos.getAllProducts();

    if (typeView == 'listView') {
      widgetListViewProdutos = listViewProducts(listaProdutos);
    } else {
      widgetListViewProdutos = gridViewProducts(listaProdutos);
    }
    update();
  }

  void changeView() {
    if (typeView == 'listView') {
      typeView = 'gridView';
    } else {
      typeView = 'listView';
    }

    getAllProducts();
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

  Widget listViewProducts(List<ProductsModel> myList) {
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
                Container(
                  width: Get.size.width * 1,
                  child: Text(
                    model.category.toString().capitalize!,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.grey),
                  ),
                ),
                Container(
                  width: Get.size.width * 1,
                  child: Text(
                    model.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(
                                left: 0, top: 0, right: 0, bottom: 0),
                            child: CachedNetworkImage(
                                imageUrl: model.image, height: 92, width: 92)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: Get.size.width * 0.6,
                          child: Text(
                            model.description,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                color: Colors.grey),
                          ),
                        ),
                        Container(
                          width: Get.size.width * 0.6,
                          child: Text(
                            "R\$ " + model.price.toString(),
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
    );
  }

  Widget gridViewProducts(List<ProductsModel> lista) {
    return Container(
        width: Get.size.width - 10,
        height: Get.size.height,
        margin: EdgeInsets.only(left: 0, right: 0, top: 0),
        child: GridView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: EdgeInsets.all(10.0),
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: ((Get.size.width) / (Get.size.height)),
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0),
            itemCount: lista.length,
            itemBuilder: (BuildContext ctx, index) {
              return gridViewProducsItem(lista[index]);
            }));
  }

  Widget gridViewProducsItem(model) {
    return Column(
      children: [
        Text(model.title.toString().capitalizeFirst!),
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
              refreshCartPrice();
            })
      ],
    );
  }

  myHeader(bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        floating: false,
        //backgroundColor: Colors.red,
        forceElevated: innerBoxIsScrolled,
        pinned: true,
        titleSpacing: 0,
        actionsIconTheme: IconThemeData(opacity: 0.0),
        title: myTitle('Todos os Produtos'),
        //leading: IconButton(icon: Icon(Icons.read_more), onPressed: () {}),
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

  Widget myCardPriceCart() {
    return GestureDetector(
      child: GetBuilder<DashboardController>(
        builder: (r) => this.myCartPrice,
      ),
      onTap: () {
        print('clicou');
        refreshCartPrice();
      },
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
        new IconButton(
            icon: Icon(Icons.dashboard),
            onPressed: () {
              changeView();
            })
      ],
    );
  }
}
