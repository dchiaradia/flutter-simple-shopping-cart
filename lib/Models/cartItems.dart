class CartItemsModel {
  int? id;
  int? productId;
  String? productName;
  double? productPrice;
  int? productQtd;
  String? productImage;
  int? pedidoId;

  CartItemsModel(
      {this.id,
      this.productId,
      this.productPrice,
      this.productName,
      this.productQtd,
      this.productImage,
      this.pedidoId});

  CartItemsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    productPrice = json['productPrice'].toDouble();
    productName = json['productName'];
    productQtd = json['productQtd'];
    productImage = json['productImage'];
    pedidoId = json['pedidoId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'productId': this.productId,
      'productPrice': this.productPrice,
      'productName': this.productName,
      'productQtd': this.productQtd,
      'productImage': this.productImage,
      'pedidoId': this.pedidoId,
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productId'] = this.productId;
    data['productPrice'] = this.productPrice;
    data['productName'] = this.productName;
    data['productQtd'] = this.productQtd;
    data['productImage'] = this.productImage;
    data['pedidoId'] = this.pedidoId;
    return data;
  }
}
