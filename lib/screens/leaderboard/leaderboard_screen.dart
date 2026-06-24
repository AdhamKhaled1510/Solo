import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/clean_theme.dart';
import '../../core/widgets/clean_widgets.dart';
import '../../providers/app_provider.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, app, _) {
        final user = app.user;
        return Scaffold(
          appBar: AppBar(title: const Text('التصنيف')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Top 3 Podium
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _PodiumPos(rank: 2, name: 'Zack_X', value: '540m', color: AppColors.textSecondary, h: 100),
                  _PodiumPos(rank: 1, name: 'Nakamura_24', value: '920m', color: AppColors.primary, h: 130, first: true),
                  _PodiumPos(rank: 3, name: 'Rayan_8', value: '410m', color: AppColors.streakOrange, h: 90),
                ],
              ),
              const SizedBox(height: 24),
              const SectionHeader(title: 'تحديات الأسبوع'),
              const SizedBox(height: 12),
              _ChallengeCard(title: 'بطل التركيز', current: user.totalFocusMinutes, target: 600, icon: Icons.timer, color: AppColors.primary),
              const SizedBox(height: 8),
              _ChallengeCard(title: 'حارس الغابة', current: user.totalTreesPlanted, target: 20, icon: Icons.park, color: AppColors.success),
              const SizedBox(height: 8),
              _ChallengeCard(title: 'الملتزم', current: user.totalPrayersOnTime, target: 35, icon: Icons.mosque, color: AppColors.secondary),
              const SizedBox(height: 80),
            ],
          ),
          bottomSheet: Container(
            color: AppColors.bg,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: GlassCard(
              padding: const EdgeInsets.all(14),
              borderColor: AppColors.primary.withAlpha(60),
              child: Row(
                children: [
                  LevelHexWidget(level: user.level),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name.isNotEmpty ? user.name : 'أنت', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        Text('Lv.${user.level} • ${user.totalFocusMinutes} دقيقة تركيز', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_upward, color: AppColors.primary, size: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PodiumPos extends StatelessWidget {
  final int rank;
  final String name, value;
  final Color color;
  final double h;
  final bool first;

  const _PodiumPos({
    required this.rank, required this.name, required this.value,
    required this.color, required this.h, this.first = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: h,
      child: GlassCard(
        padding: const EdgeInsets.all(8),
        borderColor: color.withAlpha(60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 1.5),
              ),
              child: Center(child: Text('#$rank', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color))),
            ),
            const SizedBox(height: 4),
            Text(name, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
            const Spacer(),
            Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
            const Text('MIN', style: TextStyle(fontSize: 8, color: AppColors.textDim)),
          ],
        ),
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final String title;
  final int current, target;
  final IconData icon;
  final Color color;

  const _ChallengeCard({required this.title, required this.current, required this.target, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final progress = (current / target).clamp(0.0, 1.0);
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
              const Spacer(),
              Text('$current / $target', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 8),
          XpBar(progress: progress),
        ],
      ),
    );
  }
}
