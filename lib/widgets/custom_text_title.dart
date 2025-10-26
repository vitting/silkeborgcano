import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silkeborgcano/widgets/custom_text.dart';

class CustomTextTitle extends StatelessWidget {
  final String title;
  const CustomTextTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return CustomText(title, fontFamily: GoogleFonts.inter().fontFamily, fontWeight: FontWeight.bold, size: CustomTextSize.xl);
  }
}
