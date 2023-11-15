import 'package:chamada_inteligente/styles/theme_colors.dart';
import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  final String label;
  final int maxLines;
  final bool obscureText;
  final String? initialValue;
  final void Function(String) onChanged;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const FormInput({
    super.key,
    required this.label,
    required this.onChanged,
    this.initialValue,
    this.obscureText = false,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Container(
            decoration: BoxDecoration(
                border: BorderDirectional(
                    bottom:
                        BorderSide(color: ThemeColors.formInput, width: 2.0))),
            child: TextFormField(
              initialValue: initialValue ?? "",
              obscureText: obscureText,
              keyboardType: keyboardType,
              validator: validator,
              onChanged: onChanged,
              maxLines: maxLines,
              onTapOutside: ((event) {
                FocusScope.of(context).unfocus();
              }),
              style: TextStyle(color: ThemeColors.text),
              cursorColor: ThemeColors.text,
              decoration: InputDecoration(
                border: InputBorder.none,
                label: Text(
                  label,
                  style: TextStyle(color: ThemeColors.formInput),
                ),
              ),
            )));
  }
}
