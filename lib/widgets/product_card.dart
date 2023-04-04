import 'package:flutter/material.dart';
import 'package:products_app/models/models.dart';
import 'package:products_app/theme/theme.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(top: 30, bottom: 40),
        width: double.infinity,
        height: 350,
        decoration: _productCardDecoration(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _BackgoundImage(product),
            _ProductDetails(product),
            Positioned(
              top: 0,
              right: 0,
              child: _PriceTag(product),
            ),
            if (!product.avalible)
              const Positioned(
                top: 0,
                left: 0,
                child: _NotAvalibleTag(),
              )
          ],
        ),
      ),
    );
  }

  BoxDecoration _productCardDecoration() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 6),
            blurRadius: 10,
          ),
        ]);
  }
}

class _NotAvalibleTag extends StatelessWidget {
  const _NotAvalibleTag();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 125,
      height: 70,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
      ),
      child: const FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Not Avalible',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {
  const _PriceTag(this.product);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 70,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '\$${product.price}',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  const _ProductDetails(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: _detailsBoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                product.id ?? 'no-id',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _detailsBoxDecoration() {
    return const BoxDecoration(
      color: AppTheme.primary,
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
    );
  }
}

class _BackgoundImage extends StatelessWidget {
  const _BackgoundImage(this.product);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: SizedBox(
        width: double.infinity,
        height: 350,
        child: FadeInImage(
          fit: BoxFit.cover,
          placeholder: const AssetImage('lib/assets/jar-loading.gif'),
          image: NetworkImage(product.productImage),
        ),
      ),
    );
  }
}
