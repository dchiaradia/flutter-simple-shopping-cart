import 'package:get/get.dart';
import '../Services/api.dart';
import '../Models/cartItems.dart';
import '../Models/productsModel.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'db.dart';

class Cart {
  Cart();
  final banco = DB.instance;
  double cartPrice = 0;

  saveItem(CartItemsModel item) async {
    //verifico se o item já foi inserido no carrinho
    final count = await banco
        .query('SELECT id FROM cartItems WHERE productId=?', [item.productId]);

    //se o contador de linhas for maior ou igual a 1, então ja existe
    if (count.length >= 1) {
      item.id = count[0]['id'];

      //agora verifico se a quantidade enviada é zero ou menor
      if (item.productQtd! <= 0) {
        //se for zero ou menor é para remover do BD
        final idDelete = await banco.delete('cartItems', 'id', item.id);
        print('item cart removido linha => $idDelete');
      } else {
        //se já tiver registro - realizo um update
        final idUpdate = await banco.update('cartItems', 'id', item.toMap());
        print('item cart alterado linha => $idUpdate');
      }
    } else {
      if (item.productQtd! <= 0) {
        return;
      }
      //caso não tenha sido inserido, faço o insert
      final idInsert = await banco.insert('cartItems', item.toMap());
      print('item cart adicionado linha => $idInsert');
    }
  }

  Future<List<CartItemsModel>> getProducts() async {
    final result =
        await banco.query('SELECT * FROM cartItems WHERE pedidoId is Null', []);

    //var json = jsonDecode(await response.stream.bytesToString());

    List<CartItemsModel> retorno = List<CartItemsModel>.from(
        result.map((model) => CartItemsModel.fromJson(model)));

    return retorno;
  }

  Future<double> getCartPrice() async {
    this.cartPrice = 0;
    //busco o preço atual do carrinho
    final result = await banco.query(
        "SELECT SUM(productPrice*productQtd) as valor FROM cartItems WHERE pedidoID is null ",
        []);

    if (result.length >= 1) {
      if (result[0]['valor'] == null) {
        this.cartPrice = 0;
      } else {
        this.cartPrice = result[0]['valor'];
      }
      return this.cartPrice.toPrecision(2);
    }
    //retorno o preço do carrinho
    return 0;
  }
}
