import 'package:flutter/material.dart';
import '../../core/theme/cyberpunk_theme.dart';
import 'home_screen.dart';
import '../skills/skill_tree_screen.dart';
import '../shop/shop_screen.dart';
import '../inventory/inventory_screen.dart';
import '../leaderboard/leaderboard_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    SkillTreeScreen(),
    ShopScreen(),
    LeaderboardScreen(),
    InventoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 16, left: 40, right: 40),
        decoration: BoxDecoration(
          color: CyberColors.card.withAlpha(230),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: CyberColors.dimCyan.withAlpha(80), width: 0.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: Colors.transparent,
            selectedItemColor: CyberColors.neonCyan,
            unselectedItemColor: CyberColors.textDim,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            selectedFontSize: 10,
            unselectedFontSize: 10,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 22),
                activeIcon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: CyberColors.neonCyan,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.home, size: 16, color: CyberColors.bg),
                ),
                label: 'HOME',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.auto_awesome_outlined, size: 22),
                activeIcon: Icon(Icons.auto_awesome, size: 22, color: CyberColors.neonCyan),
                label: 'SKILLS',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.store_outlined, size: 22),
                activeIcon: Icon(Icons.store, size: 22, color: CyberColors.neonCyan),
                label: 'SHOP',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.emoji_events_outlined, size: 22),
                activeIcon: Icon(Icons.emoji_events, size: 22, color: CyberColors.neonCyan),
                label: 'RANK',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.work_outline, size: 22),
                activeIcon: Icon(Icons.work, size: 22, color: CyberColors.neonCyan),
                label: 'BAG',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
