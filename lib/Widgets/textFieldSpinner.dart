import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TextFieldSpinner extends StatefulWidget {
  static var tag = "/TextFieldSpinner";

  final int initValue;
  final int minValue;
  final int maxValue;
  final int step;
  final Function onChange;
  final Icon removeIcon;
  final Icon addIcon;
  final String id;
  final double txtWidth;
  final double txtHeight;
  final bool borderSide;

  const TextFieldSpinner({
    Key? key,
    required this.id,
    required this.initValue,
    required this.minValue,
    required this.maxValue,
    this.step = 1,
    required this.onChange,
    required this.removeIcon,
    required this.addIcon,
    this.txtWidth = 65,
    this.txtHeight = 32,
    this.borderSide = true,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TextFieldSpinnerState();
  }
}

class TextFieldSpinnerState extends State<TextFieldSpinner> {
  TextEditingController txtContador = TextEditingController();
  bool hasChange = false;
  int contador = 0;

  Widget build(BuildContext context) {
    if (hasChange == false) {
      contador = widget.initValue;
    }

    txtContador.text = contador.toString();

    void onChange() {
      hasChange = true;
      contador = int.parse(txtContador.text);
      String id = widget.id;
      widget.onChange(id, contador);
      FocusScope.of(context).unfocus(); //fecho o teclado
    }

    void onAdd() {
      setState(() {
        contador += widget.step;
        if (contador > widget.maxValue) {
          contador = widget.maxValue;
        }
        txtContador.text = contador.toString();
      });
      onChange();
    }

    void onRemove() {
      setState(() {
        contador -= widget.step;
        if (contador < widget.minValue) {
          contador = widget.minValue;
        }
        txtContador.text = contador.toString();
      });
      onChange();
    }

    return Container(
      child: Row(
        children: [
          IconButton(
            icon: widget.removeIcon,
            onPressed: () {
              onRemove();
            },
          ),
          SizedBox(
              width: widget.txtWidth,
              height: widget.txtHeight,
              child: TextFormField(
                controller: txtContador,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                autofocus: false,
                maxLength: 2,
                decoration: InputDecoration(
                  counterText: "",
                  contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  border: OutlineInputBorder(
                      borderSide: widget.borderSide == false
                          ? BorderSide.none
                          : BorderSide(style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(5.0)),
                ),
                onEditingComplete: () async {
                  onChange();
                },
              )),
          IconButton(
            icon: widget.addIcon,
            onPressed: () {
              onAdd();
            },
          ),
        ],
      ),
    );
  }
}
