import 'package:get/get.dart';
import '../Data/productsData.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Api {
  var apiOptions = {"baseNudeUrl": "fakestoreapi.com", "apiUri": ""};

  Api();

  Future<List<ProductsModel>> getAllProducts() async {
    var request =
        await http.get(Uri.http(apiOptions["baseNudeUrl"]!, "/products"));

    if (request.statusCode != 200) {
      return List<ProductsModel>.empty();
    }

    var json = jsonDecode(request.body);

    List<ProductsModel> retorno = List<ProductsModel>.from(
        json.map((model) => ProductsModel.fromJson(model)));

    return retorno;
  }
}
