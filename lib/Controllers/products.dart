import '../Models/productsModel.dart';

import 'db.dart';
import '../Services/api.dart';

class Products {
  Products();

  final banco = DB.instance;

  Future<void> populate() async {
    //apago todos os produtos da tabela
    var qtdExcluida = await banco.rawDelete('products', '', '');
    print('Tabela de produtos limpa! ($qtdExcluida)');

    Api api = new Api();

    //agora vou buscar todos os produtos da API
    List<ProductsModel> listaProdutos = await api.getAllProducts();

    //insiro os produtos encontrados na tabela
    listaProdutos.forEach((element) async {
      await banco.insert('products', element.toMap());
    });

    print('Tabela de produtos populada!!');
  }

  Future<List<ProductsModel>> find(int id) async {
    //busco todos os produtos do banco de dados ordenados por title
    var retorno = await banco.query('SELECT * FROM products WHERE id=?', [id]);

    //converto os produtos em uma lista do tipo de produtos
    List<ProductsModel> listaProdutos =
        List<ProductsModel>.from(retorno.map((e) => ProductsModel.fromJson(e)));

    return listaProdutos;
  }

  Future<List<ProductsModel>> getAllProducts() async {
    print('Buscando produtos do banco de dados');

    //busco todos os produtos do banco de dados ordenados por title
    var retorno =
        await banco.query('SELECT * FROM products ORDER BY title', []);

    //converto os produtos em uma lista do tipo de produtos
    List<ProductsModel> listaProdutos =
        List<ProductsModel>.from(retorno.map((e) => ProductsModel.fromJson(e)));

    print('Produtos do banco localizados.');
    return listaProdutos;
  }
}
