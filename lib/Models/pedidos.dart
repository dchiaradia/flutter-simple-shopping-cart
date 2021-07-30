import 'package:novo/Data/pedidosData.dart';

import 'db.dart';

class Pedidos {
  Pedidos();

  final banco = DB.instance;

  Future<List<PedidosData>> find(int id) async {
    //busco todos os produtos do banco de dados ordenados por title
    var retorno = await banco.query('SELECT * FROM pedidos WHERE id=?', [id]);

    //converto os produtos em uma lista do tipo de produtos
    List<PedidosData> listaPedidos =
        List<PedidosData>.from(retorno.map((e) => PedidosData.fromJson(e)));

    return listaPedidos;
  }

  Future<List<PedidosData>> getAllPedidos() async {
    //busco todos os produtos do banco de dados ordenados por title
    var retorno =
        await banco.query('SELECT * FROM pedidos ORDER BY dtPedido DESC', []);

    //converto os produtos em uma lista do tipo de produtos
    List<PedidosData> listaPedidos =
        List<PedidosData>.from(retorno.map((e) => PedidosData.fromJson(e)));

    return listaPedidos;
  }
}
