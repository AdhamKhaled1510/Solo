import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'providers/app_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/home/home_shell.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/quests/quests_screen.dart';
import 'screens/garden/garden_screen.dart';
import 'screens/shop/shop_screen.dart';
import 'screens/stats/stats_screen.dart';
import 'screens/avatar/avatar_screen.dart';
import 'screens/skills/skill_tree_screen.dart';
import 'screens/inventory/inventory_screen.dart';
import 'screens/boss/boss_fight_screen.dart';
import 'screens/leaderboard/leaderboard_screen.dart';
import 'screens/achievements/achievements_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/rooms/rooms_screen.dart';
import 'screens/soundscapes/soundscapes_screen.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    print('Firebase init failed (offline mode): $e');
  }
  await StorageService.init();
  runApp(const MyStudyApp());
}

class MyStudyApp extends StatelessWidget {
  const MyStudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          final p = AppProvider();
          p.init();
          return p;
        }),
        ChangeNotifierProvider(create: (_) => AuthProvider()..init()),
      ],
      child: Consumer2<AppProvider, AuthProvider>(
        builder: (context, app, auth, _) {
          final isDark = app.isLoggedIn ? app.user.isDarkMode : false;
          return MaterialApp(
            title: 'Solo',
            debugShowCheckedModeBanner: false,
            theme: isDark ? AppTheme.dark : AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            home: const SplashScreen(),
            routes: {
              '/home': (context) => const HomeShell(),
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/garden': (context) => const GardenScreen(),
              '/quests': (context) => const QuestsScreen(),
              '/skills': (context) => const SkillTreeScreen(),
              '/avatar': (context) => const AvatarScreen(),
              '/inventory': (context) => const InventoryScreen(),
              '/boss': (context) => const BossFightScreen(),
              '/achievements': (context) => const AchievementsScreen(),
            '/leaderboard': (context) => const LeaderboardScreen(),
              '/shop': (context) => const ShopScreen(),
              '/stats': (context) => const StatsScreen(),
              '/settings': (context) => const SettingsScreen(),
            '/rooms': (context) => const RoomsScreen(),
            '/soundscapes': (context) => const SoundscapesScreen(),
            },
            builder: (context, child) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
