import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/preferences.dart';

class SearchDialog extends StatelessWidget {
  final String initialText;

  SearchDialog(this.initialText);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 2,
            left: 7,
            right: 7,
            child: Card(
              child: TextFormField(
                initialValue: this.initialText,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.search,
                autofocus: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                  prefixIcon: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: primaryColor,
                      ),
                      onPressed: Get.back),
                ),
                onFieldSubmitted: (String valor) {
                  Navigator.of(context).pop(valor);
                },
              ),
            ))
      ],
    );
  }
}
