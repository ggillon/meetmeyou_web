import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meetmeyou_web/constants/route_constants.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen(this.error, {Key? key}) : super(key: key);
  final Exception error;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('"Page Not Found"')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SelectableText(error.toString()),
          TextButton(
            onPressed: () => context.go(RouteConstants.loginInvitedScreen),
            child: const Text('Home'),
          ),
        ],
      ),
    ),
  );
}