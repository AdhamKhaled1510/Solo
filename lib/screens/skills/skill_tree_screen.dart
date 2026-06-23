import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/cyberpunk_theme.dart';
import '../../core/widgets/cyberpunk_widgets.dart';
import '../../providers/app_provider.dart';
import '../../models/skill_model.dart';
import '../../models/solo_rank.dart';

class SkillTreeScreen extends StatelessWidget {
  const SkillTreeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, app, _) {
        final user = app.user;
        return Scaffold(
          body: CustomPaint(
            painter: GridBackground(),
            child: SafeArea(
              child: user.branch == null
                ? _BranchSelector(app: app)
                : _SkillTreeViewer(app: app),
            ),
          ),
        );
      },
    );
  }
}

class _BranchSelector extends StatelessWidget {
  final AppProvider app;
  const _BranchSelector({required this.app});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text('⚡', style: TextStyle(fontSize: 60, color: CyberColors.neonCyan)),
          const SizedBox(height: 12),
          const Text(
            'CHOOSE CLASS / اختر الشعبة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: CyberColors.neonCyan,
              fontFamily: 'monospace',
              letterSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'ستحدد الشعبة المسار التكنولوجي لقدراتك الفكرية',
            style: TextStyle(fontSize: 11, color: CyberColors.textDim, fontFamily: 'monospace'),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _BranchCard(
            title: 'THE MAGE / علمي علوم',
            subtitle: 'تخصص الكيمياء والأحياء والتحليل الخلوي',
            description: 'تركيز مكثف على فك شفرات العلوم الحيوية والطبية مع مكافآت معززة للـ XP.',
            branch: SubjectBranch.science,
            app: app,
            color: CyberColors.neonCyan,
          ),
          const SizedBox(height: 16),
          _BranchCard(
            title: 'MECHANIC / علمي رياضة',
            subtitle: 'تخصص الهندسة والرياضيات المتقدمة والفيزياء',
            description: 'حل المعادلات المعقدة وبناء النماذج الهندسية مع ترقيات قتالية للبوس فايت.',
            branch: SubjectBranch.math,
            app: app,
            color: CyberColors.amberGold,
          ),
          const SizedBox(height: 16),
          _BranchCard(
            title: 'EXPLORER / أدبي',
            subtitle: 'تخصص التاريخ والجغرافيا والعلوم الإنسانية',
            description: 'استكشاف الثقافات وتحليل الفلسفة مع سرعة أكبر في تجميع العملات والمهام.',
            branch: SubjectBranch.literature,
            app: app,
            color: CyberColors.hotMagenta,
          ),
        ],
      ),
    );
  }
}

class _BranchCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final SubjectBranch branch;
  final AppProvider app;
  final Color color;

  const _BranchCard({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.branch,
    required this.app,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return BracketFrame(
      color: color,
      padding: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color, fontFamily: 'monospace')),
                    Text(subtitle, style: const TextStyle(fontSize: 11, color: CyberColors.textDim)),
                  ],
                ),
              ),
              Icon(Icons.shield, color: color, size: 24),
            ],
          ),
          const SizedBox(height: 8),
          Text(description, style: const TextStyle(fontSize: 10, color: CyberColors.textPrimary)),
          const SizedBox(height: 12),
          TechButton(
            text: 'INITIALIZE CLASS',
            subtext: 'تفعيل القدرات',
            onPressed: () {
              app.user.branch = branch;
              app.user.addXp(100); // Give small bonus
              app.init(); // Reload
            },
            color: color,
          ),
        ],
      ),
    );
  }
}

class _SkillTreeViewer extends StatelessWidget {
  final AppProvider app;
  const _SkillTreeViewer({required this.app});

  @override
  Widget build(BuildContext context) {
    final user = app.user;
    final unlocked = app.unlockedSkills;
    final available = app.availableSkills;

    return Column(
      children: [
        // Top tech header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.branch == SubjectBranch.science ? 'SYSTEM: MAGE' :
                    user.branch == SubjectBranch.math ? 'SYSTEM: MECHANIC' : 'SYSTEM: EXPLORER',
                    style: const TextStyle(color: CyberColors.neonCyan, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                  ),
                  const Text('UPGRADE NODES / ترقية القدرات', style: TextStyle(color: CyberColors.textDim, fontSize: 9, fontFamily: 'monospace')),
                ],
              ),
              Row(
                children: [
                  HexBadge(label: 'PTS', value: '${user.skillPoints}', color: CyberColors.amberGold),
                ],
              ),
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
                if (unlocked.isNotEmpty) ...[
                  const SectionHeader(title: 'UNLOCKED UPGRADES / ترقيات مفعلة'),
                  const SizedBox(height: 10),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: unlocked.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, idx) => _SkillNodeCard(skill: unlocked[idx], isUnlocked: true),
                  ),
                  const SizedBox(height: 20),
                ],
                if (available.isNotEmpty) ...[
                  const SectionHeader(title: 'AVAILABLE PATHS / مسارات متاحة'),
                  const SizedBox(height: 10),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: available.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, idx) {
                      final s = available[idx];
                      return GestureDetector(
                        onTap: () {
                          if (user.skillPoints >= s.skillPointsCost) {
                            if (app.unlockSkill(s.id)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('تم فتح ${s.name}! 🎉'),
                                  backgroundColor: CyberColors.neonCyan,
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('نقاط القدرة غير كافية لفك هذا المسار!'),
                                backgroundColor: CyberColors.hotMagenta,
                              ),
                            );
                          }
                        },
                        child: _SkillNodeCard(skill: s, isUnlocked: false),
                      );
                    },
                  ),
                ],
                if (unlocked.isEmpty && available.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text('جميع الترقيات مفعلة بالكامل!', style: TextStyle(color: CyberColors.textDim, fontFamily: 'monospace')),
                    ),
                  ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SkillNodeCard extends StatelessWidget {
  final SkillModel skill;
  final bool isUnlocked;

  const _SkillNodeCard({required this.skill, required this.isUnlocked});

  @override
  Widget build(BuildContext context) {
    final color = isUnlocked ? CyberColors.neonCyan : CyberColors.textDim;
    return BracketFrame(
      color: isUnlocked ? CyberColors.neonCyan : CyberColors.dimCyan.withAlpha(50),
      padding: 12,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isUnlocked ? CyberColors.neonCyan.withAlpha(30) : Colors.transparent,
              border: Border.all(color: color, width: 1),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Icon(
              isUnlocked ? Icons.lock_open : Icons.lock_outline,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  skill.name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isUnlocked ? CyberColors.textPrimary : CyberColors.textDim,
                    fontFamily: 'monospace',
                  ),
                ),
                Text(
                  skill.description,
                  style: const TextStyle(fontSize: 10, color: CyberColors.textDim),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (!isUnlocked)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${skill.skillPointsCost} PTS', style: const TextStyle(fontSize: 12, color: CyberColors.amberGold, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                const Text('COST', style: TextStyle(fontSize: 8, color: CyberColors.textDim, fontFamily: 'monospace')),
              ],
            )
          else
            const Icon(Icons.verified, color: CyberColors.neonCyan, size: 20),
        ],
      ),
    );
  }
}
