import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:productos_app/services/product_service.dart';
import 'package:provider/provider.dart';

Future<dynamic> showModal(BuildContext context) {
  return showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => CupertinoAlertDialog(
            title: const Text('Escoge una opcion'),
            content: Column(
              children: const [
                SizedBox(
                  height: 18,
                ),
                Icon(
                  Icons.image,
                  size: 50,
                  color: Colors.grey,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text('Selecciona una imagen para el producto'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Provider.of<ProductsService>(context, listen: false).imgOpt =
                      'galeria';
                  Navigator.pop(context);
                },
                child: const Text('Galeria'),
              ),
              TextButton(
                onPressed: () {
                  Provider.of<ProductsService>(context, listen: false).imgOpt =
                      'camara';
                  Navigator.pop(context);
                },
                child: const Text('Camara'),
              )
            ],
          ));
}
