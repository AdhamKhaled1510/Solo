import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
          appBar: AppBar(
            title: const Text('🌿 شجرة المهارات'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.purple.withAlpha(25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('⚡ ${user.skillPoints} نقطة', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
          body: user.branch == null
            ? _BranchSelector(app: app)
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _RankInfo(rank: user.currentRank, level: user.level),
                    const SizedBox(height: 16),
                    if (app.availableSkills.isEmpty && app.unlockedSkills.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text('لا توجد مهارات متاحة حاليًا', style: TextStyle(color: Colors.grey)),
                        ),
                      ),
                    if (app.unlockedSkills.isNotEmpty) ...[
                      Text('🔓 المهارات المفتوحة', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...app.unlockedSkills.map((s) => _SkillCard(skill: s, unlocked: true)),
                      const SizedBox(height: 16),
                    ],
                    if (app.availableSkills.isNotEmpty) ...[
                      Text('🔒 المهارات المتاحة', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...app.availableSkills.map((s) => _SkillCard(
                        skill: s,
                        unlocked: false,
                        onUnlock: () {
                          if (app.unlockSkill(s.id)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('تم فتح ${s.name}! 🎉')),
                            );
                          }
                        },
                      )),
                    ],
                  ],
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
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🧙', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          Text('اختر شعبتك', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('المهارات هتختلف حسب شعبتك', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 32),
          _BranchCard(
            emoji: '🧪',
            name: 'علمي علوم',
            title: 'The Mage',
            description: 'مهارات لفك طلاسم الأحياء والجيولوجيا',
            color: Colors.green,
            onTap: () => app.setBranch(SubjectBranch.science),
          ),
          const SizedBox(height: 12),
          _BranchCard(
            emoji: '⚙️',
            name: 'علمي رياضة',
            title: 'The Mechanic',
            description: 'مهارات لسرعة حل المعادلات والهندسة',
            color: Colors.blue,
            onTap: () => app.setBranch(SubjectBranch.math),
          ),
          const SizedBox(height: 12),
          _BranchCard(
            emoji: '📜',
            name: 'أدبي',
            title: 'The Explorer',
            description: 'مهارات لحفظ التواريخ وفهم الفلسفة',
            color: Colors.purple,
            onTap: () => app.setBranch(SubjectBranch.literature),
          ),
        ],
      ),
    );
  }
}

class _BranchCard extends StatelessWidget {
  final String emoji;
  final String name;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;
  const _BranchCard({required this.emoji, required this.name, required this.title, required this.description, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(color: color.withAlpha(25), borderRadius: BorderRadius.circular(12)),
                child: Center(child: Text(emoji, style: const TextStyle(fontSize: 32))),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
                    Text(description, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _RankInfo extends StatelessWidget {
  final SoloRank rank;
  final int level;
  const _RankInfo({required this.rank, required this.level});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: rank == SoloRank.s ? Colors.amber.withAlpha(50) : Colors.grey.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('${rank.emoji} ${rank.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            const Spacer(),
            Text('LVL $level', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  final SkillModel skill;
  final bool unlocked;
  final VoidCallback? onUnlock;
  const _SkillCard({required this.skill, required this.unlocked, this.onUnlock});

  @override
  Widget build(BuildContext context) {
    final categoryColor = switch (skill.category) {
      SkillCategory.focus => Colors.blue,
      SkillCategory.memory => Colors.purple,
      SkillCategory.subject => Colors.green,
      SkillCategory.social => Colors.orange,
      SkillCategory.defense => Colors.red,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: categoryColor.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  unlocked ? Icons.check_circle : Icons.lock_outline,
                  color: unlocked ? Colors.green : categoryColor,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(skill.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(skill.description, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                  if (skill.branch != null)
                    Chip(
                      label: Text(
                        skill.branch == SubjectBranch.science ? 'علمي علوم' :
                        skill.branch == SubjectBranch.math ? 'علمي رياضة' : 'أدبي',
                        style: const TextStyle(fontSize: 10),
                      ),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                ],
              ),
            ),
            if (!unlocked)
              FilledButton.tonal(
                onPressed: onUnlock,
                child: Text('⚡${skill.skillPointsCost}'),
              )
            else
              const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ),
    );
  }
}
