import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:productos_app/services/auth_service.dart';
import 'package:productos_app/services/push_notification_service.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductsService productS = Provider.of<ProductsService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
              onPressed: () async {
                await PushNotificationService.deleteToken();
                // ignore: use_build_context_synchronously
                await Provider.of<AuthService>(context, listen: false).logout();
                // ignore: use_build_context_synchronously
                Navigator.pushReplacementNamed(context, 'login');
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => productS.getAllProducts(pullToRefresh: true),
        child: !productS.isLoading && productS.products.isNotEmpty
            ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                itemCount: productS.products.length,
                itemBuilder: (_, item) => GestureDetector(
                    onTap: () {
                      productS.selectedProduct = productS.products[item].copy();
                      Navigator.pushNamed(context, 'product');
                    },
                    child: ProductCard(
                      product: productS.products[item],
                    )))
            : productS.isLoading
                ? const Center(
                    child: CupertinoActivityIndicator(radius: 20),
                  )
                : const Center(child: Empty()),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          productS.clearProduct();
          Navigator.pushNamed(context, 'product');
        },
      ),
    );
  }
}

class Empty extends StatelessWidget {
  const Empty({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.data_array,
          size: 100,
          color: Colors.grey,
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          'No hay productos',
          style: TextStyle(
              fontSize: 25, color: Colors.grey, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
