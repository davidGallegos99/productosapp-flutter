import 'dart:io';

import 'package:flutter/material.dart';

class BackgroundCard extends StatelessWidget {
  const BackgroundCard({
    Key? key,
    required this.image,
    this.takenImage,
  }) : super(key: key);

  final String image;
  final File? takenImage;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(35), topRight: Radius.circular(35)),
      child: Container(
        color: Colors.black,
        height: MediaQuery.of(context).size.height * 0.5,
        width: double.infinity,
        child: image.isNotEmpty && takenImage == null
            ? Opacity(
                opacity: 0.75,
                child: FadeInImage(
                    fit: BoxFit.cover,
                    placeholder: const AssetImage('assets/no-image.png'),
                    image: NetworkImage(image)),
              )
            : image.isEmpty && takenImage == null
                ? Opacity(
                    opacity: 0.8,
                    child: Image.asset(
                      'assets/no-image.png',
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.file(takenImage!, fit: BoxFit.fill),
      ),
    );
  }
}
