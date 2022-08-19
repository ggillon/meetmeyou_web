import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:meetmeyou_web/provider/login_invited_provider.dart';
import 'package:meetmeyou_web/services/auth/auth.dart';
import 'package:meetmeyou_web/services/mmy/mmy.dart';

GetIt locator = GetIt.instance;

void setupLocator(){
  locator.registerLazySingleton<AuthBase>(() => Auth());
  locator.registerFactoryParam<MMYEngine,User,void>((param1, param2) => MMY(param1));
  locator.registerFactory<LoginInvitedProvider>(() => LoginInvitedProvider());

}