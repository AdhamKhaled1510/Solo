enum QuestType { daily, weekly, story }
enum QuestStatus { active, completed, claimed }

class QuestModel {
  final String id;
  final String title;
  final String description;
  final QuestType type;
  int targetProgress;
  int currentProgress;
  final int xpReward;
  final int coinReward;
  final String? treeReward;
  QuestStatus status;

  QuestModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.type,
    this.targetProgress = 1,
    this.currentProgress = 0,
    this.xpReward = 40,
    this.coinReward = 10,
    this.treeReward,
    this.status = QuestStatus.active,
  });

  double get progress => targetProgress > 0 ? currentProgress / targetProgress : 0.0;
  bool get isComplete => currentProgress >= targetProgress;

  void addProgress(int amount) {
    currentProgress += amount;
    if (currentProgress >= targetProgress && status == QuestStatus.active) {
      status = QuestStatus.completed;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'type': type.index,
    'targetProgress': targetProgress,
    'currentProgress': currentProgress,
    'xpReward': xpReward,
    'coinReward': coinReward,
    'treeReward': treeReward,
    'status': status.index,
  };

  factory QuestModel.fromJson(Map<String, dynamic> json) => QuestModel(
    id: json['id'],
    title: json['title'],
    description: json['description'] ?? '',
    type: QuestType.values[json['type']],
    targetProgress: json['targetProgress'] ?? 1,
    currentProgress: json['currentProgress'] ?? 0,
    xpReward: json['xpReward'] ?? 40,
    coinReward: json['coinReward'] ?? 10,
    treeReward: json['treeReward'],
    status: QuestStatus.values[json['status'] ?? 0],
  );
}

class QuestDefinition {
  final String id;
  final String title;
  final String description;
  final QuestType type;
  final int targetProgress;
  final int xpReward;
  final int coinReward;
  final String? treeReward;

  const QuestDefinition({
    required this.id,
    required this.title,
    this.description = '',
    required this.type,
    this.targetProgress = 1,
    this.xpReward = 40,
    this.coinReward = 10,
    this.treeReward,
  });

  QuestModel createQuest() => QuestModel(
    id: id,
    title: title,
    description: description,
    type: type,
    targetProgress: targetProgress,
    xpReward: xpReward,
    coinReward: coinReward,
    treeReward: treeReward,
  );

  static const List<QuestDefinition> dailyQuests = [
    QuestDefinition(id: 'daily_focus_60', title: 'ركز ٦٠ دقيقة', description: 'أكمل 60 دقيقة تركيز', type: QuestType.daily, targetProgress: 60, xpReward: 40, coinReward: 10),
    QuestDefinition(id: 'daily_tasks_3', title: 'أنهي ٣ مهام', description: 'أكمل 3 مهام من قائمتك', type: QuestType.daily, targetProgress: 3, xpReward: 30, coinReward: 5),
    QuestDefinition(id: 'daily_prayers_5', title: 'صلي ٥ فروض', description: 'صلي جميع الصلوات الخمس', type: QuestType.daily, targetProgress: 5, xpReward: 50, coinReward: 15),
    QuestDefinition(id: 'daily_quran', title: 'اقرأ ورد القرآن', description: 'أكمل وردك اليومي', type: QuestType.daily, targetProgress: 1, xpReward: 25, coinReward: 5),
    QuestDefinition(id: 'daily_azkar', title: 'أذكار الصباح والمساء', description: 'أتم الأذكار', type: QuestType.daily, targetProgress: 2, xpReward: 20, coinReward: 5),
  ];

  static const List<QuestDefinition> weeklyQuests = [
    QuestDefinition(id: 'weekly_focus_600', title: 'ركز ١٠ ساعات', description: 'أكمل 10 ساعات تركيز', type: QuestType.weekly, targetProgress: 600, xpReward: 300, coinReward: 50, treeReward: 'cherry'),
    QuestDefinition(id: 'weekly_tasks_20', title: 'أنهي ٢٠ مهمة', description: 'أكمل 20 مهمة', type: QuestType.weekly, targetProgress: 20, xpReward: 200, coinReward: 30),
    QuestDefinition(id: 'weekly_prayers_35', title: 'صلي كل الفروض ٧ أيام', description: 'صلي 35 فرض في وقتها', type: QuestType.weekly, targetProgress: 35, xpReward: 500, coinReward: 100, treeReward: 'moon_tree'),
    QuestDefinition(id: 'weekly_streak_7', title: 'Streak ٧ أيام', description: 'افتح التطبيق 7 أيام متتالية', type: QuestType.weekly, targetProgress: 7, xpReward: 250, coinReward: 40),
  ];

  static const List<QuestDefinition> storyQuests = [
    QuestDefinition(id: 'story_plant_50', title: 'ازرع 50 شجرة', description: 'مهمة قصة: ازرع 50 شجرة في حديقتك', type: QuestType.story, targetProgress: 50, xpReward: 1000, coinReward: 500, treeReward: 'forest_spirit'),
    QuestDefinition(id: 'story_focus_50h', title: '50 ساعة تركيز', description: 'مهمة قصة: أكمل 50 ساعة تركيز', type: QuestType.story, targetProgress: 3000, xpReward: 1500, coinReward: 750, treeReward: 'celestial_tree'),
    QuestDefinition(id: 'story_level_25', title: 'المستوى 25', description: 'مهمة قصة: ارفع مستواك إلى 25', type: QuestType.story, targetProgress: 25, xpReward: 2000, coinReward: 1000, treeReward: 'golden_wings'),
  ];
}
