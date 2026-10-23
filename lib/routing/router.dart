import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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
    GoRoute(path: NamedRoutes.airCondition.routeName, builder: (ctx, state) => const AirConditionScreen()),
    GoRoute(path: NamedRoutes.bedroomAr.routeName, builder: (ctx, state) => const BedroomArScreen()),
  ],
);

enum NamedRoutes {
  home('/home'),
  airCondition('/air-condition'),
  bedroomAr('/bedroom-ar');

  final String routeName;
  const NamedRoutes(this.routeName);
}
