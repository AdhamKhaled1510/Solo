import 'solo_rank.dart';

enum SkillCategory { focus, memory, subject, social, defense }

class SkillModel {
  final String id;
  final String name;
  final String description;
  final SkillCategory category;
  final SubjectBranch? branch;
  final int requiredLevel;
  final int requiredRankLevel; // SoloRank index
  final int skillPointsCost;
  final String effect;
  final double value; // e.g., 0.05 for +5%
  bool unlocked;

  SkillModel({
    required this.id,
    required this.name,
    this.description = '',
    required this.category,
    this.branch,
    this.requiredLevel = 1,
    this.requiredRankLevel = 0,
    this.skillPointsCost = 1,
    this.effect = '',
    this.value = 0.0,
    this.unlocked = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'category': category.index,
    'branch': branch?.index,
    'requiredLevel': requiredLevel,
    'requiredRankLevel': requiredRankLevel,
    'skillPointsCost': skillPointsCost,
    'effect': effect,
    'value': value,
    'unlocked': unlocked,
  };

  factory SkillModel.fromJson(Map<String, dynamic> json) => SkillModel(
    id: json['id'],
    name: json['name'],
    description: json['description'] ?? '',
    category: SkillCategory.values[json['category']],
    branch: json['branch'] != null ? SubjectBranch.values[json['branch']] : null,
    requiredLevel: json['requiredLevel'] ?? 1,
    requiredRankLevel: json['requiredRankLevel'] ?? 0,
    skillPointsCost: json['skillPointsCost'] ?? 1,
    effect: json['effect'] ?? '',
    value: (json['value'] ?? 0.0).toDouble(),
    unlocked: json['unlocked'] ?? false,
  );

  static List<SkillModel> getDefaultSkills() => [
    // Focus skills
    SkillModel(id: 'focus_1', name: 'تركيز عميق Lv.1', description: '+5% XP من جلسات التركيز',
      category: SkillCategory.focus, requiredLevel: 3, skillPointsCost: 1, effect: 'xp_boost_focus', value: 0.05),
    SkillModel(id: 'focus_2', name: 'تركيز عميق Lv.2', description: '+10% XP من جلسات التركيز',
      category: SkillCategory.focus, requiredLevel: 10, skillPointsCost: 2, effect: 'xp_boost_focus', value: 0.10),
    SkillModel(id: 'focus_3', name: 'تركيز أسطوري', description: '+20% XP من جلسات التركيز',
      category: SkillCategory.focus, requiredLevel: 25, skillPointsCost: 3, effect: 'xp_boost_focus', value: 0.20),

    // Memory skills
    SkillModel(id: 'memory_1', name: 'حفظ سريع Lv.1', description: '+10% XP من المواد الحفظ',
      category: SkillCategory.memory, requiredLevel: 5, skillPointsCost: 1, effect: 'xp_boost_memory', value: 0.10),
    SkillModel(id: 'memory_2', name: 'حفظ سريع Lv.2', description: '+20% XP من المواد الحفظ',
      category: SkillCategory.memory, requiredLevel: 15, skillPointsCost: 2, effect: 'xp_boost_memory', value: 0.20),

    // Subject-specific (علمي علوم - Mage)
    SkillModel(id: 'science_1', name: 'فك الطلاسم', description: '+15% XP في الأحياء',
      category: SkillCategory.subject, branch: SubjectBranch.science, requiredLevel: 8, skillPointsCost: 2,
      effect: 'xp_boost_subject', value: 0.15),
    SkillModel(id: 'science_2', name: 'تحليل الخلايا', description: '+10% XP في الجيولوجيا',
      category: SkillCategory.subject, branch: SubjectBranch.science, requiredLevel: 18, skillPointsCost: 2,
      effect: 'xp_boost_subject', value: 0.10),

    // Subject-specific (علمي رياضة - Mechanic)
    SkillModel(id: 'math_1', name: 'حل المعادلات', description: '+15% XP في الرياضيات',
      category: SkillCategory.subject, branch: SubjectBranch.math, requiredLevel: 8, skillPointsCost: 2,
      effect: 'xp_boost_subject', value: 0.15),
    SkillModel(id: 'math_2', name: 'قوانين الهندسة', description: '+15% XP في الفيزياء',
      category: SkillCategory.subject, branch: SubjectBranch.math, requiredLevel: 18, skillPointsCost: 2,
      effect: 'xp_boost_subject', value: 0.15),

    // Subject-specific (أدبي - Explorer)
    SkillModel(id: 'lit_1', name: 'حفظ التواريخ', description: '+15% XP في التاريخ',
      category: SkillCategory.subject, branch: SubjectBranch.literature, requiredLevel: 8, skillPointsCost: 2,
      effect: 'xp_boost_subject', value: 0.15),
    SkillModel(id: 'lit_2', name: 'تحليل الفلسفة', description: '+15% XP في الفلسفة',
      category: SkillCategory.subject, branch: SubjectBranch.literature, requiredLevel: 18, skillPointsCost: 2,
      effect: 'xp_boost_subject', value: 0.15),

    // Social skills
    SkillModel(id: 'social_1', name: 'قائد الفريق', description: 'تستطيع عمل Party مع الأصدقاء',
      category: SkillCategory.social, requiredLevel: 12, skillPointsCost: 2, effect: 'unlock_party', value: 1),
    SkillModel(id: 'social_2', name: 'الملهم', description: '+5% XP لكل أعضاء الـ Party',
      category: SkillCategory.social, requiredLevel: 22, skillPointsCost: 3, effect: 'party_bonus', value: 0.05),

    // Defense skills
    SkillModel(id: 'defense_1', name: 'الدرع Lv.1', description: '+1 Shield (يحمي الـ Streak من الكسر)',
      category: SkillCategory.defense, requiredLevel: 7, skillPointsCost: 1, effect: 'shield', value: 1),
    SkillModel(id: 'defense_2', name: 'الدرع Lv.2', description: '+2 Shield',
      category: SkillCategory.defense, requiredLevel: 20, skillPointsCost: 2, effect: 'shield', value: 2),
  ];
}
