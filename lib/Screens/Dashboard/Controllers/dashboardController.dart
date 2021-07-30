//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:novo/Data/cartItemsData.dart';
import '../../../Models/defaultController.dart';

import '../../../Models/products.dart';
import '../../../Models/cartModel.dart';
import '../../../Data/productsData.dart';
import '../../../Widgets/textFieldSpinner.dart';
import '../../ProductDetail/View/productDetail.dart';

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
    getAllProducts();
    super.onInit();
  }

  @override
  void onReady() {
    print('onReady');

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

    widgetListViewProdutos = TabBarView(
        //physics: NeverScrollableScrollPhysics(),
        children: [
          GridView.builder(
              padding: EdgeInsets.all(3.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                childAspectRatio: 0.65,
              ),
              itemCount: listaProdutos.length,
              itemBuilder: (context, index) {
                return gridViewProducsItem(listaProdutos[index], context);
              }),
          ListView.builder(
              padding: EdgeInsets.all(4.0),
              itemCount: listaProdutos.length,
              itemBuilder: (context, index) {
                return listViewProductsItem(listaProdutos[index], context);
              })
        ]);
    print('Tab View Montado');
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

  Widget listViewProductsItem(model, BuildContext context) {
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
                GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.only(
                                  left: 0, top: 0, right: 0, bottom: 0),
                              child: CachedNetworkImage(
                                  imageUrl: model.image,
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
                              model.description,
                              maxLines: 5,
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
                                    print(
                                        model.title + ' - id:: $id - cont: $e');
                                    await myCart.saveItem(CartItemsData(
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
                  onTap: () {
                    showCupertinoModalBottomSheet(
                      expand: true,
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => ProductDetailSheet(
                          model.category,
                          model.title,
                          model.description,
                          model.price,
                          model.image),
                    );
                    update();
                  },
                ),
                const Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget gridViewProducsItem(model, BuildContext context) {
    return GestureDetector(
      child: Card(
        margin: EdgeInsets.all(3.0),
        child: Column(
          children: [
            Text(model.title.toString().capitalizeFirst!, maxLines: 1),
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
                txtHeight: 22,
                txtWidth: 20,
                borderSide: false,
                removeIcon: const Icon(
                  Icons.remove_circle,
                  size: 24,
                  color: Colors.red,
                ),
                addIcon: const Icon(
                  Icons.add_circle,
                  size: 24,
                  color: Colors.green,
                ),
                onChange: (id, e) async {
                  print(model.title + ' - id:: $id - cont: $e');
                  await myCart.saveItem(CartItemsData(
                      productId: model.id,
                      productName: model.title,
                      productPrice: model.price,
                      productImage: model.image,
                      productQtd: e));
                  refreshCartPrice();
                })
          ],
        ),
      ),
      onTap: () {
        showCupertinoModalBottomSheet(
          expand: true,
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => ProductDetailSheet(model.category, model.title,
              model.description, model.price, model.image),
        );
        update();
      },
    );
  }

  myHeader(bool innerBoxIsScrolled) {
    return AppBar(
      title: Text("Meus Produtos"),
      centerTitle: true,
      bottom: TabBar(
        indicatorColor: Colors.white,
        tabs: <Widget>[
          Tab(
            icon: Icon(Icons.grid_on),
          ),
          Tab(
            icon: Icon(Icons.list),
          )
        ],
      ),
    );
  }

  Widget myBody() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: GetBuilder<DashboardController>(
              builder: (r) => this.widgetListViewProdutos,
            ),
          ),
          GestureDetector(
            child: GetBuilder<DashboardController>(
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
}
