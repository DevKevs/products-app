import 'package:flutter/material.dart';
import 'package:products_app/models/models.dart';

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Product product;

  ProductFormProvider(this.product);

  updateAvailability(bool value) {
    product.avalible = value;
    notifyListeners();
  }

  bool isValidForm() {
    // print(formKey.currentState?.validate());
    return formKey.currentState?.validate() ?? false;
  }
}
