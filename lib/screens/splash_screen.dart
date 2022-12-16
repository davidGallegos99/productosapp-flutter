import 'package:flutter/material.dart';
import 'package:productos_app/services/auth_service.dart';
import 'package:productos_app/services/push_notification_service.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthService>(context);
    return Center(
      child: Scaffold(
          body: FutureBuilder<String>(
              future: provider.verifyToken(),
              builder: (BuildContext context, AsyncSnapshot<String> token) {
                if (token.connectionState == ConnectionState.done) {
                  if (token.data == '') {
                    Future.microtask((() {
                      Navigator.pushReplacementNamed(context, 'login');
                    }));
                  } else {
                    Future.microtask((() {
                      Navigator.pushReplacementNamed(context, 'home');
                    }));
                  }
                }
                return const Center(child: Text('Espere...'));
              })),
    );
  }
}
