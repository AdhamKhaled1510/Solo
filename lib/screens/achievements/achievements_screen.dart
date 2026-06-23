import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/achievement.dart';
import '../../providers/app_provider.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, app, _) {
        final achievements = app.achievements;
        final unlocked = achievements.where((a) => a.unlocked).length;
        final total = achievements.length;

        return Scaffold(
          appBar: AppBar(
            title: const Text('🏆 الإنجازات'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Center(
                  child: Text('$unlocked/$total', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Progress card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text('التقدم العام', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: total > 0 ? unlocked / total : 0,
                          minHeight: 12,
                          backgroundColor: Colors.grey.withAlpha(50),
                          valueColor: AlwaysStoppedAnimation(Colors.amber),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('$unlocked من $total إنجاز', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Category sections
              ...AchievementCategory.values.map((cat) {
                final catAchievements = achievements.where((a) => a.category == cat).toList();
                if (catAchievements.isEmpty) return const SizedBox();
                final catUnlocked = catAchievements.where((a) => a.unlocked).length;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(cat.label, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                          const Spacer(),
                          Text('$catUnlocked/${catAchievements.length}', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...catAchievements.map((a) => _AchievementCard(achievement: a)),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  const _AchievementCard({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final isUnlocked = achievement.unlocked;
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isUnlocked ? Colors.amber.withAlpha(10) : null,
        ),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isUnlocked ? Colors.amber.withAlpha(25) : Colors.grey.withAlpha(15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                isUnlocked ? achievement.emoji : '🔒',
                style: TextStyle(fontSize: isUnlocked ? 20 : 16),
              ),
            ),
          ),
          title: Text(
            achievement.title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isUnlocked ? null : Colors.grey,
            ),
          ),
          subtitle: Text(
            achievement.description,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          trailing: isUnlocked
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('+${achievement.xpReward} XP', style: TextStyle(fontSize: 10, color: Colors.blue)),
                  Text('+${achievement.coinReward} 🪙', style: TextStyle(fontSize: 10, color: Colors.amber)),
                ],
              )
            : null,
        ),
      ),
    );
  }
}
