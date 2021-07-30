import 'package:get/get.dart';
import 'package:novo/Data/pedidosData.dart';

import '../Data/cartItemsData.dart';

import 'dart:convert';
import 'db.dart';

class Cart {
  Cart();
  final banco = DB.instance;
  double cartPrice = 0;

  saveItem(CartItemsData item) async {
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

  Future<List<CartItemsData>> getProducts() async {
    final result =
        await banco.query('SELECT * FROM cartItems WHERE pedidoId is Null', []);

    //var json = jsonDecode(await response.stream.bytesToString());

    List<CartItemsData> retorno = List<CartItemsData>.from(
        result.map((model) => CartItemsData.fromJson(model)));

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

  Future<int> makePedido() async {
    //busco o valor do carrinho
    double cartValue = await this.getCartPrice();

    if (cartValue == 0) {
      //se o valor do carrinho for zero retorno, pois não tem itens
      return 0;
    }

    //caso o valor do carrinho seja superior a zero, tenho que gerar o pedido gravar os itens.
    PedidosData pedido =
        PedidosData(dtPedido: new DateTime.now().millisecondsSinceEpoch);

    final idInsert = await banco.insert('pedidos', pedido.toMap());
    print('Pedido Criado : ${idInsert}');

    await banco.query(
        'UPDATE cartItems SET pedidoID=? WHERE pedidoID is Null', [idInsert]);

    return idInsert;
  }
}
