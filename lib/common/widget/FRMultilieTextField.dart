import 'package:flutter/material.dart';

class FRMultilineTextField extends StatelessWidget {
  final String hintText;
  final bool isSecured;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final String initialValue;
  final TextEditingController textEditingController;
  final Color fillColor;

  const FRMultilineTextField(
      {this.hintText,
      this.isSecured,
      this.onChanged,
      this.keyboardType,
      this.initialValue,
      this.textEditingController,
      this.fillColor});

  @override
  Widget build(BuildContext context) {
    // var theme = Theme.of(context);
    return TextFormField(
      keyboardType: keyboardType,
      initialValue: initialValue,
      controller: textEditingController,
      minLines: 5, //Normal textInputField will be displayed
      maxLines: 50, // when user presses enter it will adapt to it
      decoration: new InputDecoration(
          hintText: hintText,
          // fillColor: fillColor ?? lightBackgroundColor,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 1)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 1),
          ),
          filled: true),
      onChanged: onChanged,
    );
  }
}
