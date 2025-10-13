import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silkeborgcano/screens/home_screen/home_screen.dart';
import 'package:silkeborgcano/standards/app_colors.dart';
import 'package:silkeborgcano/widgets/screen_scaffold.dart';

class ColorsScreen extends StatelessWidget {
  static const String routerPath = "/colors";
  const ColorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      onHomeTap: () {
        context.goNamed(HomeScreen.routerPath);
      },
      body: ListView(
        children: [
          Container(height: 100, color: AppColors.sunnySand, child: Text('sunnySand')),
          Container(height: 100, color: AppColors.oceanWave, child: Text('oceanWave')),
          Container(height: 100, color: AppColors.deepSea, child: Text('deepSea')),
          Container(height: 100, color: AppColors.palmGreen, child: Text('palmGreen')),
          Container(height: 100, color: AppColors.driftwoodGray, child: Text('driftwoodGray')),
          Container(height: 100, color: AppColors.clearSky, child: Text('clearSky')),
          Container(height: 100, color: AppColors.sunburstYellow, child: Text('sunburstYellow')),
          Container(height: 100, color: AppColors.tropicalSunset, child: Text('tropicalSunset')),
          Container(height: 100, color: AppColors.volleyballOrange, child: Text('volleyballOrange')),
          Container(height: 100, color: AppColors.coralPink, child: Text('coralPink')),
        ],
      ),
    );
  }
}
