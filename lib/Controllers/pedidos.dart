import 'package:novo/Models/pedidosModel.dart';

import 'db.dart';

class Pedidos {
  Pedidos();

  final banco = DB.instance;

  Future<List<PedidosModel>> find(int id) async {
    //busco todos os produtos do banco de dados ordenados por title
    var retorno = await banco.query('SELECT * FROM pedidos WHERE id=?', [id]);

    //converto os produtos em uma lista do tipo de produtos
    List<PedidosModel> listaPedidos =
        List<PedidosModel>.from(retorno.map((e) => PedidosModel.fromJson(e)));

    return listaPedidos;
  }

  Future<List<PedidosModel>> getAllPedidos() async {
    //busco todos os produtos do banco de dados ordenados por title
    var retorno =
        await banco.query('SELECT * FROM pedidos ORDER BY dtPedido DESC', []);

    //converto os produtos em uma lista do tipo de produtos
    List<PedidosModel> listaPedidos =
        List<PedidosModel>.from(retorno.map((e) => PedidosModel.fromJson(e)));

    return listaPedidos;
  }
}
