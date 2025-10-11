import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:silkeborgcano/standards/app_colors.dart';

enum CustomTextFormFieldBehavior { normal, number }

class CustomTextFormField extends StatefulWidget {
  final String? initialValue;
  final TextEditingController? controller;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onEditingComplete;
  final ValueChanged<String>? onTapOutside;
  final ValueChanged<String>? onChanged;
  final CustomTextFormFieldBehavior behavior;
  final String? errorText;

  const CustomTextFormField({
    super.key,
    this.initialValue,
    this.controller,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.onTapOutside,
    this.behavior = CustomTextFormFieldBehavior.normal,
    this.errorText,
    this.onChanged,
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
      textAlign: widget.behavior == CustomTextFormFieldBehavior.number ? TextAlign.center : TextAlign.start,
      inputFormatters: [if (widget.behavior == CustomTextFormFieldBehavior.number) FilteringTextInputFormatter.digitsOnly],
      keyboardType: widget.behavior == CustomTextFormFieldBehavior.number ? TextInputType.number : null,
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
        widget.onTapOutside?.call(controller.text);
      },
      maxLength: widget.behavior == CustomTextFormFieldBehavior.number ? 2 : null,
      maxLengthEnforcement: widget.behavior == CustomTextFormFieldBehavior.number ? MaxLengthEnforcement.enforced : null,
      autofocus: true,
      controller: controller,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.white, width: 2),
        ),
        errorText: widget.errorText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.textAndIcon, width: 2),
        ),
        counterText: widget.behavior == CustomTextFormFieldBehavior.number ? '' : null,
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
    );
  }
}
