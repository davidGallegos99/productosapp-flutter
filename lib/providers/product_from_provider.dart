import 'package:flutter/cupertino.dart';

import '../models/product.dart';

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Product product;

  updateavailability(bool val) {
    product.available = val;
    notifyListeners();
  }

  ProductFormProvider(this.product);

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
