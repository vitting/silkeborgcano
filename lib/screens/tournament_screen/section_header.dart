import 'package:flutter/material.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return CustomText(data: title, size: CustomTextSize.m, textAlign: TextAlign.center);
  }
}
