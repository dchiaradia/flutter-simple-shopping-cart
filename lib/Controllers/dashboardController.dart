//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../Controllers/productsController.dart';
import '../Models/productsModel.dart';
import '../Widgets/textFieldSpinner.dart';

class DashboardController extends GetxController {
  late List<ProductsModel> listaProdutos;
  late Widget widgetListViewProdutos = loadding(92, 92);
  @override
  void onInit() {
    print('onInit');
    getAllProducts();
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

  void getAllProducts() async {
    final produtos = Products();
    List<ProductsModel> retorno = await produtos.getAllProducts();
    //this.listaProdutos = retorno;
    widgetListViewProdutos = listViewProducts(retorno);
    update();
    this.getAllProducts();
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
                                onChange: (id, e) {
                                  print('id:: $id - cont: $e');
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
        title: myTitle('Meus produtos'),
      ),
    ];
  }

  Widget myBody() {
    Future<Null> _refreshLocalList() async {
      this.widgetListViewProdutos = loadding(92, 92);
      print('refreshing atualizando...');
      update();
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
}
