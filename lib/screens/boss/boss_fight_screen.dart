import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/party_model.dart';

class BossFightScreen extends StatelessWidget {
  const BossFightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, app, _) {
        final bosses = app.bossFights;
        return Scaffold(
          appBar: AppBar(
            title: const Text('⚔️ معارك الزعماء'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withAlpha(25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('⚔️ ${bosses.where((b) => !b.defeated).length}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              _BossHeader(app: app),
              Expanded(
                child: bosses.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🐉', style: TextStyle(fontSize: 80)),
                          const SizedBox(height: 16),
                          Text('لا توجد معارك متاحة', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          FilledButton(
                            onPressed: () {
                              app.addBossFight(BossFight(
                                id: 'boss_${DateTime.now().millisecondsSinceEpoch}',
                                name: 'زعيم الفيزياء',
                                subject: 'الفيزياء',
                                chapter: 'الفصل الأول',
                                totalXp: 500,
                              ));
                            },
                            child: const Text('+ إضافة معركة تجريبية'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: bosses.length,
                      itemBuilder: (context, index) {
                        final boss = bosses[index];
                        return _BossCard(boss: boss, app: app);
                      },
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BossHeader extends StatelessWidget {
  final AppProvider app;
  const _BossHeader({required this.app});

  static const _rankNames = {0: 'E-Rank', 1: 'D-Rank', 2: 'C-Rank', 3: 'B-Rank', 4: 'A-Rank', 5: 'S-Rank'};
  static const _rankTitles = {0: 'مبتدئ', 1: 'مجتهد', 2: 'مثابر', 3: 'متقن', 4: 'نابغة', 5: 'أسطورة'};

  @override
  Widget build(BuildContext context) {
    final user = app.user;
    final rankIdx = user.currentRank.index;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.red.shade700, Colors.red.shade900]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Text('👑', style: TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('مستوى ${_rankNames[rankIdx] ?? ''}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                Text('${_rankTitles[rankIdx] ?? ''}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                Text('⚔️ ${app.bossFights.where((b) => b.defeated).length}/${app.bossFights.length} زعماء مهزومين',
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Text('⚔️', style: TextStyle(fontSize: 32)),
        ],
      ),
    );
  }
}

class _BossCard extends StatelessWidget {
  final BossFight boss;
  final AppProvider app;
  const _BossCard({required this.boss, required this.app});

  @override
  Widget build(BuildContext context) {
    final hp = boss.defeated ? 0 : 100 - (boss.attempts * 20).clamp(0, 100);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: boss.defeated ? Colors.green.withAlpha(15) : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(boss.defeated ? '✅' : '🐉', style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(boss.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('${boss.subject} • ${boss.chapter}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                ),
                if (!boss.defeated)
                  Text('+${boss.totalXp} XP', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
              ],
            ),
            if (!boss.defeated) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: hp / 100,
                  minHeight: 8,
                  backgroundColor: Colors.red.withAlpha(50),
                  valueColor: AlwaysStoppedAnimation(hp > 50 ? Colors.red : Colors.orange),
                ),
              ),
              const SizedBox(height: 4),
              Text('HP: $hp%', style: TextStyle(color: Colors.red, fontSize: 12)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => app.attemptBoss(boss.id),
                    icon: const Icon(Icons.sports_kabaddi, size: 16),
                    label: const Text('هجوم!'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () {
                      app.defeatBoss(boss.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${boss.name} مهزوم! 🎉 +${boss.totalXp} XP')),
                      );
                    },
                    icon: const Icon(Icons.auto_fix_high, size: 16),
                    label: const Text('هزيمة (اختبار)'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
