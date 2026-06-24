import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../../core/theme/clean_theme.dart';
import '../../core/widgets/clean_widgets.dart';
import '../../providers/app_provider.dart';
import '../../models/quest_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: AppColors.bg,
        statusBarColor: Colors.transparent,
      ),
      child: Consumer<AppProvider>(
        builder: (context, app, _) {
          final user = app.user;
          return Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(child: Text('S', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                  ),
                  const SizedBox(width: 8),
                  const Text('Solo'),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Row(
                    children: [
                      BadgeWidget(text: '🪙 ${user.coins}', color: AppColors.coinGold),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _showQuickMenu(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.cardLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.grid_view_rounded, color: AppColors.textSecondary, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome + Level card
                  GlassCard(
                    child: Row(
                      children: [
                        LevelHexWidget(level: user.level),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'مرحبًا ${user.name.isNotEmpty ? user.name : 'يا بطل'} 👋',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                              ),
                              const SizedBox(height: 6),
                              XpBar(progress: user.levelProgress),
                              const SizedBox(height: 4),
                              Text(
                                '${user.xp} / ${user.xpForNextLevel} XP',
                                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quick Stats Row
                  Row(
                    children: [
                      Expanded(child: StatCard(label: 'أيام متتالية', value: '${user.streakDays}', icon: Icons.local_fire_department, color: AppColors.streakOrange)),
                      const SizedBox(width: 8),
                      Expanded(child: StatCard(label: 'عملات', value: '${user.coins}', icon: Icons.monetization_on, color: AppColors.coinGold)),
                      const SizedBox(width: 8),
                      Expanded(child: StatCard(label: 'أشجار', value: '${user.totalTreesPlanted}', icon: Icons.park, color: AppColors.success)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: StatCard(label: 'دقيقة تركيز', value: '${user.totalFocusMinutes}', icon: Icons.timer, color: AppColors.primary)),
                      const SizedBox(width: 8),
                      Expanded(child: StatCard(label: 'مهام منجزة', value: '${user.completedTasks}', icon: Icons.checklist, color: AppColors.purple)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Daily Quests
                  SectionHeader(title: 'المهام اليومية', trailing: '${app.dailyQuests.where((q) => q.status != QuestStatus.active).length}/${app.dailyQuests.length}'),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: app.dailyQuests.length.clamp(0, 4),
                    itemBuilder: (context, index) {
                      if (index >= app.dailyQuests.length) return const SizedBox();
                      final q = app.dailyQuests[index];
                      return QuestCard(
                        title: q.title,
                        subtitle: q.description,
                        xp: q.xpReward,
                        completed: q.status != QuestStatus.active,
                        color: q.status != QuestStatus.active ? AppColors.success : AppColors.primary,
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Story Quest
                  if (app.quests.where((q) => q.type == QuestType.story).isNotEmpty)
                    StoryProgressCard(
                      title: 'المهمة الأسطورية',
                      subtitle: app.quests.firstWhere((q) => q.type == QuestType.story).title,
                      progress: app.quests.firstWhere((q) => q.type == QuestType.story).progress,
                      percentLabel: '${(app.quests.firstWhere((q) => q.type == QuestType.story).progress * 100).toInt()}%',
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showQuickMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textDim, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            const Text('القائمة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                _menuItem(context, Icons.mosque, 'العبادات', '/habits'),
                _menuItem(context, Icons.checklist, 'المهام', '/tasks'),
                _menuItem(context, Icons.park, 'الغابة', '/garden'),
                _menuItem(context, Icons.person, 'الشخصية', '/avatar'),
                _menuItem(context, Icons.emoji_events, 'الإنجازات', '/achievements'),
                _menuItem(context, Icons.bar_chart, 'الإحصائيات', '/stats'),
                _menuItem(context, Icons.timer, 'المؤقت', '/timer'),
                _menuItem(context, Icons.groups, 'الغرف', '/rooms'),
                _menuItem(context, Icons.music_note, 'المؤثرات', '/soundscapes'),
                _menuItem(context, Icons.bug_report, 'البوس', '/boss'),
                _menuItem(context, Icons.settings, 'الإعدادات', '/settings'),
                _menuItem(context, Icons.auto_awesome, 'المهام اليومية', '/quests'),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext context, IconData icon, String label, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
      child: SizedBox(
        width: 64,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.cardLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
