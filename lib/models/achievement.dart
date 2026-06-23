import 'package:flutter/material.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final int xpReward;
  final int coinReward;
  final AchievementCategory category;
  bool unlocked;
  DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    this.xpReward = 100,
    this.coinReward = 50,
    this.category = AchievementCategory.general,
    this.unlocked = false,
    this.unlockedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'unlocked': unlocked,
    'unlockedAt': unlockedAt?.toIso8601String(),
  };

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
    id: json['id'],
    title: '',
    description: '',
    emoji: '',
    unlocked: json['unlocked'] ?? false,
    unlockedAt: json['unlockedAt'] != null ? DateTime.parse(json['unlockedAt']) : null,
  );

  static List<Achievement> getDefaults() => [
    Achievement(id: 'first_tree', title: 'أول شجرة 🌱', description: 'ازرع أول شجرة', emoji: '🌱', category: AchievementCategory.trees),
    Achievement(id: 'forest_10', title: 'غابة صغيرة 🌿', description: 'ازرع 10 أشجار', emoji: '🌿', xpReward: 200, coinReward: 100, category: AchievementCategory.trees),
    Achievement(id: 'forest_50', title: 'غابة كثيفة 🌲', description: 'ازرع 50 شجرة', emoji: '🌲', xpReward: 500, coinReward: 200, category: AchievementCategory.trees),
    Achievement(id: 'forest_100', title: 'غابة مسحورة 🌳', description: 'ازرع 100 شجرة', emoji: '🌳', xpReward: 1000, coinReward: 500, category: AchievementCategory.trees),

    Achievement(id: 'focus_1h', title: 'بداية التركيز ⏱', description: 'أكمل ساعة تركيز', emoji: '⏱', category: AchievementCategory.focus),
    Achievement(id: 'focus_10h', title: 'محارب التركيز ⚔️', description: 'أكمل 10 ساعات تركيز', emoji: '⚔️', xpReward: 300, coinReward: 150, category: AchievementCategory.focus),
    Achievement(id: 'focus_50h', title: 'سيد التركيز 🧠', description: 'أكمل 50 ساعة تركيز', emoji: '🧠', xpReward: 700, coinReward: 350, category: AchievementCategory.focus),
    Achievement(id: 'focus_100h', title: 'أسطورة التركيز 👑', description: 'أكمل 100 ساعة تركيز', emoji: '👑', xpReward: 1500, coinReward: 750, category: AchievementCategory.focus),

    Achievement(id: 'streak_3', title: 'بداية الالتزام 🔥', description: '3 أيام متتالية', emoji: '🔥', category: AchievementCategory.streak),
    Achievement(id: 'streak_7', title: 'أسبوع من النجاح 📅', description: '7 أيام متتالية', emoji: '📅', xpReward: 300, coinReward: 150, category: AchievementCategory.streak),
    Achievement(id: 'streak_30', title: 'شهر بطل 🏅', description: '30 يوم متتالية', emoji: '🏅', xpReward: 1000, coinReward: 500, category: AchievementCategory.streak),
    Achievement(id: 'streak_100', title: 'الأسطورة الخالدة ⭐', description: '100 يوم متتالية', emoji: '⭐', xpReward: 5000, coinReward: 2000, category: AchievementCategory.streak),

    Achievement(id: 'collector_5', title: 'هاوي أشجار 🎋', description: 'افتح 5 أنواع أشجار', emoji: '🎋', category: AchievementCategory.collector),
    Achievement(id: 'collector_15', title: 'جامع أشجار 🌴', description: 'افتح 15 نوع شجر', emoji: '🌴', xpReward: 400, coinReward: 200, category: AchievementCategory.collector),
    Achievement(id: 'collector_30', title: 'موسوعي 🌺', description: 'افتح 30 نوع شجر', emoji: '🌺', xpReward: 800, coinReward: 400, category: AchievementCategory.collector),
    Achievement(id: 'collector_all', title: 'المجمع الكامل 🏆', description: 'افتح كل أنواع الأشجار', emoji: '🏆', xpReward: 3000, coinReward: 1000, category: AchievementCategory.collector),

    Achievement(id: 'level_5', title: 'مبتدئ واعد 📈', description: 'صل للمستوى 5', emoji: '📈', category: AchievementCategory.level),
    Achievement(id: 'level_10', title: 'طالب مجتهد 🎓', description: 'صل للمستوى 10', emoji: '🎓', xpReward: 300, coinReward: 150, category: AchievementCategory.level),
    Achievement(id: 'level_25', title: 'عالم 🌟', description: 'صل للمستوى 25', emoji: '🌟', xpReward: 700, coinReward: 350, category: AchievementCategory.level),
    Achievement(id: 'level_50', title: 'عبقري 💡', description: 'صل للمستوى 50', emoji: '💡', xpReward: 2000, coinReward: 1000, category: AchievementCategory.level),

    Achievement(id: 'tasks_10', title: 'منظم ✅', description: 'أكمل 10 مهام', emoji: '✅', category: AchievementCategory.tasks),
    Achievement(id: 'tasks_50', title: 'منفذ 📋', description: 'أكمل 50 مهمة', emoji: '📋', xpReward: 300, coinReward: 150, category: AchievementCategory.tasks),
    Achievement(id: 'tasks_200', title: 'ماكينة إنجاز 🚀', description: 'أكمل 200 مهمة', emoji: '🚀', xpReward: 1000, coinReward: 500, category: AchievementCategory.tasks),

    Achievement(id: 'prayers_50', title: 'مصلي 🕌', description: '50 صلاة في وقتها', emoji: '🕌', category: AchievementCategory.prayer),
    Achievement(id: 'prayers_200', title: 'خاشع 🤲', description: '200 صلاة في وقتها', emoji: '🤲', xpReward: 500, coinReward: 200, category: AchievementCategory.prayer),
    Achievement(id: 'prayers_1000', title: 'قدوة حسنة ☪️', description: '1000 صلاة في وقتها', emoji: '☪️', xpReward: 2000, coinReward: 1000, category: AchievementCategory.prayer),

    Achievement(id: 'coins_1000', title: 'تاجر صغير 🪙', description: 'اجمع 1000 عملة', emoji: '🪙', category: AchievementCategory.coins),
    Achievement(id: 'coins_10000', title: 'مليونير 💰', description: 'اجمع 10000 عملة', emoji: '💰', xpReward: 500, coinReward: 500, category: AchievementCategory.coins),
    Achievement(id: 'coins_50000', title: 'ثراء أسطوري 💎', description: 'اجمع 50000 عملة', emoji: '💎', xpReward: 2000, coinReward: 2000, category: AchievementCategory.coins),
  ];

  static Achievement getById(String id) {
    return getDefaults().firstWhere((a) => a.id == id, orElse: () => getDefaults().first);
  }
}

enum AchievementCategory {
  trees,
  focus,
  streak,
  collector,
  level,
  tasks,
  prayer,
  coins,
  general,
}

extension AchievementCategoryExt on AchievementCategory {
  String get label {
    switch (this) {
      case AchievementCategory.trees: return '🌳 أشجار';
      case AchievementCategory.focus: return '⏱ تركيز';
      case AchievementCategory.streak: return '🔥 استمرارية';
      case AchievementCategory.collector: return '🎋 جمع';
      case AchievementCategory.level: return '📈 مستوى';
      case AchievementCategory.tasks: return '✅ مهام';
      case AchievementCategory.prayer: return '🕌 صلاة';
      case AchievementCategory.coins: return '💰 عملات';
      case AchievementCategory.general: return '🎯 عام';
    }
  }

  Color get color {
    switch (this) {
      case AchievementCategory.trees: return Colors.green;
      case AchievementCategory.focus: return Colors.blue;
      case AchievementCategory.streak: return Colors.orange;
      case AchievementCategory.collector: return Colors.purple;
      case AchievementCategory.level: return Colors.teal;
      case AchievementCategory.tasks: return Colors.indigo;
      case AchievementCategory.prayer: return Colors.brown;
      case AchievementCategory.coins: return Colors.amber;
      case AchievementCategory.general: return Colors.grey;
    }
  }
}
