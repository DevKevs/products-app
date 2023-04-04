import 'dart:io';

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({this.url, super.key});
  final String? url;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
      child: Container(
        width: double.infinity,
        height: size.height * 0.45,
        decoration: _imageDecoration(),
        child: Opacity(
          opacity: 0.85,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(45),
              topRight: Radius.circular(45),
            ),
            child: url!.startsWith('http')
                ? FadeInImage(
                    fit: BoxFit.cover,
                    placeholder: const AssetImage('lib/assets/jar-loading.gif'),
                    image: NetworkImage(url!),
                  )
                : Image.file(
                    File(url!),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _imageDecoration() {
    return const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45),
          topRight: Radius.circular(45),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 6),
            blurRadius: 10,
          ),
        ]);
  }
}
