class TreeSpecies {
  final String id;
  final String emoji;
  final String name;
  final String description;
  final TreeRarity rarity;
  final int cost;
  final int requiredLevel;
  final bool seasonal;
  final DateTime? availableUntil;

  const TreeSpecies({
    required this.id,
    required this.emoji,
    required this.name,
    required this.description,
    this.rarity = TreeRarity.common,
    this.cost = 0,
    this.requiredLevel = 0,
    this.seasonal = false,
    this.availableUntil,
  });

  bool get isAvailable {
    if (!seasonal) return true;
    if (availableUntil == null) return true;
    return DateTime.now().isBefore(availableUntil!);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'emoji': emoji,
    'name': name,
    'description': description,
    'rarity': rarity.index,
    'cost': cost,
    'requiredLevel': requiredLevel,
    'seasonal': seasonal,
    'availableUntil': availableUntil?.toIso8601String(),
  };

  factory TreeSpecies.fromJson(Map<String, dynamic> json) => TreeSpecies(
    id: json['id'],
    emoji: json['emoji'],
    name: json['name'],
    description: json['description'],
    rarity: TreeRarity.values[json['rarity'] ?? 0],
    cost: json['cost'] ?? 0,
    requiredLevel: json['requiredLevel'] ?? 0,
    seasonal: json['seasonal'] ?? false,
    availableUntil: json['availableUntil'] != null ? DateTime.parse(json['availableUntil']) : null,
  );

  static List<TreeSpecies> getDefaults() => [
    // Free (unlocked by default)
    TreeSpecies(id: 'star_coral', emoji: '🪸', name: 'Star Coral', description: 'مرجانية نجمية', cost: 0),
    TreeSpecies(id: 'statue_tada', emoji: '🗿', name: 'Statue of Tada', description: 'تمثال تادا', cost: 0),
    TreeSpecies(id: 'lavender', emoji: '💜', name: 'Lavender', description: 'لافندر', cost: 0),

    // 300 coins - رخيصة
    TreeSpecies(id: 'mushroom', emoji: '🍄', name: 'Mushroom', description: 'فطر صغير', cost: 300),
    TreeSpecies(id: 'pumpkin', emoji: '🎃', name: 'Pumpkin', description: 'قرعة برتقالية', cost: 300),
    TreeSpecies(id: 'ball_cactus', emoji: '🌵', name: 'Ball Cactus', description: 'صبار كروي', cost: 300),
    TreeSpecies(id: 'flourishing_grass', emoji: '🌱', name: 'Flourishing Grass', description: 'عشب أخضر', cost: 300),
    TreeSpecies(id: 'octopus', emoji: '🐙', name: 'Octopus', description: 'أخطبوط الشجر', cost: 300),
    TreeSpecies(id: 'treehouse', emoji: '🏠', name: 'Treehouse', description: 'بيت في الشجرة', cost: 300),
    TreeSpecies(id: 'flower_tree', emoji: '🌺', name: 'Flower Tree', description: 'شجرة أزهار', cost: 300),
    TreeSpecies(id: 'cuckoo_clock', emoji: '🕰️', name: 'Cuckoo Clock', description: 'ساعة الوقواق', cost: 300),

    // 600 coins - متوسطة
    TreeSpecies(id: 'rafflesia', emoji: '🌺', name: 'Rafflesia', description: 'أكبر زهرة في العالم', cost: 600),
    TreeSpecies(id: 'watermelon', emoji: '🍉', name: 'Watermelon', description: 'بطيخ منعش', cost: 600),
    TreeSpecies(id: 'scarecrow', emoji: '🧑‍🌾', name: 'Scarecrow', description: 'فزاعة الحقل', cost: 600),
    TreeSpecies(id: 'chinese_pine', emoji: '🎄', name: 'Chinese Pine', description: 'صنوبر صيني', cost: 600),
    TreeSpecies(id: 'kitty', emoji: '🐱', name: 'Kitty', description: 'قطّة لطيفة', cost: 600),
    TreeSpecies(id: 'coconut', emoji: '🥥', name: 'Coconut Tree', description: 'جوز الهند', cost: 600),
    TreeSpecies(id: 'triplets', emoji: '👨‍👩‍👧', name: 'Triplets', description: 'ثلاثة توائم', cost: 600),
    TreeSpecies(id: 'lemon', emoji: '🍋', name: 'Lemon Tree', description: 'ليمون حامض', cost: 600),
    TreeSpecies(id: 'nest', emoji: '🪺', name: 'Nest', description: 'عش العصافير', cost: 600),
    TreeSpecies(id: 'doggo', emoji: '🐕', name: 'Doggo Tree', description: 'شجرة الكلب', cost: 600),
    TreeSpecies(id: 'blue_flower', emoji: '💙', name: 'Blue Flower', description: 'زهرة زرقاء', cost: 600),
    TreeSpecies(id: 'carnation', emoji: '🌸', name: 'Carnation', description: 'قرنفل', cost: 600),
    TreeSpecies(id: 'lover', emoji: '💑', name: 'Lover Tree', description: 'شجرة العشاق', cost: 600),
    TreeSpecies(id: 'lotus', emoji: '🪷', name: 'Lotus', description: 'لوتس', cost: 600),

    // 1200 coins - أغلى
    TreeSpecies(id: 'baobab', emoji: '🌳', name: 'Baobab', description: 'شجرة التبلدي العملاقة', cost: 1200),
    TreeSpecies(id: 'rose', emoji: '🌹', name: 'Rose', description: 'وردة حمراء', cost: 1200),
    TreeSpecies(id: 'bamboo', emoji: '🎋', name: 'Bamboo', description: 'خيزران', cost: 1200),
    TreeSpecies(id: 'cactus', emoji: '🌵', name: 'Cactus', description: 'صبار كبير', cost: 1200),
    TreeSpecies(id: 'cherry', emoji: '🌸', name: 'Cherry Blossom', description: 'أزهار الكرز', cost: 1200),
    TreeSpecies(id: 'cat_tail_willow', emoji: '🌿', name: 'Cat-tail Willow', description: 'صفصاف ذيل القط', cost: 1200),
    TreeSpecies(id: 'oak', emoji: '🌳', name: 'Oak Tree', description: 'شجرة بلوط قوية', cost: 1200),
    TreeSpecies(id: 'ghost_mushroom', emoji: '👻', name: 'Ghost Mushroom', description: 'فطر شبح', cost: 1200),
    TreeSpecies(id: 'rainbow_flower', emoji: '🌈', name: 'Rainbow Flower', description: 'زهرة قوس قزح', cost: 1200),
    TreeSpecies(id: 'moon_tree', emoji: '🌙', name: 'Moon Tree', description: 'شجرة القمر', cost: 1200),
    TreeSpecies(id: 'apple_tree', emoji: '🍎', name: 'Apple Tree', description: 'شجرة تفاح', cost: 1200),
    TreeSpecies(id: 'banana', emoji: '🍌', name: 'Banana', description: 'موز', cost: 1200),
    TreeSpecies(id: 'tulip', emoji: '🌷', name: 'Tulip', description: 'تيوليب', cost: 1200),
    TreeSpecies(id: 'lily', emoji: '🪷', name: 'Lily Flower', description: 'زنبقة', cost: 1200),
    TreeSpecies(id: 'witch_mushroom', emoji: '🧙', name: 'Witch Mushroom', description: 'فطر الساحرة', cost: 1200),
    TreeSpecies(id: 'sundae', emoji: '🍦', name: 'Sundae Tree', description: 'شجرة الآيس كريم', cost: 1200),
    TreeSpecies(id: 'water_spirit', emoji: '💧', name: 'Water Spirit', description: 'روح الماء', cost: 1200),
    TreeSpecies(id: 'four_leaf_clover', emoji: '🍀', name: 'Four-leaf Clover', description: 'نفل رباعي', cost: 1200),
    TreeSpecies(id: 'bear_paw', emoji: '🐾', name: 'Bear\'s Paw', description: 'مخلب الدب', cost: 1200),
    TreeSpecies(id: 'balloon_flower', emoji: '🎈', name: 'Balloon Flower', description: 'زهرة البالون', cost: 1200),
    TreeSpecies(id: 'geraniums', emoji: '💐', name: 'Geraniums', description: 'إبرة الراعي', cost: 1200),
    TreeSpecies(id: 'tangerine', emoji: '🍊', name: 'Tangerine Tree', description: 'يوسفي', cost: 1200),
    TreeSpecies(id: 'narcissus', emoji: '🌼', name: 'Narcissus', description: 'نرجس', cost: 1200),
    TreeSpecies(id: 'cosmos', emoji: '✨', name: 'Cosmos', description: 'كوزموس', cost: 1200),
    TreeSpecies(id: 'osmanthus', emoji: '🌼', name: 'Osmanthus', description: 'أسمانثوس', cost: 1200),
    TreeSpecies(id: 'rice', emoji: '🌾', name: 'Rice', description: 'أرز', cost: 1200),
    TreeSpecies(id: 'camellia', emoji: '🌺', name: 'Camellia', description: 'كاميليا', cost: 1200),

    // 2000 coins - نادرة
    TreeSpecies(id: 'maple', emoji: '🍁', name: 'Maple', description: 'شجرة قيقب حمراء', rarity: TreeRarity.rare, cost: 2000, requiredLevel: 10),
    TreeSpecies(id: 'sunflower', emoji: '🌻', name: 'Sunflower', description: 'دوار الشمس', rarity: TreeRarity.rare, cost: 2000, requiredLevel: 10),
    TreeSpecies(id: 'candy_tree', emoji: '🍭', name: 'Candy Tree', description: 'شجرة الحلوى', rarity: TreeRarity.rare, cost: 2000, requiredLevel: 10),
    TreeSpecies(id: 'wisteria', emoji: '💜', name: 'Wisteria', description: 'وستيريا متسلقة', rarity: TreeRarity.rare, cost: 2000, requiredLevel: 10),
    TreeSpecies(id: 'ginkgo', emoji: '🍂', name: 'Ginkgo', description: 'شجرة الجنكة', rarity: TreeRarity.rare, cost: 2000, requiredLevel: 10),
    TreeSpecies(id: 'starry_tree', emoji: '⭐', name: 'Starry Tree', description: 'شجرة نجمية', rarity: TreeRarity.rare, cost: 2000, requiredLevel: 12),
    TreeSpecies(id: 'plum_blossom', emoji: '🌸', name: 'Plum Blossom', description: 'زهر البرقوق', rarity: TreeRarity.rare, cost: 2000, requiredLevel: 12),
    TreeSpecies(id: 'forest_spirit', emoji: '🧝', name: 'Forest Spirit', description: 'روح الغابة', rarity: TreeRarity.rare, cost: 2000, requiredLevel: 12),
    TreeSpecies(id: 'weeping_willow', emoji: '🌿', name: 'Weeping Willow', description: 'صفصاف باكي', rarity: TreeRarity.rare, cost: 2000, requiredLevel: 15),
    TreeSpecies(id: 'celestial_tree', emoji: '🌌', name: 'Celestial Tree', description: 'شجرة سماوية', rarity: TreeRarity.rare, cost: 2000, requiredLevel: 15),
    TreeSpecies(id: 'jacaranda', emoji: '💜', name: 'Jacaranda', description: 'جاكاراندا بنفسجية', rarity: TreeRarity.rare, cost: 2000, requiredLevel: 15),
    TreeSpecies(id: 'golden_trumpet', emoji: '🌼', name: 'Golden Trumpet', description: 'بوق ذهبي', rarity: TreeRarity.rare, cost: 2000, requiredLevel: 15),
    TreeSpecies(id: 'golden_wings', emoji: '🦋', name: 'Golden Wings', description: 'أجنحة ذهبية', rarity: TreeRarity.rare, cost: 2000, requiredLevel: 15),
  ];

  static TreeSpecies getById(String id) {
    return getDefaults().firstWhere((t) => t.id == id, orElse: () => getDefaults().first);
  }
}

enum TreeRarity {
  common,
  uncommon,
  rare,
  legendary,
  seasonal,
}

extension TreeRarityExt on TreeRarity {
  String get label {
    switch (this) {
      case TreeRarity.common: return 'شائع';
      case TreeRarity.uncommon: return 'غير شائع';
      case TreeRarity.rare: return 'نادر';
      case TreeRarity.legendary: return 'أسطوري';
      case TreeRarity.seasonal: return 'موسمي';
    }
  }

  String get emoji {
    switch (this) {
      case TreeRarity.common: return '🟢';
      case TreeRarity.uncommon: return '🔵';
      case TreeRarity.rare: return '🟣';
      case TreeRarity.legendary: return '🔴';
      case TreeRarity.seasonal: return '🟡';
    }
  }
}
