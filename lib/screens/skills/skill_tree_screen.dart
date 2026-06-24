import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/clean_theme.dart';
import '../../core/widgets/clean_widgets.dart';
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
            title: const Text('المهارات'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: BadgeWidget(text: '⚡ ${user.skillPoints} نقطة', color: AppColors.purple),
              ),
            ],
          ),
          body: user.branch == null ? _BranchSelector(app: app) : _SkillTreeViewer(app: app),
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
          const Icon(Icons.auto_awesome, color: AppColors.primary, size: 60),
          const SizedBox(height: 16),
          const Text('اختر شعبتك', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          const Text(
            'المهارات هتختلف حسب شعبتك الدراسية',
            style: TextStyle(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _BranchCard(
            title: 'علمي علوم',
            subtitle: 'The Mage',
            desc: 'الكيمياء، الأحياء، الجيولوجيا',
            icon: '🧪',
            branch: SubjectBranch.science,
            app: app,
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),
          _BranchCard(
            title: 'علمي رياضة',
            subtitle: 'The Mechanic',
            desc: 'الرياضيات، الفيزياء، الهندسة',
            icon: '📐',
            branch: SubjectBranch.math,
            app: app,
            color: AppColors.secondary,
          ),
          const SizedBox(height: 12),
          _BranchCard(
            title: 'أدبي',
            subtitle: 'The Explorer',
            desc: 'التاريخ، الجغرافيا، الفلسفة',
            icon: '📚',
            branch: SubjectBranch.literature,
            app: app,
            color: AppColors.purple,
          ),
        ],
      ),
    );
  }
}

class _BranchCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String desc;
  final String icon;
  final SubjectBranch branch;
  final AppProvider app;
  final Color color;

  const _BranchCard({
    required this.title, required this.subtitle, required this.desc,
    required this.icon, required this.branch, required this.app, required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderColor: color.withAlpha(60),
      onTap: () {
        app.setBranch(branch);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم اختيار $title! 🎉'), backgroundColor: color),
        );
      },
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 36)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
                Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: AppColors.textDim, fontSize: 11)),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: color, size: 16),
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.branch == SubjectBranch.science ? '🧪 Mage' :
            user.branch == SubjectBranch.math ? '📐 Mechanic' : '📚 Explorer',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          if (unlocked.isNotEmpty) ...[
            const SectionHeader(title: 'المهارات المفتوحة'),
            const SizedBox(height: 8),
            ...unlocked.map((s) => _SkillNode(skill: s, unlocked: true)),
            const SizedBox(height: 16),
          ],
          if (available.isNotEmpty) ...[
            const SectionHeader(title: 'المهارات المتاحة'),
            const SizedBox(height: 8),
            ...available.map((s) => GestureDetector(
              onTap: () {
                if (user.skillPoints >= s.skillPointsCost) {
                  if (app.unlockSkill(s.id)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('تم فتح ${s.name}! 🎉'), backgroundColor: AppColors.success),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('نقاط القدرة غير كافية!'), backgroundColor: AppColors.error),
                  );
                }
              },
              child: _SkillNode(skill: s, unlocked: false),
            )),
          ],
          if (unlocked.isEmpty && available.isEmpty)
            const Center(child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('جميع المهارات مفتوحة! 🎉', style: TextStyle(color: AppColors.textSecondary)),
            )),
        ],
      ),
    );
  }
}

class _SkillNode extends StatelessWidget {
  final SkillModel skill;
  final bool unlocked;

  const _SkillNode({required this.skill, required this.unlocked});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      borderColor: unlocked ? AppColors.primary.withAlpha(60) : AppColors.cardLight,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: unlocked ? AppColors.primary.withAlpha(20) : AppColors.cardLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              unlocked ? Icons.lock_open : Icons.lock_outline,
              color: unlocked ? AppColors.primary : AppColors.textDim,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(skill.name, style: TextStyle(fontWeight: FontWeight.w600, color: unlocked ? AppColors.textPrimary : AppColors.textSecondary)),
                const SizedBox(height: 2),
                Text(skill.description, style: const TextStyle(fontSize: 11, color: AppColors.textDim)),
              ],
            ),
          ),
          if (!unlocked)
            BadgeWidget(text: '${skill.skillPointsCost}', color: AppColors.purple),
          if (unlocked)
            const Icon(Icons.check_circle, color: AppColors.success, size: 20),
        ],
      ),
    );
  }
}
