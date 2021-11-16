import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class FRPasswordField extends StatefulWidget {
  const FRPasswordField({
    this.key,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.textEditingController,
    this.autovalidateMode,
    this.onChanged,
    this.keyboardType,
    this.maxLenth,
  });

  final Key key;
  final String hintText;
  final String labelText;
  final String helperText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;
  final TextEditingController textEditingController;
  final AutovalidateMode autovalidateMode;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final int maxLenth;

  @override
  _PasswordFieldState createState() => new _PasswordFieldState();
}

class _PasswordFieldState extends State<FRPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Theme(
        data: Theme.of(context).copyWith(
          // override textfield's icon color when selected
          accentColor: Theme.of(context).iconTheme.color,
        ),
        child: new TextFormField(
          keyboardType: widget.keyboardType,
          key: widget.key,
          obscureText: _obscureText,
          maxLength: widget.maxLenth ?? 15,
          onSaved: widget.onSaved,
          validator: widget.validator,
          onChanged: widget.onChanged,
          autovalidateMode: widget.autovalidateMode,
          controller: widget.textEditingController,
          onFieldSubmitted: widget.onFieldSubmitted,
          style: Get.theme.textTheme.bodyText1,
          decoration: new InputDecoration(
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
            filled: true,
            hintText: widget.hintText,
            hintStyle: Get.theme.textTheme.bodyText1.copyWith(fontSize: 11.sp),
            suffixIcon: new GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: new Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off),
            ),
          ),
        ),
      ),
    );
  }
}
