import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    Key? key,
    required this.labelText,
    required this.type,
    required this.initialValue,
    required this.onChanged,
    this.validators,
    this.formatter,
  }) : super(key: key);

  final String labelText;
  final TextInputType type;
  final String initialValue;
  final Function onChanged;
  final Function? validators;
  final TextInputFormatter? formatter;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: initialValue,
      inputFormatters: formatter != null ? [formatter!] : null,
      keyboardType: type,
      onChanged: (val) {
        onChanged(val);
      },
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.grey)),
        label: Text(
          labelText,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
      validator: (val) {
        if (validators != null) {
          return validators!(val);
        }
        return null;
      },
    );
  }
}
