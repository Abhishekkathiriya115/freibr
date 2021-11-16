import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:international_phone_input/international_phone_input.dart';

class FRPhoneTextField extends StatelessWidget {
  final TextEditingController phoneTextController;
  final Function onPhoneNumberChange;

  const FRPhoneTextField({
    Key key,
    @required this.phoneTextController,
    @required this.onPhoneNumberChange,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 9.5.h,
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
      decoration: BoxDecoration(
        color: Get.theme.backgroundColor.withOpacity(0.6),
        border: Border.all(width: 1.0), // set border width
        borderRadius: BorderRadius.all(
            Radius.circular(10.0)), // set rounded corner radius
      ),
      child: InternationalPhoneInput(
        decoration:
            InputDecoration.collapsed(hintText: 'Phone Number').copyWith(
          contentPadding: const EdgeInsets.only(left: 10.0),
        ),
        onPhoneNumberChange: (String phoneNumber,
                String internationalizedPhoneNumber, String isoCode) =>
            onPhoneNumberChange,
        // initialPhoneNumber: phoneNumber,
        initialSelection: '+91',
        // enabledCountries: ['+233', '+1'],
        showCountryCodes: true,
        showCountryFlags: true,
      ),
    );
  }
}
