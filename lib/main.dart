import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/services/weather_service.dart';
import 'core/services/location_service.dart';
import 'core/services/notification_service.dart';
import 'features/weather/presentation/providers/weather_provider.dart';
import 'features/location/presentation/providers/location_provider.dart';
import 'features/alerts/presentation/providers/alerts_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await WeatherService.initialize();
  await LocationService.initialize();
  await NotificationService.initialize();

  runApp(const ProviderScope(child: WeatherProApp()));
}

class WeatherProApp extends ConsumerWidget {
  const WeatherProApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
