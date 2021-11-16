import 'package:flutter/material.dart';
import 'package:freibr/util/styles.dart';

class FRTextField extends StatelessWidget {
  final String hintText;
  final bool isSecured;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final String initialValue;
  final Key key;
  final FormFieldValidator<String> validator;
  final AutovalidateMode autovalidateMode;
  final TextEditingController textEditingController;
  final Color fillColor;
  final Widget suffixIcon;
  final Widget prefixIcon;
  final double borderRadius;
  final double height;
  final int maxLines;
  final bool enabled;
  final ValueChanged<String> onFieldSubmitted;

  const FRTextField(
      {this.hintText,
      this.prefixIcon,
      this.isSecured = false,
      this.onChanged,
      this.keyboardType,
      this.initialValue,
      this.key,
      this.validator,
      this.autovalidateMode,
      this.textEditingController,
      this.fillColor,
      this.suffixIcon,
      this.borderRadius = 5,
      this.height = 60,
      this.enabled = true,
      this.onFieldSubmitted,
      this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    // var theme = Theme.of(context);
    return Container(
      height: height,
      child: Theme(
        data: Theme.of(context).copyWith(
          // override textfield's icon color when selected
          accentColor: Theme.of(context).iconTheme.color,
        ),
        child: TextFormField(
          obscureText: isSecured,
          maxLines: maxLines,
          enabled: enabled,
          keyboardType: keyboardType,
          initialValue: initialValue,
          onFieldSubmitted: onFieldSubmitted,
          key: key,
          decoration: textFieldDecoration(
              hintText: hintText,
              suffixIcon: prefixIcon,
              fillColor: this.fillColor,
              prefixIcon: suffixIcon,
              borderRadius: borderRadius),
          onChanged: onChanged,
          validator: validator,
          autovalidateMode: autovalidateMode,
          controller: textEditingController,
        ),
      ),
    );
  }
}
