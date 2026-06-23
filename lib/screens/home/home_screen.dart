import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/quest_model.dart';
import '../../providers/app_provider.dart';
import '../../models/user_model.dart';
import '../../widgets/xp_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, app, _) {
        final user = app.user;
        return Scaffold(
          appBar: AppBar(
            title: Text('مرحبًا ${user.name.isNotEmpty ? user.name : 'يا بطل'} 👋'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => Navigator.pushNamed(context, '/settings'),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async => app.checkDailyReset(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _UserLevelCard(app: app),
                  const SizedBox(height: 16),
                  _QuickStats(app: app),
                  const SizedBox(height: 16),
                  _TodayOverview(app: app),
                  const SizedBox(height: 16),
                  _DailyQuestsPreview(app: app, context: context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _UserLevelCard extends StatelessWidget {
  final AppProvider app;
  const _UserLevelCard({required this.app});
  UserModel get user => app.user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  '${user.level}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'المستوى ${user.level}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  XpBar(
                    current: user.xp,
                    max: user.xpForNextLevel,
                    height: 10,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${user.xp} / ${user.xpForNextLevel} XP',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickStats extends StatelessWidget {
  final AppProvider app;
  const _QuickStats({required this.app});

  @override
  Widget build(BuildContext context) {
    final user = app.user;
    return Row(
      children: [
        _StatCard(label: '🔥 ${user.streakDays}', subtitle: 'أيام', color: Colors.orange),
        _StatCard(label: '🪙 ${user.coins}', subtitle: 'عملات', color: Colors.amber),
        _StatCard(label: '🌳 ${user.totalTreesPlanted}', subtitle: 'أشجار', color: Colors.green),
        _StatCard(label: '⏱ ${user.totalFocusMinutes}m', subtitle: 'تركيز', color: Colors.blue),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String subtitle;
  final Color color;
  const _StatCard({required this.label, required this.subtitle, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Text(label, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}

class _TodayOverview extends StatelessWidget {
  final AppProvider app;
  const _TodayOverview({required this.app});

  @override
  Widget build(BuildContext context) {
    final prayer = app.prayerToday;
    final tasks = app.todayTasks;
    final completed = tasks.where((t) => t.isCompleted).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ملخص اليوم', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                _OverviewItem(label: 'صلاة', value: '${prayer.completedPrayers}/5', color: Colors.green),
                const SizedBox(width: 16),
                _OverviewItem(label: 'مهام', value: '$completed/${tasks.length}', color: Colors.blue),
                const SizedBox(width: 16),
                _OverviewItem(label: 'قرآن', value: '${prayer.quranPages} ص', color: Colors.purple),
              ],
            ),
            if (prayer.completedPrayers < 5) ...[
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/habits'),
                icon: const Icon(Icons.mosque_outlined),
                label: const Text('تسجيل الصلوات المتبقية'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _OverviewItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _OverviewItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 18)),
          ),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _DailyQuestsPreview extends StatelessWidget {
  final AppProvider app;
  final BuildContext context;
  const _DailyQuestsPreview({required this.app, required this.context});

  @override
  Widget build(BuildContext context) {
    final quests = app.dailyQuests;
    final completed = quests.where((q) => q.status.index >= 1).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('🎯 المهام اليومية', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text('$completed/${quests.length}', style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 12),
            ...quests.take(3).map((q) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    q.status == QuestStatus.completed ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: q.status == QuestStatus.completed ? Colors.green : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(q.title, style: TextStyle(
                      decoration: q.status == QuestStatus.completed ? TextDecoration.lineThrough : null,
                      color: q.status == QuestStatus.completed ? Colors.grey : null,
                    )),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/quests'),
              child: const Text('عرض الكل'),
            ),
          ],
        ),
      ),
    );
  }
}
