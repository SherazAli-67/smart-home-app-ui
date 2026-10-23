import 'package:flutter/material.dart';
import 'package:smart_home_app/constants/string_const.dart';

class AirConditionScreen extends StatelessWidget {
  const AirConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(StringConst.airConditions)));
  }
}
