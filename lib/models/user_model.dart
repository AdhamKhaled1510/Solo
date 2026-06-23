import 'achievement.dart';
import 'solo_rank.dart';
import 'skill_model.dart';
import 'avatar_item.dart';
import 'pet_model.dart';
import 'inventory_item.dart';
import 'party_model.dart';

class UserModel {
  final String id;
  String name;
  String email;
  int level;
  int xp;
  int coins;
  int streakDays;
  int totalFocusMinutes;
  int totalTreesPlanted;
  int totalPrayersOnTime;
  int completedTasks;
  int completedQuests;
  int skillPoints;
  int shields;
  DateTime? lastActiveDate;

  // Solo RPG system
  SoloRank rank;
  SubjectBranch? branch;
  List<SkillModel> skills;
  List<AvatarItem> avatarItems;
  List<PetModel> pets;
  List<InventoryItem> inventory;
  List<BossFight> bossFights;
  PartyModel? party;
  String? partyId;

  // Equipped items
  String? equippedCrownId;
  String? equippedAuraId;
  String? equippedGlassesId;
  String? equippedOutfitId;
  String? equippedTitleId;
  String? equippedPetId;

  // Unlocks
  List<String> unlockedTrees;
  List<String> unlockedLandmarks;
  List<String> ownedCosmetics;
  String? selectedAvatarId;
  bool isDarkMode;
  List<Achievement> achievements;

  UserModel({
    required this.id,
    this.name = '',
    this.email = '',
    this.level = 1,
    this.xp = 0,
    this.coins = 0,
    this.streakDays = 0,
    this.totalFocusMinutes = 0,
    this.totalTreesPlanted = 0,
    this.totalPrayersOnTime = 0,
    this.completedTasks = 0,
    this.completedQuests = 0,
    this.skillPoints = 0,
    this.shields = 0,
    this.lastActiveDate,
    this.rank = SoloRank.e,
    this.branch,
    this.skills = const [],
    this.avatarItems = const [],
    this.pets = const [],
    this.inventory = const [],
    this.bossFights = const [],
    this.party,
    this.partyId,
    this.equippedCrownId,
    this.equippedAuraId,
    this.equippedGlassesId,
    this.equippedOutfitId,
    this.equippedTitleId,
    this.equippedPetId,
    this.unlockedTrees = const ['star_coral', 'statue_tada', 'lavender'],
    this.unlockedLandmarks = const [],
    this.ownedCosmetics = const [],
    this.selectedAvatarId,
    this.isDarkMode = false,
    this.achievements = const [],
  });

  // Computed
  int get xpForNextLevel => level * 200;
  double get levelProgress => xpForNextLevel > 0 ? (xp / xpForNextLevel).clamp(0.0, 1.0) : 0.0;

  SoloRank get currentRank {
    for (final r in SoloRank.values.reversed) {
      if (level >= r.requiredLevel) return r;
    }
    return SoloRank.e;
  }

  // Equipped items emojis for display
  String get equippedCrownEmoji => avatarItems
    .where((a) => a.id == equippedCrownId && a.equipped)
    .map((a) => a.emoji)
    .firstOrNull ?? '';
  String get equippedAuraEmoji => avatarItems
    .where((a) => a.id == equippedAuraId && a.equipped)
    .map((a) => a.emoji)
    .firstOrNull ?? '';
  String get equippedGlassesEmoji => avatarItems
    .where((a) => a.id == equippedGlassesId && a.equipped)
    .map((a) => a.emoji)
    .firstOrNull ?? '';
  String get equippedOutfitEmoji => avatarItems
    .where((a) => a.id == equippedOutfitId && a.equipped)
    .map((a) => a.emoji)
    .firstOrNull ?? '';
  String get equippedTitleEmoji => avatarItems
    .where((a) => a.id == equippedTitleId && a.equipped)
    .map((a) => a.emoji)
    .firstOrNull ?? '';
  PetModel? get equippedPet => pets.where((p) => p.equipped).firstOrNull;

  // XP multipliers from skills
  double get focusXpMultiplier => 1.0 + skills
    .where((s) => s.unlocked && s.effect == 'xp_boost_focus')
    .fold(0.0, (sum, s) => sum + s.value);
  double get memoryXpMultiplier => 1.0 + skills
    .where((s) => s.unlocked && s.effect == 'xp_boost_memory')
    .fold(0.0, (sum, s) => sum + s.value);

  double get subjectXpMultiplier => 1.0 + skills
    .where((s) => s.unlocked && s.effect == 'xp_boost_subject')
    .fold(0.0, (sum, s) => sum + s.value);

  int get shieldCount => shields + skills
    .where((s) => s.unlocked && s.effect == 'shield')
    .fold(0, (sum, s) => sum + s.value.toInt());

  // Methods
  void addXp(int amount) {
    xp += amount;
    while (xp >= xpForNextLevel) {
      xp -= xpForNextLevel;
      level++;
      skillPoints++;
      coins += level * 10;
      checkRankUp();
    }
  }

  void checkRankUp() {
    final newRank = currentRank;
    if (newRank != rank) {
      rank = newRank;
      coins += rank.requiredLevel * 20;
      skillPoints += 2;
    }
  }

  void addCoins(int amount) => coins += amount;

  bool spendCoins(int amount) {
    if (coins >= amount) {
      coins -= amount;
      return true;
    }
    return false;
  }

  void useShield() {
    if (shields > 0) shields--;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'level': level,
    'xp': xp,
    'coins': coins,
    'streakDays': streakDays,
    'totalFocusMinutes': totalFocusMinutes,
    'totalTreesPlanted': totalTreesPlanted,
    'totalPrayersOnTime': totalPrayersOnTime,
    'completedTasks': completedTasks,
    'completedQuests': completedQuests,
    'skillPoints': skillPoints,
    'shields': shields,
    'lastActiveDate': lastActiveDate?.toIso8601String(),
    'rank': rank.index,
    'branch': branch?.index,
    'skills': skills.map((s) => s.toJson()).toList(),
    'avatarItems': avatarItems.map((a) => a.toJson()).toList(),
    'pets': pets.map((p) => p.toJson()).toList(),
    'inventory': inventory.map((i) => i.toJson()).toList(),
    'bossFights': bossFights.map((b) => b.toJson()).toList(),
    'partyId': partyId,
    'equippedCrownId': equippedCrownId,
    'equippedAuraId': equippedAuraId,
    'equippedGlassesId': equippedGlassesId,
    'equippedOutfitId': equippedOutfitId,
    'equippedTitleId': equippedTitleId,
    'equippedPetId': equippedPetId,
    'unlockedTrees': unlockedTrees,
    'unlockedLandmarks': unlockedLandmarks,
    'ownedCosmetics': ownedCosmetics,
    'selectedAvatarId': selectedAvatarId,
    'isDarkMode': isDarkMode,
    'achievements': achievements.map((a) => a.toJson()).toList(),
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    level: json['level'] ?? 1,
    xp: json['xp'] ?? 0,
    coins: json['coins'] ?? 0,
    streakDays: json['streakDays'] ?? 0,
    totalFocusMinutes: json['totalFocusMinutes'] ?? 0,
    totalTreesPlanted: json['totalTreesPlanted'] ?? 0,
    totalPrayersOnTime: json['totalPrayersOnTime'] ?? 0,
    completedTasks: json['completedTasks'] ?? 0,
    completedQuests: json['completedQuests'] ?? 0,
    skillPoints: json['skillPoints'] ?? 0,
    shields: json['shields'] ?? 0,
    lastActiveDate: json['lastActiveDate'] != null ? DateTime.parse(json['lastActiveDate']) : null,
    rank: SoloRank.values[json['rank'] ?? 0],
    branch: json['branch'] != null ? SubjectBranch.values[json['branch']] : null,
    skills: (json['skills'] as List?)?.map((e) => SkillModel.fromJson(e)).toList() ?? [],
    avatarItems: (json['avatarItems'] as List?)?.map((e) => AvatarItem.fromJson(e)).toList() ?? [],
    pets: (json['pets'] as List?)?.map((e) => PetModel.fromJson(e)).toList() ?? [],
    inventory: (json['inventory'] as List?)?.map((e) => InventoryItem.fromJson(e)).toList() ?? [],
    bossFights: (json['bossFights'] as List?)?.map((e) => BossFight.fromJson(e)).toList() ?? [],
    partyId: json['partyId'],
    equippedCrownId: json['equippedCrownId'],
    equippedAuraId: json['equippedAuraId'],
    equippedGlassesId: json['equippedGlassesId'],
    equippedOutfitId: json['equippedOutfitId'],
    equippedTitleId: json['equippedTitleId'],
    equippedPetId: json['equippedPetId'],
    unlockedTrees: List<String>.from(json['unlockedTrees'] ?? ['star_coral', 'statue_tada', 'lavender']),
    unlockedLandmarks: List<String>.from(json['unlockedLandmarks'] ?? []),
    ownedCosmetics: List<String>.from(json['ownedCosmetics'] ?? []),
    selectedAvatarId: json['selectedAvatarId'],
    isDarkMode: json['isDarkMode'] ?? false,
    achievements: (json['achievements'] as List?)?.map((e) => Achievement.fromJson(e)).toList() ?? [],
  );
}
