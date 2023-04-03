import 'package:event_app/application/sign_up_business_logic.dart';
import 'package:event_app/presentation/views/auth/log_in/log_in_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'application/app_state.dart';
import 'application/error_string.dart';
import 'application/user_provider.dart';
import 'infrastructure/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserProvider()),
    ChangeNotifierProvider(create: (context) => ErrorString()),
    ChangeNotifierProvider(create: (context) => AppState()),
    ChangeNotifierProvider(create: (context) => SignUpBusinessLogic()),
    ChangeNotifierProvider(
      create: (_) => AuthServices.instance(),
    ),
    StreamProvider(
      create: (context) => context.read<AuthServices>().authState,
      initialData: AuthServices.instance().authState,
    )
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Event App",
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      home: const LogInView(),
    );
  }
}
