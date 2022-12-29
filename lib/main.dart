import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meetmeyou_web/constants/dimension_constants.dart';
import 'package:meetmeyou_web/constants/route_constants.dart';
import 'package:meetmeyou_web/constants/string_constants.dart';
import 'package:meetmeyou_web/helper/shared_pref.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/provider/base_provider.dart';
import 'package:meetmeyou_web/provider/login_invited_provider.dart';
import 'package:meetmeyou_web/services/auth/auth.dart';
import 'package:meetmeyou_web/services/mmy/mmy.dart';
import 'package:meetmeyou_web/view/edit_profile_screen.dart';
import 'package:meetmeyou_web/view/event_attending_multi_date.dart';
import 'package:meetmeyou_web/view/event_attending_screen.dart';
import 'package:meetmeyou_web/view/event_detail_screen.dart';
import 'package:meetmeyou_web/view/event_gallery_page.dart';
import 'package:meetmeyou_web/view/event_gallery_photo_view_page.dart';
import 'package:meetmeyou_web/view/home_page.dart';
import 'package:meetmeyou_web/view/login_invited_screen.dart';
import 'package:meetmeyou_web/view/video_player.dart' as video_player;
import 'package:meetmeyou_web/view/view_profile_screen.dart';
import 'package:meetmeyou_web/widgets/error_screen.dart';
import 'package:meetmeyou_web/widgets/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  // Disable persistence on web platforms
  await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  SharedPreference.prefs = await SharedPreferences.getInstance();
  setupLocator();
  // check if is running on Web
  if (kIsWeb) {
    // initialiaze the facebook javascript SDK
    await FacebookAuth.i.webInitialize(
      appId: "1321275768236042",
      cookie: true,
      xfbml: true,
      version: "v13.0",
    );
  }
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

AuthBase auth = locator<AuthBase>();

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final LoginInfo _loginInfo = LoginInfo();

  late final GoRouter _router = GoRouter(
    // turn off the # in the URLs on the web
    urlPathStrategy: UrlPathStrategy.path,
    routes: <GoRoute>[
      GoRoute(
        path: "/",
        // name: "login",
        builder: (BuildContext context, GoRouterState state) {
          return HomePage();
        },
      ),
      GoRoute(
        path: RouteConstants.loginInvitedScreen,
        // name: "login",
        builder: (BuildContext context, GoRouterState state) {
          return LoginInvitedScreen(eid: state.queryParams['eid'].toString());
        },
      ),
      GoRoute(
        path: RouteConstants.eventDetailScreen,
      //    name: "eventDetailLocation",
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
      GoRoute(
        path: RouteConstants.eventGalleryPage,
        builder: (BuildContext context, GoRouterState state) {
          return EventGalleryPage();
        },
      ),
      GoRoute(
        path: RouteConstants.eventAttendingScreen,
        builder: (BuildContext context, GoRouterState state) {
          return EventAttendingScreen();
        },
      ),
      GoRoute(
        path: RouteConstants.eventGalleryPhotoViewPage,
        builder: (BuildContext context, GoRouterState state) {
          return EventGalleryPhotoViewPage();
        },
      ),
      GoRoute(
        path: RouteConstants.videoPlayer,
        builder: (BuildContext context, GoRouterState state) {
          return video_player.VideoPlayer();
        },
      ),
      GoRoute(
        path: RouteConstants.eventAttendingMultiDateScreen,
        builder: (BuildContext context, GoRouterState state) {
          return EventAttendingMultiDateScreen();
        },
      ),
      // GoRoute(
      //   path: RouteConstants.homePage,
      //   builder: (BuildContext context, GoRouterState state) {
      //     return HomePage();
      //   },
      // ),
    ],
      errorBuilder: (context, state) => ErrorScreen(state.error!),
    redirect: (GoRouterState state){
      var loc = state.location.toString().split("?eid=");
      SharedPreference.prefs!.setString(SharedPreference.eventId, loc.length == 2 ? loc[1] : (SharedPreference.prefs?.getString(SharedPreference.eventId) ?? "null"));
      print(loc);
      // final loginLocation = state.namedLocation("login");
     //  final eventDetailLocation = state.namedLocation("eventDetailLocation");

       final isLoggedIn = _loginInfo.loginState;


       final isGoingToEventDetail = state.subloc == RouteConstants.eventDetailScreen;

       if(isLoggedIn){
         // if(auth.currentUser != null){
         //   if(auth.currentUser!.email == null){
         //     return "${RouteConstants.loginInvitedScreen}?eid=${loc.length == 2 ? loc[1] : (SharedPreference.prefs?.getString(SharedPreference.eventId) ?? "null")}";
         //   } else{
         //     return isGoingToEventDetail ? null : RouteConstants.eventDetailScreen;
         //   }
         // } else{
         //   return isGoingToEventDetail ? null : RouteConstants.eventDetailScreen;
         // }

         return isGoingToEventDetail ? null : RouteConstants.eventDetailScreen;
       }

       // if(isGoingToEventDetail){
       //  _loginInfo.loginState = true;
       // }

       final isLoggedOut = _loginInfo.logoutState;
       // final isOnEventDetail = state.location == RouteConstants.eventDetailScreen;
       // final isOnViewProfile = state.location == RouteConstants.viewProfileScreen;
       // final isOnEditProfile = state.location == RouteConstants.editProfileScreen;
       // final isOnGalleryPage = state.location == RouteConstants.eventGalleryPage;
       // final isOnGalleryView = state.location == RouteConstants.eventGalleryPhotoViewPage;
       // final isOnCheckResponses = state.location == RouteConstants.eventAttendingScreen;

      final isGoingToLogin = state.subloc == RouteConstants.loginInvitedScreen;

         if(isLoggedOut) {
         //  _loginInfo.setLoginState(false);
         //  return (isOnEventDetail || isOnViewProfile || isOnEditProfile || isOnGalleryPage || isOnGalleryView || isOnCheckResponses) ?
           return isGoingToLogin ? null : "${RouteConstants.loginInvitedScreen}?eid=${loc.length == 2 ? loc[1] : (SharedPreference.prefs?.getString(SharedPreference.eventId) ?? "null")}";
         }


      // print(auth.currentUser);
      // no need to redirect at all
      return null;


    },
    // changes on the listenable will cause the router to refresh it's route
    refreshListenable: _loginInfo,

  );
  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return  ChangeNotifierProvider<LoginInfo>.value(
      value: _loginInfo,
      child:  ScreenUtilInit(
          designSize:  const Size(DimensionConstants.d360, DimensionConstants.d690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) =>
         MaterialApp.router(
           onGenerateTitle: (BuildContext context) {
             return "MeetMeYou";
           },
                routeInformationProvider: _router.routeInformationProvider,
                routeInformationParser: _router.routeInformationParser,
                routerDelegate: _router.routerDelegate,
                debugShowCheckedModeBanner: false,
                title: StringConstants.appName,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                theme: ThemeData(
                  primarySwatch: color,
                ),
              )

      ),
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
}

/// The login information.
class LoginInfo extends ChangeNotifier {
  bool loginState = false;
  bool logoutState = false;

   setLoginState(bool state) {
    SharedPreference.prefs!.setBool(SharedPreference.isLogin, state);
    loginState = state;
   // print(loginState);
    notifyListeners();
  }

  Future<void> onAppStart() async {
    loginState = SharedPreference.prefs!.getBool(SharedPreference.isLogin) ?? false;
    logoutState = SharedPreference.prefs!.getBool(SharedPreference.isLogout) ?? false;
   // print(loginState);
    notifyListeners();
  }


  setLogoutState(bool state) {
    SharedPreference.prefs!.setBool(SharedPreference.isLogout, state);
    logoutState = state;
    notifyListeners();
  }
}