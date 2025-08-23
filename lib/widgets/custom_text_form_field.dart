import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String? initialValue;
  final TextEditingController? controller;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onEditingComplete;
  const CustomTextFormField({
    super.key,
    this.initialValue,
    this.controller,
    this.onFieldSubmitted,
    this.onEditingComplete,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      controller = widget.controller!;

      if (widget.initialValue != null) {
        controller.text = widget.initialValue!;
      }

      return;
    }

    controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      controller: controller,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),

        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
    );
  }
}
