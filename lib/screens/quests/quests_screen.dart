import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/quest_model.dart';
import '../../models/tree_species.dart';
import '../../providers/app_provider.dart';

class QuestsScreen extends StatelessWidget {
  const QuestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, app, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('🎯 المهام'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.withAlpha(25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('🪙 ${app.user.coins}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _QuestSection(
                  title: '📅 يومي',
                  quests: app.dailyQuests,
                  app: app,
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),
                _QuestSection(
                  title: '📆 أسبوعي',
                  quests: app.weeklyQuests,
                  app: app,
                  color: Colors.purple,
                ),
                const SizedBox(height: 16),
                // Seasonal event section
                _SeasonalEvent(app: app),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SeasonalEvent extends StatelessWidget {
  final AppProvider app;
  const _SeasonalEvent({required this.app});

  @override
  Widget build(BuildContext context) {
    final seasonalQuests = app.quests.where((q) => q.type == QuestType.story).toList();
    if (seasonalQuests.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.amber.shade300, Colors.orange.shade400]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🎪', style: TextStyle(fontSize: 16)),
              SizedBox(width: 6),
              Text('فعالية موسمية', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ...seasonalQuests.map((quest) => _QuestCard(quest: quest, app: app, color: Colors.amber)),
      ],
    );
  }
}

class _QuestSection extends StatelessWidget {
  final String title;
  final List<QuestModel> quests;
  final AppProvider app;
  final Color color;
  const _QuestSection({required this.title, required this.quests, required this.app, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (quests.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('لا توجد مهام متاحة', style: TextStyle(color: Colors.grey)),
            ),
          )
        else
          ...quests.map((quest) => _QuestCard(quest: quest, app: app, color: color)),
      ],
    );
  }
}

class _QuestCard extends StatelessWidget {
  final QuestModel quest;
  final AppProvider app;
  final Color color;
  const _QuestCard({required this.quest, required this.app, required this.color});

  @override
  Widget build(BuildContext context) {
    final i = quest.status == QuestStatus.claimed ? Icons.done_all :
      quest.status == QuestStatus.completed ? Icons.check_circle : Icons.radio_button_unchecked;
    final iColor = quest.status == QuestStatus.claimed ? Colors.grey :
      quest.status == QuestStatus.completed ? Colors.green : color;

    String? treeEmoji;
    if (quest.treeReward != null) {
      treeEmoji = TreeSpecies.getById(quest.treeReward!).emoji;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: iColor.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Icon(i, color: iColor, size: 20)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(quest.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  if (quest.description.isNotEmpty)
                    Text(quest.description, style: TextStyle(fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: quest.progress,
                      minHeight: 6,
                      backgroundColor: Colors.grey.withAlpha(30),
                      valueColor: AlwaysStoppedAnimation(
                        quest.status == QuestStatus.completed ? Colors.green : color,
                      ),
                    ),
                  ),
                  Text('${quest.currentProgress}/${quest.targetProgress}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                if (quest.status == QuestStatus.completed)
                  FilledButton(
                    onPressed: () => app.claimQuestReward(quest.id),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: Size.zero,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (treeEmoji != null) ...[
                          Text(treeEmoji, style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 4),
                        ],
                        const Text('استلام', style: TextStyle(fontSize: 11)),
                      ],
                    ),
                  )
                else if (quest.status == QuestStatus.claimed)
                  const Text('✅', style: TextStyle(fontSize: 20))
                else
                  Column(
                    children: [
                      Text('+${quest.xpReward} XP', style: const TextStyle(fontSize: 11, color: Colors.blue, fontWeight: FontWeight.bold)),
                      Text('+${quest.coinReward} 🪙', style: const TextStyle(fontSize: 11, color: Colors.amber)),
                      if (treeEmoji != null)
                        Text(treeEmoji, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
