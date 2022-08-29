import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meetmeyou_web/constants/route_constants.dart';
import 'package:meetmeyou_web/helper/shared_pref.dart';

import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({ Key? key }) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    onStartUp();
    super.initState();
  }

  void onStartUp() {
    SharedPreference.prefs!.setBool(SharedPreference.isLogin, false);
    Future.delayed(Duration(milliseconds: 100), (){
      //context.go("${RouteConstants.loginInvitedScreen}?eid=ePec-pXgm");
      context.go(RouteConstants.homePage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MEET ME YOU"),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}