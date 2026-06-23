import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/cyberpunk_theme.dart';
import '../../core/widgets/cyberpunk_widgets.dart';
import '../../providers/app_provider.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, app, _) {
        final user = app.user;

        return Scaffold(
          body: CustomPaint(
            painter: GridBackground(),
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LEADERBOARD / لوحة الصدارة',
                              style: TextStyle(color: CyberColors.neonCyan, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                            ),
                            Text('HOLOGRAPHIC RANKINGS / بطولة الفرسان الأسبوعية', style: TextStyle(color: CyberColors.textDim, fontSize: 9, fontFamily: 'monospace')),
                          ],
                        ),
                        Icon(Icons.emoji_events, color: CyberColors.amberGold, size: 24),
                      ],
                    ),
                  ),
                  const Divider(color: CyberColors.darkTeal, height: 1),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top 3 Podium
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _PodiumCard(
                                rank: 2,
                                name: 'Zack_X',
                                value: '540m',
                                label: 'MINUTES',
                                color: Colors.grey.shade400,
                              ),
                              _PodiumCard(
                                rank: 1,
                                name: 'Nakamura_24',
                                value: '920m',
                                label: 'MINUTES',
                                color: CyberColors.amberGold,
                                isFirst: true,
                              ),
                              _PodiumCard(
                                rank: 3,
                                name: 'Rayan_8',
                                value: '410m',
                                label: 'MINUTES',
                                color: CyberColors.hotMagenta,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const SectionHeader(title: 'WEEKLY COMPETITIONS / بطولة الأسبوع'),
                          const SizedBox(height: 10),
                          _WeeklyChallengeCard(
                            title: 'FOCUS CHAMPION / بطل التركيز',
                            current: user.totalFocusMinutes,
                            target: 600,
                            icon: Icons.timer,
                            color: CyberColors.neonCyan,
                          ),
                          const SizedBox(height: 8),
                          _WeeklyChallengeCard(
                            title: 'FOREST GUARDIAN / حارس الغابة',
                            current: user.totalTreesPlanted,
                            target: 20,
                            icon: Icons.park,
                            color: CyberColors.amberGold,
                          ),
                          const SizedBox(height: 8),
                          _WeeklyChallengeCard(
                            title: 'PRAYER DEVOTION / الملتزم',
                            current: user.totalPrayersOnTime,
                            target: 35,
                            icon: Icons.mosque,
                            color: CyberColors.hotMagenta,
                          ),
                          const SizedBox(height: 80), // spacer for bottom nav and pinned card
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomSheet: Container(
            color: CyberColors.bg,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _MyRankCard(user: user),
          ),
        );
      },
    );
  }
}

class _PodiumCard extends StatelessWidget {
  final int rank;
  final String name;
  final String value;
  final String label;
  final Color color;
  final bool isFirst;

  const _PodiumCard({
    required this.rank,
    required this.name,
    required this.value,
    required this.label,
    required this.color,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    final h = isFirst ? 140.0 : 110.0;
    return BracketFrame(
      color: color,
      padding: 8,
      child: SizedBox(
        width: 80,
        height: h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                color: color.withAlpha(30),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 1.5),
              ),
              child: Center(
                child: Text(
                  '#$rank',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color, fontFamily: 'monospace'),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: CyberColors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color, fontFamily: 'monospace'),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 7, color: CyberColors.textDim, fontFamily: 'monospace'),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyChallengeCard extends StatelessWidget {
  final String title;
  final int current;
  final int target;
  final IconData icon;
  final Color color;

  const _WeeklyChallengeCard({
    required this.title,
    required this.current,
    required this.target,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (current / target).clamp(0.0, 1.0);
    return BracketFrame(
      color: color.withAlpha(120),
      padding: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color, fontFamily: 'monospace'),
                ),
              ),
              Text(
                '$current / $target',
                style: const TextStyle(fontSize: 10, color: CyberColors.textPrimary, fontFamily: 'monospace'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SegmentedBar(progress: progress, segments: 10),
        ],
      ),
    );
  }
}

class _MyRankCard extends StatelessWidget {
  final dynamic user;
  const _MyRankCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: CyberColors.surface,
        border: Border.all(color: CyberColors.neonCyan.withAlpha(150), width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          HexBadge(label: 'RANK', value: '4', color: CyberColors.neonCyan),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.name.isNotEmpty ? user.name.toUpperCase() : 'OPERATOR_ID NAKAMURA',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: CyberColors.textPrimary, fontFamily: 'monospace'),
                ),
                Text(
                  'Lv.${user.level} • ${user.totalFocusMinutes} MINUTES',
                  style: const TextStyle(fontSize: 9, color: CyberColors.textDim, fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_upward, color: CyberColors.neonCyan, size: 16),
        ],
      ),
    );
  }
}
