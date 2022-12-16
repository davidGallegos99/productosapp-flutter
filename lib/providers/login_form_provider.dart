import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool _loading = false;

  get loading => _loading;

  set seLoading(bool val) {
    _loading = val;
    notifyListeners();
  }

  bool isValid() {
    return formKey.currentState?.validate() ?? false;
  }
}
