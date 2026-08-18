import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:juke/pages/check_screen.dart';
import 'package:juke/pages/home_screen.dart';
import 'package:juke/pages/print_screen.dart';
import 'package:juke/pages/repair_screen.dart';

const Color primaryColor = Color(0XFFC6491B);
const Color onPrimaryColor = Color(0XFF1B1712);
const Color secondaryColor = Color(0XFF1B1712);
const Color onSecondaryColor = Color(0XFFFFFFFF);
const Color errorColor = Color(0XFFDB3D3D);
const Color onErrorColor = Colors.black;
const Color surfaceColor = Color(0XFFEFE7D8);
const Color onSurfaceColor = Color(0XFF1B1712);

const antonFamily = 'Anton';
const jetBrainsMonoFamily = 'JetBrainsMono';
const headerTextSize = 50.0;
const subHeaderTextSize = 20.0;

// Define theme
var theme = ThemeData(
  useMaterial3: true,
  fontFamily: antonFamily,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: primaryColor,
    onPrimary: onPrimaryColor,
    secondary: secondaryColor,
    onSecondary: onSecondaryColor,
    tertiary: null,
    onTertiary: null,
    error: errorColor,
    onError: onErrorColor,
    surface: surfaceColor,
    onSurface: onSurfaceColor,
  ),
);

// Routes
const homeRoute = '/';
const checkRoute = '/check';
const repairRoute = '/repair';
const printRoute = '/print';

// Router
final GoRouter router = GoRouter(
  initialLocation: homeRoute,
  routes: <RouteBase>[
    GoRoute(
      path: homeRoute,
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: checkRoute,
      builder: (BuildContext context, GoRouterState state) {
        return const CheckScreen();
      },
    ),
    GoRoute(
      path: repairRoute,
      builder: (BuildContext context, GoRouterState state) {
        return const RepairScreen();
      },
    ),
    GoRoute(
      path: printRoute,
      builder: (BuildContext context, GoRouterState state) {
        return const PrintScreen();
      },
    ),
  ],
);

//ENV variables key definitions
const spotifyClientId = "CLIENT_ID";
const spotifyAndroidRedirectUrl = "ANDROID_REDIRECT_URL";
const spotifyWebRedirectUrl = "WEB_REDIRECT_URL";
