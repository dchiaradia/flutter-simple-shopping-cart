import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import '../Config/api.dart';
import '../Models/productsModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products {
  Future<List<ProductsModel>> getAllProducts() async {
    var baseNudeUrl = apiOptions["baseNudeUrl"];

    var request = http.Request('GET', Uri.http(baseNudeUrl!, "/products"));
    http.StreamedResponse response = await request.send();

    if (response.statusCode != 200) {
      Get.snackbar('Erro de conexão!',
          'Não foi possivel conectar no servidor para atualização dos produtos.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[900],
          colorText: Colors.white);
      return List<ProductsModel>.empty();
    }

    var json = jsonDecode(await response.stream.bytesToString());

    List<ProductsModel> retorno = List<ProductsModel>.from(
        json.map((model) => ProductsModel.fromJson(model)));

    return retorno;
  }
}
