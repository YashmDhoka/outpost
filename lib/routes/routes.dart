import 'package:go_router/go_router.dart' show GoRouter, GoRoute;
import 'package:next_gen_ui/title_screen/title_screen.dart';

import '../about_page/about_page.dart' show AboutPage;
import '../rive_animations/rive_animations.dart' show RiveAnimations;

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => TitleScreen()),
    GoRoute(path: '/about', builder: (context, state) => AboutPage()),
    GoRoute(
      path: '/riveAnimations',
      builder: (context, state) => RiveAnimations(),
    ),
  ],
);
