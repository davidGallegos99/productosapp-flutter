import 'package:flutter/material.dart';
import 'package:productos_app/models/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, required this.product}) : super(key: key);
  final Product product;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 30, bottom: 50),
      height: 350,
      decoration: _cardDecoration(),
      child: Stack(alignment: Alignment.bottomLeft, children: [
        _BackgroundImage(url: product.getFullImg() ?? ''),
        _ProductDetails(title: product.name, subtitle: product.id ?? 'N/A'),
        Positioned(
          top: 0,
          right: 0,
          child: _PriceTag(price: product.price),
        ),
        Positioned(
            top: 0,
            left: 0,
            child: !product.available ? const _NotAvailable() : Container())
      ]),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, blurRadius: 10, offset: Offset(0, 7))
          ]);
}

class _NotAvailable extends StatelessWidget {
  const _NotAvailable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: 100,
      height: 65,
      decoration: BoxDecoration(
          color: Colors.yellow[800],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
      child: const FittedBox(
        fit: BoxFit.contain,
        child: Text(
          'No Disponible',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {
  const _PriceTag({
    Key? key,
    required this.price,
  }) : super(key: key);
  final double price;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      width: MediaQuery.of(context).size.width * 0.28,
      decoration: _PriceTagDecoration(),
      child: FittedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Center(
            child: Text(
              '\$$price',
              style: const TextStyle(color: Colors.white, fontSize: 19),
            ),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  BoxDecoration _PriceTagDecoration() => const BoxDecoration(
      color: Colors.indigo,
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25), topRight: Radius.circular(25)));
}

class _ProductDetails extends StatelessWidget {
  const _ProductDetails({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.76,
      height: 70,
      decoration: _detailsDecoration(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            Text(subtitle,
                style: const TextStyle(color: Colors.white, fontSize: 15))
          ],
        ),
      ),
    );
  }

  BoxDecoration _detailsDecoration() => const BoxDecoration(
      color: Colors.indigo,
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25), topRight: Radius.circular(25)));
}

class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage({
    Key? key,
    required this.url,
  }) : super(key: key);
  final String url;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: SizedBox(
        width: double.infinity,
        height: 350,
        child: url != ''
            ? FadeInImage(
                placeholder: const AssetImage('assets/jar-loading.gif'),
                image: NetworkImage(url),
                fit: BoxFit.cover,
              )
            : Image.asset(
                'assets/no-image.png',
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
