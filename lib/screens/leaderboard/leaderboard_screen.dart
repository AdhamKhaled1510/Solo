import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  static const _rankEmoji = ['🟢', '🔵', '🟣', '🟠', '🔴', '👑'];
  static const _rankTitle = ['مبتدئ', 'مجتهد', 'مثابر', 'متقن', 'نابغة', 'أسطورة'];
  static const _rankName = ['E-Rank', 'D-Rank', 'C-Rank', 'B-Rank', 'A-Rank', 'S-Rank'];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, app, _) {
        final user = app.user;
        final ri = user.currentRank.index;
        return Scaffold(
          appBar: AppBar(title: const Text('🏆 لوحة الصدارة')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          width: 50, height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: ri == 5
                                ? [Colors.amber, Colors.orange]
                                : [Colors.grey.shade300, Colors.grey.shade100],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(child: Text(_rankEmoji[ri], style: const TextStyle(fontSize: 24))),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${_rankTitle[ri]} (${_rankName[ri]})',
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('Lv.${user.level} • ${user.totalFocusMinutes} دقيقة تركيز',
                                style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                            ],
                          ),
                        ),
                        Text('#?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.grey[400])),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text('🏆 بطولة الأسبوع', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _WeeklyChallenge(
                  title: 'أكثر وقت تركيز',
                  icon: '⏱',
                  progress: user.totalFocusMinutes,
                  target: 600,
                ),
                const SizedBox(height: 8),
                _WeeklyChallenge(
                  title: 'أكثر أشجار مزروعة',
                  icon: '🌳',
                  progress: user.totalTreesPlanted,
                  target: 20,
                ),
                const SizedBox(height: 8),
                _WeeklyChallenge(
                  title: 'أكثر صلوات في وقتها',
                  icon: '🕌',
                  progress: user.totalPrayersOnTime,
                  target: 35,
                ),
                const SizedBox(height: 24),
                Text('📊 إحصائيات سريعة', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _QuickStat(label: 'إجمالي وقت التركيز', value: '${user.totalFocusMinutes} دقيقة', icon: '⏱'),
                _QuickStat(label: 'الأشجار المزروعة', value: '${user.totalTreesPlanted}', icon: '🌳'),
                _QuickStat(label: 'المهام المنجزة', value: '${user.completedTasks}', icon: '✅'),
                _QuickStat(label: 'الصلوات المسجلة', value: '${user.totalPrayersOnTime}', icon: '🕌'),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _WeeklyChallenge extends StatelessWidget {
  final String title;
  final String icon;
  final int progress;
  final int target;
  const _WeeklyChallenge({required this.title, required this.icon, required this.progress, required this.target});

  @override
  Widget build(BuildContext context) {
    final pct = (progress / target).clamp(0.0, 1.0);
    final complete = progress >= target;
    return Card(
      color: complete ? Colors.green.withAlpha(15) : null,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text('$progress/$target', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 6,
                      backgroundColor: Colors.grey.withAlpha(30),
                      valueColor: AlwaysStoppedAnimation(complete ? Colors.green : Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            if (complete) const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text('✅', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  const _QuickStat({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(child: Text(label)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
