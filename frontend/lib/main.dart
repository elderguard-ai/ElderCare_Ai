import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/navigation/app_navigator.dart';
import 'core/theme/app_theme.dart';
import 'screens/onboarding/animated_loading_screen.dart';
import 'services/api_config.dart';
import 'services/auth_session.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Saved server address and signed-in account, needed before the first screen decides where to go
  await Future.wait([ApiConfig.loadSavedServer(), AuthSession.load()]);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const ElderGuardApp());
}

class ElderGuardApp extends StatelessWidget {
  const ElderGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ElderGuard AI',
      navigatorKey: appNavigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AnimatedLoadingScreen(),
    );
  }
}
