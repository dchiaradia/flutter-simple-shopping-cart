class PedidosModel {
  int? id;
  int? dtPedido;

  PedidosModel({this.id, this.dtPedido});

  PedidosModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dtPedido = json['dtPedido'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'dtPedido': this.dtPedido,
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dtPedido'] = this.dtPedido;
    return data;
  }
}
