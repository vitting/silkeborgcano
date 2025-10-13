import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:silkeborgcano/standards/app_sizes.dart';

class ListViewSeparator extends StatelessWidget {
  const ListViewSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Gap(AppSizes.xs);
  }
}
