import 'dart:math';

import 'package:flutter/material.dart';
import 'package:productos_app/delegates/flow_delegate.dart';
import 'package:productos_app/services/product_service.dart';
import 'package:provider/provider.dart';

class FlowMenu extends StatefulWidget {
  const FlowMenu({
    Key? key,
    required this.lista,
  }) : super(key: key);

  final List<Map<String, dynamic>> lista;
  @override
  State<FlowMenu> createState() => _FlowMenuState();
}

class _FlowMenuState extends State<FlowMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  List<Map<String, dynamic>> icons = [];
  @override
  void initState() {
    super.initState();
    icons.addAll(widget.lista);
    if (Provider.of<ProductsService>(context, listen: false)
            .selectedProduct
            .id ==
        null) {
      icons.removeWhere((element) => element['nombre'] == 'delete_forever');
    }
    animationController = AnimationController(
        duration: const Duration(milliseconds: 230), vsync: this);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: FlowMenuDelegate(controller: animationController),
      children: icons
          .map<Widget>(
              (el) => buildItem(el['nombre'], el['icon'], el['method']))
          .toList(),
    );
  }

  Widget buildItem(String name, IconData icon, Function? f) => SizedBox(
        height: 65,
        width: 65,
        child: FloatingActionButton(
          backgroundColor: Colors.indigo,
          heroTag: getRandomString(10),
          onPressed: () {
            actionButton(name, f ?? () {});
            if (animationController.status == AnimationStatus.completed) {
              animationController.reverse();
            } else {
              animationController.forward();
            }
          },
          child: Icon(
            icon,
            color: Colors.white,
            size: 45,
          ),
        ),
      );

  String getRandomString(int length) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  actionButton(String icon, Function method) {
    switch (icon) {
      case 'save':
        method();
        break;
      case 'delete_forever':
        method();
        break;
      case 'home':
        method();
        break;
      default:
    }
  }
}
