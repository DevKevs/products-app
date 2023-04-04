// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:products_app/UI/input_decoration.dart';
import 'package:products_app/services/services.dart';
import 'package:products_app/widgets/widgets.dart';
import 'package:products_app/providers/providers.dart';
import 'package:products_app/theme/theme.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);
  static String routeName = 'product-form';

  @override
  Widget build(BuildContext context) {
    final productsServive = Provider.of<ProductsService>(context);
    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productsServive.selectedProduct),
      child: _ProductScreenBody(productsServive: productsServive),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    required this.productsServive,
  });

  final ProductsService productsServive;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    // final product = productForm.product;
    return Scaffold(
      body: SingleChildScrollView(
        // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(
                  url: productsServive.selectedProduct.picture,
                ),
                Positioned(
                  top: 40,
                  left: 25,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 25,
                  child: IconButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final PickedFile? pickedFile =
                          // ignore: deprecated_member_use
                          await picker.getImage(source: ImageSource.gallery);
                      if (pickedFile == null) {
                        print('no image');
                        return;
                      }

                      print('Image ${pickedFile.path}');

                      productsServive.updateSelectedPicture(pickedFile.path);
                    },
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ),
              ],
            ),
            const _ProductForm(),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: productsServive.isSaving
            ? null
            : () async {
                if (!productForm.isValidForm()) return;

                final String? imageUrl = await productsServive.uploadImage();

                try {
                  if (imageUrl != null) productForm.product.picture = imageUrl;
                  await productsServive.saveOrUpdate(productForm.product).then(
                      (value) => NotificationService.showSnackBar(
                          'Operation succesfully'));
                } catch (e) {
                  return;
                }
              },
        child: productsServive.isSaving
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Icon(
                Icons.save,
                color: Colors.white,
              ),
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm();

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _formDecoration(),
        child: Form(
          key: productForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                initialValue: product.name,
                onChanged: (value) => product.name = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Product name is required';
                  }
                  return null;
                },
                decoration: InputDecorations.loginDecoration(
                  label: 'Product:',
                  placeholder: 'Product name',
                  icon: Icons.shopify_sharp,
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                initialValue: product.price.toString(),
                onChanged: (value) {
                  if (double.tryParse(value) == null) {
                    product.price = 0;
                  } else {
                    product.price = double.parse(value);
                  }
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^(\d+)?\.?\d{0,2}'),
                  )
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecorations.loginDecoration(
                  label: 'Price:',
                  placeholder: '\$149.99',
                  icon: Icons.attach_money_outlined,
                ),
              ),
              const SizedBox(height: 30),
              SwitchListTile.adaptive(
                title: const Text(
                  'Avalible',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                activeColor: AppTheme.primary,
                inactiveTrackColor: Colors.grey,
                value: product.avalible,
                onChanged: productForm.updateAvailability,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _formDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.only(
        bottomRight: Radius.circular(25),
        bottomLeft: Radius.circular(25),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          offset: const Offset(0, 6),
          blurRadius: 10,
        ),
      ],
    );
  }
}
