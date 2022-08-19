import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meetmeyou_web/constants/dimension_constants.dart';
import 'package:meetmeyou_web/constants/route_constants.dart';
import 'package:meetmeyou_web/constants/string_constants.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/services/auth/auth.dart';
import 'package:meetmeyou_web/view/edit_profile_screen.dart';
import 'package:meetmeyou_web/view/event_detail_screen.dart';
import 'package:meetmeyou_web/view/login_invited_screen.dart';
import 'package:meetmeyou_web/view/view_profile_screen.dart';
import 'package:meetmeyou_web/widgets/error_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDvzw0R7LFzNBIICzpiNadfxNveFtvOT5E",
        authDomain: "meetmeyou-9fd90.firebaseapp.com",
        projectId: "meetmeyou-9fd90",
        storageBucket: "meetmeyou-9fd90.appspot.com",
        messagingSenderId: "119476151911",
        appId: "1:119476151911:web:b7ed0fe79c87a4df7656c2",
        measurementId: "G-QL48PVQ1CZ"
    ),
  );
  await EasyLocalization.ensureInitialized();
  setupLocator();
  runApp(EasyLocalization(
    supportedLocales: const [
      Locale('en'),
    ],
    path: 'langs',
    fallbackLocale: const Locale('en'),
    child: Provider<AuthBase>(
        create: (_) => Auth(),
        child: MyApp()),
  ));

}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
       designSize:  const Size(DimensionConstants.d360, DimensionConstants.d690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: StringConstants.appName,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: ThemeData(
            primarySwatch: color,
          ),
          routeInformationProvider: _router.routeInformationProvider,
          routeInformationParser: _router.routeInformationParser,
          routerDelegate: _router.routerDelegate,
        );
      },
    );
  }

  MaterialColor color = const MaterialColor(0xFF00B9A7, <int, Color>{
    50: Color(0xFF00B9A7),
    100: Color(0xFF00B9A7),
    200: Color(0xFF00B9A7),
    300: Color(0xFF00B9A7),
    400: Color(0xFF00B9A7),
    500: Color(0xFF00B9A7),
    600: Color(0xFF00B9A7),
    700: Color(0xFF00B9A7),
    800: Color(0xFF00B9A7),
    900: Color(0xFF00B9A7),
  });

  final GoRouter _router = GoRouter(
    // turn off the # in the URLs on the web
    urlPathStrategy: UrlPathStrategy.path,

    routes: <GoRoute>[
      GoRoute(
        path: "/",
        builder: (BuildContext context, GoRouterState state) {
          return LoginInvitedScreen();
        },
      ),
      GoRoute(
        path: RouteConstants.eventDetailScreen,
        builder: (BuildContext context, GoRouterState state) {
          return EventDetailScreen();
        },
      ),
      GoRoute(
        path: RouteConstants.viewProfileScreen,
        builder: (BuildContext context, GoRouterState state) {
          return ViewProfileScreen();
        },
      ),
      GoRoute(
        path: RouteConstants.editProfileScreen,
        builder: (BuildContext context, GoRouterState state) {
          return EditProfileScreen();
        },
      ),
    ],
    errorBuilder: (context, state) => ErrorScreen(state.error!),
  );
}
