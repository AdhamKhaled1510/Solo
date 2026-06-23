import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../../core/theme/cyberpunk_theme.dart';
import '../../core/widgets/cyberpunk_widgets.dart';
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
        systemNavigationBarColor: CyberColors.bg,
        statusBarColor: Colors.transparent,
      ),
      child: Consumer<AppProvider>(
        builder: (context, app, _) {
          final user = app.user;
          return Scaffold(
            body: CustomPaint(
              painter: GridBackground(),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
                  child: Column(
                    children: [
                      _Header(user: user, outerContext: context),
                      const SizedBox(height: 16),
                      _TimerSection(onEnterDungeon: () => Navigator.pushNamed(context, '/timer')),
                      const SizedBox(height: 16),
                      _DailyQuestsGrid(app: app),
                      const SizedBox(height: 12),
                      _StoryQuestCard(app: app),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final dynamic user;
  final BuildContext outerContext;
  const _Header({required this.user, required this.outerContext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Operator hex badge + stamina
          Column(
            children: [
              HexBadge(label: 'LVL', value: '${user.level}', color: CyberColors.neonCyan),
              const SizedBox(height: 6),
              SizedBox(
                width: 60,
                child: SegmentedBar(progress: user.levelProgress, segments: 6),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Center: Title
          Expanded(
            child: Column(
              children: [
                Text('S . O . L . O', style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold,
                  color: CyberColors.neonCyan, fontFamily: 'monospace',
                  letterSpacing: 3,
                )),
                Text('STUDY REALM', style: TextStyle(
                  fontSize: 9, color: CyberColors.textDim, fontFamily: 'monospace',
                  letterSpacing: 4,
                )),
                // Operator ID
                Text(user.name.isNotEmpty ? 'OPERATOR_ID ${user.name.toUpperCase()}' : 'OPERATOR_ID NAKAMURA',
                  style: TextStyle(fontSize: 8, color: CyberColors.textDim, fontFamily: 'monospace')),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Right: Gold + Streak + Menu
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GlassmorphicCapsule(icon: Icons.monetization_on, text: '${user.coins}', color: CyberColors.amberGold),
              const SizedBox(height: 6),
              GlassmorphicCapsule(icon: Icons.local_fire_department, text: '${user.streakDays} DAY', color: CyberColors.hotMagenta),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => _showQuickMenu(outerContext),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: CyberColors.dimCyan.withAlpha(60)),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const Icon(Icons.grid_view_rounded, color: CyberColors.textDim, size: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showQuickMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: CyberColors.surface,
      shape: const BeveledRectangleBorder(
        side: BorderSide(color: CyberColors.dimCyan, width: 1),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('NAVIGATION / القائمة', style: TextStyle(color: CyberColors.neonCyan, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
            const Divider(color: CyberColors.darkTeal),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                _QuickNavItem(icon: Icons.mosque, label: 'PRAYERS', route: '/habits', context: context),
                _QuickNavItem(icon: Icons.checklist, label: 'TASKS', route: '/tasks', context: context),
                _QuickNavItem(icon: Icons.park, label: 'GARDEN', route: '/garden', context: context),
                _QuickNavItem(icon: Icons.person, label: 'AVATAR', route: '/avatar', context: context),
                _QuickNavItem(icon: Icons.emoji_events, label: 'ACHIEVEMENTS', route: '/achievements', context: context),
                _QuickNavItem(icon: Icons.bar_chart, label: 'STATS', route: '/stats', context: context),
                _QuickNavItem(icon: Icons.groups, label: 'ROOMS', route: '/rooms', context: context),
                _QuickNavItem(icon: Icons.music_note, label: 'SOUNDSCAPES', route: '/soundscapes', context: context),
                _QuickNavItem(icon: Icons.bug_report, label: 'BOSS', route: '/boss', context: context),
                _QuickNavItem(icon: Icons.settings, label: 'SETTINGS', route: '/settings', context: context),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _QuickNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final BuildContext context;
  const _QuickNavItem({required this.icon, required this.label, required this.route, required this.context});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context); // Close bottom sheet
        Navigator.pushNamed(this.context, route);
      },
      child: SizedBox(
        width: 60,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: CyberColors.dimCyan.withAlpha(80)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(icon, color: CyberColors.neonCyan, size: 20),
            ),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 8, color: CyberColors.textDim, fontFamily: 'monospace')),
          ],
        ),
      ),
    );
  }
}

class _TimerSection extends StatelessWidget {
  final VoidCallback onEnterDungeon;

  const _TimerSection({required this.onEnterDungeon});

  @override
  Widget build(BuildContext context) {
    return BracketFrame(
      color: CyberColors.neonCyan,
      padding: 16,
      child: Column(
        children: [
          Text('02 : 33 : 04', style: TextStyle(
            fontSize: 42, fontWeight: FontWeight.w300,
            color: CyberColors.neonCyan,
            fontFamily: 'monospace',
            letterSpacing: 6,
          )),
          const SizedBox(height: 12),
          TechButton(
            text: 'ENTER DUNGEON',
            subtext: 'دخول المغارة',
            onPressed: onEnterDungeon,
            color: CyberColors.neonCyan,
          ),
        ],
      ),
    );
  }
}

class _DailyQuestsGrid extends StatelessWidget {
  final AppProvider app;
  const _DailyQuestsGrid({required this.app});

  @override
  Widget build(BuildContext context) {
    final quests = app.dailyQuests;
    final completed = quests.where((q) => q.status != QuestStatus.active).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'DAILY QUESTS / مهام اليوم', trailing: '$completed/${quests.length}'),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: quests.length.clamp(0, 4),
          itemBuilder: (context, index) {
            if (index >= quests.length) return const SizedBox();
            final q = quests[index];
            return _QuestCard(quest: q);
          },
        ),
      ],
    );
  }
}

class _QuestCard extends StatelessWidget {
  final QuestModel quest;
  const _QuestCard({required this.quest});

  @override
  Widget build(BuildContext context) {
    final isCompleted = quest.status != QuestStatus.active;
    final color = isCompleted ? CyberColors.hotMagenta : CyberColors.neonCyan;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: CyberColors.surface,
        border: Border.all(
          color: isCompleted ? CyberColors.hotMagenta.withAlpha(120) : CyberColors.dimCyan.withAlpha(80),
          width: isCompleted ? 1.5 : 0.5,
        ),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  quest.title,
                  style: TextStyle(
                    fontSize: 9,
                    fontFamily: 'monospace',
                    color: isCompleted ? CyberColors.hotMagenta : CyberColors.textPrimary,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 2,
                ),
              ),
              if (isCompleted)
                Container(
                  width: 14, height: 14,
                  decoration: BoxDecoration(
                    color: CyberColors.hotMagenta,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const Icon(Icons.check, size: 10, color: Colors.white),
                ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: color.withAlpha(100), width: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text('+${quest.xpReward} XP', style: TextStyle(
              fontSize: 9, color: color, fontFamily: 'monospace', fontWeight: FontWeight.bold,
            )),
          ),
        ],
      ),
    );
  }
}

class _StoryQuestCard extends StatelessWidget {
  final AppProvider app;
  const _StoryQuestCard({required this.app});

  @override
  Widget build(BuildContext context) {
    final stories = app.quests.where((q) => q.type == QuestType.story).toList();
    final current = stories.isNotEmpty ? stories.first : null;
    final progress = current != null ? current.progress : 0.0;

    return BracketFrame(
      color: CyberColors.neonCyan.withAlpha(150),
      padding: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('STORY QUEST / المهمة الأسطورية',
                    style: const TextStyle(fontSize: 11, color: CyberColors.neonCyan, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                  Text(current?.title ?? 'الفصل الثالث: الكيمياء العضوية',
                    style: const TextStyle(fontSize: 9, color: CyberColors.textDim, fontFamily: 'monospace')),
                ],
              ),
              Text('${(progress * 100).toInt()}% POWER LEVEL',
                style: const TextStyle(fontSize: 9, color: CyberColors.neonCyan, fontFamily: 'monospace')),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text('INIT', style: TextStyle(fontSize: 8, color: CyberColors.textDim, fontFamily: 'monospace')),
              const SizedBox(width: 4),
              Expanded(child: SegmentedBar(progress: progress, segments: 10)),
              const SizedBox(width: 4),
              Text('MAX', style: TextStyle(fontSize: 8, color: CyberColors.textDim, fontFamily: 'monospace')),
            ],
          ),
        ],
      ),
    );
  }
}
