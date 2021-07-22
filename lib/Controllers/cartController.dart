import 'package:get/get.dart';
import '../Config/api.dart';
import '../Models/cartItems.dart';
import '../Models/productsModel.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'db.dart';

class Cart {
  Cart();
  final banco = DB.instance;

  void saveItem(CartItemsModel item) async {
    //verifico se o item já foi inserido no carrinho
    final count = await banco
        .query('SELECT id FROM cartItems WHERE productId=?', [item.productId]);

    //se o contador de linhas for maior ou igual a 1, então ja existe
    if (count.length >= 1) {
      item.id = count[0]['id'];
      //realizo um update
      final idUpdate = await banco.update('cartItems', 'id', item.toMap());
      print('linha alterada id: $idUpdate');
    } else {
      //caso não tenha sido inserido, faço o insert
      final idInsert = await banco.insert('cartItems', item.toMap());
      print('linha inserida id: $idInsert');
    }
    print(item.toJson());
  }

  Future<List<ProductsModel>> getAllProducts() async {
    var baseNudeUrl = apiOptions["baseNudeUrl"];

    var request = http.Request('GET', Uri.http(baseNudeUrl!, "/products"));
    http.StreamedResponse response = await request.send();

    var json = jsonDecode(await response.stream.bytesToString());

    List<ProductsModel> retorno = List<ProductsModel>.from(
        json.map((model) => ProductsModel.fromJson(model)));

    return retorno;
  }
}
