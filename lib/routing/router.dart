import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_home_app/constants/number_constant.dart';
import 'package:smart_home_app/providers/air_condition_provider.dart';
import 'package:smart_home_app/providers/bedroom_ar_provider.dart';
import 'package:smart_home_app/providers/home_provider.dart';
import 'package:smart_home_app/screens/air_condition_screen.dart';
import 'package:smart_home_app/screens/bedroom_ar_screen.dart';
import 'package:smart_home_app/screens/home_screen.dart';

GoRouter router = GoRouter(
  initialLocation: NamedRoutes.home.routeName,
  routes: [
    GoRoute(
      path: NamedRoutes.home.routeName,
      builder: (ctx, state) => ChangeNotifierProvider(create: (_) => HomeProvider(), child: const HomeScreen()),
    ),
    GoRoute(
      path: NamedRoutes.airCondition.routeName,
      builder: (ctx, state) =>
          ChangeNotifierProvider(create: (_) => AirConditionProvider(), child: const AirConditionScreen()),
    ),
    GoRoute(
      path: NamedRoutes.bedroomAr.routeName,
      pageBuilder: (ctx, state) => CustomTransitionPage(
        key: state.pageKey,
        transitionDuration: NumberConstant.animNormal,
        reverseTransitionDuration: NumberConstant.animNormal,
        child: ChangeNotifierProvider(
          create: (_) => BedroomArProvider(),
          child: const BedroomArScreen(),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            child: child,
          );
        },
      ),
    ),
  ],
);

enum NamedRoutes {
  home('/home'),
  airCondition('/air-condition'),
  bedroomAr('/bedroom-ar');

  final String routeName;
  const NamedRoutes(this.routeName);
}
