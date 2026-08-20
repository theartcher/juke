import 'package:flutter/material.dart';
import 'package:juke/constants.dart';

class CustomFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final ValueChanged<String>? onChanged;

  const CustomFormField({
    super.key,
    this.controller,
    this.labelText,
    this.onChanged,
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      style: TextStyle(
        fontFamily: jetBrainsMonoFamily,
        fontSize: 16,
        color: secondaryColor,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: secondaryColor, width: 2.0),
          borderRadius: BorderRadius.zero,
        ),
        labelText: widget.labelText?.toUpperCase(),
        labelStyle: TextStyle(
          fontFamily: jetBrainsMonoFamily,
          fontSize: 14,
          color: secondaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
