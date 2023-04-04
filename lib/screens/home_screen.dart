import 'package:flutter/material.dart';
import 'package:products_app/theme/theme.dart';
import 'package:provider/provider.dart';

import 'package:products_app/screens/screens.dart';
import 'package:products_app/widgets/widgets.dart';
import 'package:products_app/services/services.dart';
import 'package:products_app/models/models.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routeName = 'home';

  @override
  Widget build(BuildContext context) {
    final productsServive = Provider.of<ProductsService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final List<Product> products = productsServive.products;

    Future<void> onRefresh() async {
      await Future.delayed(const Duration(seconds: 2));
      products.clear();
      productsServive.loadProducts();
    }

    if (productsServive.isLoading) return const LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () async {
                authService.logOut();
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
              child: CircleAvatar(
                child: Text(authService.userInitials),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppTheme.primary,
        onRefresh: onRefresh,
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (BuildContext context, int index) {
            final product = products[index];
            return GestureDetector(
              child: ProductCard(product: product),
              onTap: () {
                productsServive.selectedProduct = products[index].copy();
                Navigator.pushNamed(context, ProductScreen.routeName);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            productsServive.selectedProduct = Product(
              avalible: false,
              name: '',
              price: 0,
              picture:
                  'https://consultix.radiantthemes.com/demo-nine/wp-content/themes/consultix/images/no-image-found-360x250.png',
            );
            Navigator.pushNamed(context, ProductScreen.routeName);
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          )),
    );
  }
}
