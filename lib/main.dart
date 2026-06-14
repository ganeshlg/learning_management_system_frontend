import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_strategy/url_strategy.dart';
import 'app/routing/app_router.dart';
import 'app/theme/app_theme.dart';
import 'domain/services/service_locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setPathUrlStrategy();
  
  setupServiceLocator();
  
  runApp(
    const ProviderScope(
      child: CivilEntrepreneurshipApp(),
    ),
  );
}

class CivilEntrepreneurshipApp extends StatelessWidget {
  const CivilEntrepreneurshipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Civil Entrepreneurship',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}