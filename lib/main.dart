import 'package:flutter/material.dart';
import 'package:productos_app/screens/register_screen.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/screens/splash_screen.dart';
import 'package:productos_app/services/auth_service.dart';
import 'package:productos_app/services/push_notification_service.dart';
import 'package:productos_app/services/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PushNotificationService.init();
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => ProductsService())
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    PushNotificationService.streamMessage.listen((event) {
      print(event);
      scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: Text(event),
        action: SnackBarAction(label: 'Cerrar', onPressed: () {}),
      ));
    });
  }

  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldKey,
      title: 'APProductos',
      initialRoute: 'splash',
      routes: {
        'splash': (_) => const SplashScreen(),
        'login': (_) => const LoginScreen(),
        'register': (_) => const RegisterScreen(),
        'home': (_) => const HomeScreen(),
        'product': (_) => const ProductScreen()
      },
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[300],
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.indigo),
          appBarTheme: const AppBarTheme(
              centerTitle: true, elevation: 0, color: Colors.indigo)),
    );
  }
}
