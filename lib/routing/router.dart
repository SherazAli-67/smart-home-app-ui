import 'package:go_router/go_router.dart';
import 'package:smart_home_app/screens/home_screen.dart';

GoRouter router = GoRouter(
    initialLocation: NamedRoutes.home.routeName,
    routes: [
      GoRoute(path: NamedRoutes.home.routeName, builder: (ctx, state)=> HomeScreen())
    ]);

enum NamedRoutes {
  home('/home');

  final String routeName;
  const NamedRoutes(this.routeName);
}