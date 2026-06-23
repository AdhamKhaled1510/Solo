class PetModel {
  final String id;
  final String name;
  final String emoji;
  String description;
  int level;
  int xp;
  bool owned;
  bool equipped;

  PetModel({
    required this.id,
    required this.name,
    required this.emoji,
    this.description = '',
    this.level = 1,
    this.xp = 0,
    this.owned = false,
    this.equipped = false,
  });

  int get xpForNextLevel => level * 100;
  double get levelProgress => xpForNextLevel > 0 ? (xp / xpForNextLevel).clamp(0.0, 1.0) : 0.0;

  void addXp(int amount) {
    xp += amount;
    while (xp >= xpForNextLevel && level < 50) {
      xp -= xpForNextLevel;
      level++;
    }
  }

  String get evolution {
    if (level >= 40) return 'أسطوري ✨';
    if (level >= 25) return 'متطور 💫';
    if (level >= 10) return 'قوي ⚡';
    return 'صغير 🌱';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'emoji': emoji,
    'description': description,
    'level': level,
    'xp': xp,
    'owned': owned,
    'equipped': equipped,
  };

  factory PetModel.fromJson(Map<String, dynamic> json) => PetModel(
    id: json['id'],
    name: json['name'],
    emoji: json['emoji'],
    description: json['description'] ?? '',
    level: json['level'] ?? 1,
    xp: json['xp'] ?? 0,
    owned: json['owned'] ?? false,
    equipped: json['equipped'] ?? false,
  );

  static List<PetModel> getDefaultPets() => [
    PetModel(id: 'owl', name: 'بومة الحكمة', emoji: '🦉', description: 'تزيد XP المذاكرة +5%'),
    PetModel(id: 'dove', name: 'حمامة السلام', emoji: '🕊️', description: 'تزيد XP الصلاة +5%'),
    PetModel(id: 'rabbit', name: 'أرنب النشاط', emoji: '🐰', description: 'تزيد XP المهام +5%'),
    PetModel(id: 'phoenix', name: 'طائر الفينيق', emoji: '🔥', description: 'تعيد Shield كل أسبوع', owned: false),
    PetModel(id: 'dragon', name: 'التنين الصغير', emoji: '🐉', description: 'تزيد كل XP +10%', owned: false),
  ];
}
