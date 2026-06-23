import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/task_model.dart';
import '../models/prayer_model.dart';
import '../models/focus_session.dart';
import '../models/quest_model.dart';
import '../models/skill_model.dart';
import '../models/avatar_item.dart';
import '../models/pet_model.dart';
import '../models/inventory_item.dart';
import '../models/tree_species.dart';
import '../models/party_model.dart';
import '../models/achievement.dart';
import '../models/solo_rank.dart';
import '../services/storage_service.dart';

class AppProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();

  UserModel? _user;
  UserModel get user => _user!;
  bool get isLoggedIn => _user != null;

  List<TaskModel> _tasks = [];
  List<TaskModel> get tasks => _tasks;
  List<TaskModel> get todayTasks => _tasks.where((t) {
    if (t.dueDate == null) return false;
    final now = DateTime.now();
    return t.dueDate!.year == now.year && t.dueDate!.month == now.month && t.dueDate!.day == now.day;
  }).toList();
  List<TaskModel> get pendingTasks => _tasks.where((t) => !t.isCompleted).toList();

  PrayerDay? _prayerToday;
  PrayerDay get prayerToday => _prayerToday!;

  List<FocusSession> _sessions = [];
  List<FocusSession> get sessions => _sessions;

  List<QuestModel> _quests = [];
  List<QuestModel> get quests => _quests;
  List<QuestModel> get dailyQuests => _quests.where((q) => q.type == QuestType.daily).toList();
  List<QuestModel> get weeklyQuests => _quests.where((q) => q.type == QuestType.weekly).toList();

  List<Map<String, dynamic>> _garden = [];
  List<Map<String, dynamic>> get garden => _garden;

  bool _isFocusing = false;
  bool get isFocusing => _isFocusing;
  int _focusDuration = 25;
  int get focusDuration => _focusDuration;
  int _breakDuration = 5;
  int get breakDuration => _breakDuration;

  DateTime? _boosterEndTime;
  bool get hasActiveBooster => _boosterEndTime != null && DateTime.now().isBefore(_boosterEndTime!);
  double get boosterMultiplier => hasActiveBooster ? 2.0 : 1.0;

  void init() {
    _user = _storage.loadUser();
    if (_user == null) {
      _user = _storage.createNewUser('user_${DateTime.now().millisecondsSinceEpoch}');
      _user!.skills = SkillModel.getDefaultSkills();
      _user!.avatarItems = AvatarItem.getDefaultItems();
      _user!.pets = PetModel.getDefaultPets();
      _user!.pets[0].owned = true;
    }
    _tasks = _storage.loadTasks();
    _prayerToday = _storage.getOrCreatePrayerToday();
    _sessions = _storage.loadSessions();
    _quests = _storage.loadQuests();
    _garden = _storage.loadGarden();
    _initAchievements();
    _initStoryQuests();
    checkDailyReset();
    notifyListeners();
  }

  void checkDailyReset() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (_user!.lastActiveDate == null || _user!.lastActiveDate!.isBefore(today)) {
      if (_user!.lastActiveDate != null && _user!.lastActiveDate!.difference(today).inDays == -1) {
        _user!.streakDays++;
      } else if (_user!.lastActiveDate != null) {
        if (_user!.shieldCount == 0) _user!.streakDays = 0;
        else _user!.useShield();
      }
      _user!.lastActiveDate = now;
      _storage.saveUser(_user!);
      if (_prayerToday == null || _prayerToday!.date.day != now.day) {
        _prayerToday = PrayerDay(date: now);
        _storage.savePrayerToday(_prayerToday!);
      }
      _resetDailyQuests();
    }
  }

  void _resetDailyQuests() {
    _quests.removeWhere((q) => q.type == QuestType.daily);
    for (final def in QuestDefinition.dailyQuests) {
      _quests.add(def.createQuest());
    }
    _storage.saveQuests(_quests);
  }

  void _initStoryQuests() {
    final hasStoryQuests = _quests.any((q) => q.type == QuestType.story);
    if (!hasStoryQuests) {
      for (final def in QuestDefinition.storyQuests) {
        _quests.add(def.createQuest());
      }
      _storage.saveQuests(_quests);
    }
  }

  // === Timer ===
  void setFocusDuration(int minutes) { _focusDuration = minutes; notifyListeners(); }
  void setBreakDuration(int minutes) { _breakDuration = minutes; notifyListeners(); }
  void startFocusing() { _isFocusing = true; notifyListeners(); }
  void stopFocusing() { _isFocusing = false; notifyListeners(); }

  void completeFocusSession(int minutes, {String treeId = 'star_coral', String tag = ''}) {
    _isFocusing = false;
    final session = FocusSession(
      id: 'session_${DateTime.now().millisecondsSinceEpoch}',
      startTime: DateTime.now().subtract(Duration(minutes: minutes)),
      endTime: DateTime.now(),
      durationMinutes: minutes,
      completed: true,
      treeType: treeId,
      tag: tag,
    );
    _sessions.add(session);
    _storage.saveSessions(_sessions);

    _user!.totalFocusMinutes += minutes;
    final xpGain = (minutes * 2 * _user!.focusXpMultiplier * boosterMultiplier).round();
    _user!.addXp(xpGain);
    _user!.addCoins(minutes);
    _user!.totalTreesPlanted++;
    _storage.saveUser(_user!);
    _storage.addTreeToGarden(treeId);
    _garden = _storage.loadGarden();

    if (_user!.equippedPet != null) {
      final pet = _user!.equippedPet!;
      pet.addXp(minutes);
      _storage.saveUser(_user!);
    }

    updateQuestProgress('daily_focus_60', minutes);
    checkAchievements();
    notifyListeners();
  }

  // === Tasks ===
  void addTask(TaskModel task) {
    _tasks.add(task);
    _storage.saveTasks(_tasks);
    notifyListeners();
  }

  void toggleTask(String taskId) {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    task.isCompleted = !task.isCompleted;
    task.completedAt = task.isCompleted ? DateTime.now() : null;
    if (task.isCompleted) {
      _user!.completedTasks++;
      _user!.addXp(20);
      _user!.addCoins(5);
    }
    _storage.saveTasks(_tasks);
    _storage.saveUser(_user!);
    updateQuestProgress('daily_tasks_3', _user!.completedTasks);
    checkAchievements();
    notifyListeners();
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((t) => t.id == taskId);
    _storage.saveTasks(_tasks);
    notifyListeners();
  }

  void updateTask(TaskModel task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      _storage.saveTasks(_tasks);
      notifyListeners();
    }
  }

  // === Prayer ===
  void togglePrayer(String prayerName) {
    switch (prayerName) {
      case 'Fajr': _prayerToday!.fajr = !_prayerToday!.fajr;
      case 'Dhuhr': _prayerToday!.dhuhr = !_prayerToday!.dhuhr;
      case 'Asr': _prayerToday!.asr = !_prayerToday!.asr;
      case 'Maghrib': _prayerToday!.maghrib = !_prayerToday!.maghrib;
      case 'Isha': _prayerToday!.isha = !_prayerToday!.isha;
    }
    if (_prayerToday!.allPrayersDone) {
      _user!.totalPrayersOnTime++;
      _user!.addXp(50);
      _user!.addCoins(15);
    }
    _storage.savePrayerToday(_prayerToday!);
    _storage.saveUser(_user!);
    updateQuestProgress('daily_prayers_5', _prayerToday!.completedPrayers);
    checkAchievements();
    notifyListeners();
  }

  void setQuranPages(int pages) {
    _prayerToday!.quranPages = pages;
    _storage.savePrayerToday(_prayerToday!);
    if (pages > 0) updateQuestProgress('daily_quran', 1);
    notifyListeners();
  }

  void toggleAzkar(bool isMorning) {
    if (isMorning) _prayerToday!.morningAzkar = !_prayerToday!.morningAzkar;
    else _prayerToday!.eveningAzkar = !_prayerToday!.eveningAzkar;
    _storage.savePrayerToday(_prayerToday!);
    final completed = (_prayerToday!.morningAzkar ? 1 : 0) + (_prayerToday!.eveningAzkar ? 1 : 0);
    updateQuestProgress('daily_azkar', completed);
    notifyListeners();
  }

  // === Quests ===
  void updateQuestProgress(String questId, int value) {
    for (final quest in _quests) {
      if (quest.id == questId && quest.status == QuestStatus.active) {
        quest.currentProgress = value;
        if (quest.isComplete) quest.status = QuestStatus.completed;
      }
    }
    _storage.saveQuests(_quests);
    notifyListeners();
  }

  void claimQuestReward(String questId) {
    final quest = _quests.firstWhere((q) => q.id == questId);
    if (quest.status == QuestStatus.completed) {
      _user!.addXp(quest.xpReward);
      _user!.addCoins(quest.coinReward);
      _user!.completedQuests++;
      if (quest.treeReward != null) {
        _storage.addTreeToGarden(quest.treeReward!);
        _garden = _storage.loadGarden();
      }
      quest.status = QuestStatus.claimed;
      _storage.saveQuests(_quests);
      _storage.saveUser(_user!);
      notifyListeners();
    }
  }

  // === Streak ===
  void claimDailyReward() {
    final days = _user!.streakDays;
    int coins = 10;
    if (days >= 7) coins = 100;
    else if (days >= 3) coins = 20;
    _user!.addCoins(coins);
    _storage.saveUser(_user!);
    notifyListeners();
  }

  // === Garden / Tree Shop ===
  List<TreeSpecies> get shopTrees => TreeSpecies.getDefaults()
    .where((t) => t.isAvailable && !_user!.unlockedTrees.contains(t.id))
    .toList()
    ..sort((a, b) => a.cost.compareTo(b.cost));

  List<TreeSpecies> get ownedTrees => TreeSpecies.getDefaults()
    .where((t) => _user!.unlockedTrees.contains(t.id))
    .toList();

  void unlockTreeType(String treeId) {
    if (!_user!.unlockedTrees.contains(treeId)) {
      _user!.unlockedTrees = [..._user!.unlockedTrees, treeId];
      _storage.saveUser(_user!);
      notifyListeners();
    }
  }

  bool buyTree(String treeId) {
    final tree = TreeSpecies.getById(treeId);
    if (treeId == 'oak' || treeId == 'pine') return false;
    if (_user!.unlockedTrees.contains(treeId)) return false;
    if (_user!.coins < tree.cost) return false;
    _user!.coins -= tree.cost;
    _user!.unlockedTrees = [..._user!.unlockedTrees, treeId];
    _storage.saveUser(_user!);
    notifyListeners();
    return true;
  }

  // === SOLO SYSTEM ===

  // Branch
  void setBranch(SubjectBranch branch) {
    _user!.branch = branch;
    _storage.saveUser(_user!);
    notifyListeners();
  }

  // Skills
  List<SkillModel> get availableSkills => _user!.skills.where((s) =>
    !s.unlocked &&
    _user!.level >= s.requiredLevel &&
    _user!.currentRank.index >= s.requiredRankLevel
  ).toList();

  List<SkillModel> get unlockedSkills => _user!.skills.where((s) => s.unlocked).toList();

  bool unlockSkill(String skillId) {
    final skill = _user!.skills.firstWhere((s) => s.id == skillId);
    if (_user!.skillPoints >= skill.skillPointsCost && !skill.unlocked) {
      skill.unlocked = true;
      _user!.skillPoints -= skill.skillPointsCost;
      _storage.saveUser(_user!);
      notifyListeners();
      return true;
    }
    return false;
  }

  // Avatar Items
  List<AvatarItem> get shopItems => _user!.avatarItems.where((a) => !a.owned).toList();
  List<AvatarItem> get ownedItems => _user!.avatarItems.where((a) => a.owned).toList();

  bool buyAvatarItem(String itemId) {
    final item = _user!.avatarItems.firstWhere((a) => a.id == itemId);
    if (_user!.spendCoins(item.cost)) {
      item.owned = true;
      _storage.saveUser(_user!);
      notifyListeners();
      return true;
    }
    return false;
  }

  void equipItem(String itemId) {
    final item = _user!.avatarItems.firstWhere((a) => a.id == itemId);
    if (!item.owned) return;
    for (final a in _user!.avatarItems) {
      if (a.type == item.type && a.equipped) a.equipped = false;
    }
    item.equipped = true;
    switch (item.type) {
      case AvatarItemType.crown: _user!.equippedCrownId = itemId;
      case AvatarItemType.aura: _user!.equippedAuraId = itemId;
      case AvatarItemType.glasses: _user!.equippedGlassesId = itemId;
      case AvatarItemType.outfit: _user!.equippedOutfitId = itemId;
      case AvatarItemType.title: _user!.equippedTitleId = itemId;
      default: break;
    }
    _storage.saveUser(_user!);
    notifyListeners();
  }

  void unequipItem(String itemId) {
    final item = _user!.avatarItems.firstWhere((a) => a.id == itemId);
    item.equipped = false;
    switch (item.type) {
      case AvatarItemType.crown: _user!.equippedCrownId = null;
      case AvatarItemType.aura: _user!.equippedAuraId = null;
      case AvatarItemType.glasses: _user!.equippedGlassesId = null;
      case AvatarItemType.outfit: _user!.equippedOutfitId = null;
      case AvatarItemType.title: _user!.equippedTitleId = null;
      default: break;
    }
    _storage.saveUser(_user!);
    notifyListeners();
  }

  // Pets
  List<PetModel> get availablePets => _user!.pets.where((p) => !p.owned).toList();

  bool buyPet(String petId) {
    if (_user!.spendCoins(200)) {
      _user!.pets.firstWhere((p) => p.id == petId).owned = true;
      _storage.saveUser(_user!);
      notifyListeners();
      return true;
    }
    return false;
  }

  void equipPet(String petId) {
    for (final p in _user!.pets) p.equipped = false;
    _user!.pets.firstWhere((p) => p.id == petId).equipped = true;
    _user!.equippedPetId = petId;
    _storage.saveUser(_user!);
    notifyListeners();
  }

  // Inventory
  List<InventoryItem> get inventory => _user!.inventory;

  void addToInventory(InventoryItem item) {
    _user!.inventory = [..._user!.inventory, item];
    _storage.saveUser(_user!);
    notifyListeners();
  }

  void removeFromInventory(String itemId) {
    _user!.inventory = _user!.inventory.where((i) => i.id != itemId).toList();
    _storage.saveUser(_user!);
    notifyListeners();
  }

  // Boss Fights
  List<BossFight> get bossFights => _user!.bossFights;

  void addBossFight(BossFight boss) {
    _user!.bossFights = [..._user!.bossFights, boss];
    _storage.saveUser(_user!);
    notifyListeners();
  }

  void defeatBoss(String bossId) {
    final boss = _user!.bossFights.firstWhere((b) => b.id == bossId);
    boss.defeated = true;
    _user!.addXp(boss.totalXp);
    _user!.addCoins(boss.totalXp ~/ 2);
    _storage.saveUser(_user!);
    notifyListeners();
  }

  void attemptBoss(String bossId) {
    _user!.bossFights.firstWhere((b) => b.id == bossId).attempts++;
    _storage.saveUser(_user!);
    notifyListeners();
  }

  // Shields
  int get shields => _user!.shieldCount;

  void useShield() {
    _user!.useShield();
    _storage.saveUser(_user!);
    notifyListeners();
  }

  // Booster
  void activateBooster(int minutes, int cost) {
    if (_user!.spendCoins(cost)) {
      _boosterEndTime = DateTime.now().add(Duration(minutes: minutes));
      _storage.saveUser(_user!);
      notifyListeners();
    }
  }

  // Study Buddies
  List<Map<String, String>> getStudyBuddies() {
    return _storage.getStudyBuddies();
  }

  void addStudyBuddy(String name) {
    _storage.addStudyBuddy(name);
    notifyListeners();
  }

  void removeStudyBuddy(int index) {
    _storage.removeStudyBuddy(index);
    notifyListeners();
  }

  // Achievements
  List<Achievement> get achievements => _user!.achievements;

  void _initAchievements() {
    if (_user!.achievements.isEmpty) {
      _user!.achievements = Achievement.getDefaults();
    }
    checkAchievements();
  }

  void checkAchievements() {
    bool changed = false;
    for (final a in _user!.achievements) {
      if (a.unlocked) continue;
      if (_checkAchievement(a)) {
        a.unlocked = true;
        a.unlockedAt = DateTime.now();
        _user!.addXp(a.xpReward);
        _user!.addCoins(a.coinReward);
        changed = true;
      }
    }
    if (changed) {
      _storage.saveUser(_user!);
      notifyListeners();
    }
  }

  bool _checkAchievement(Achievement a) {
    switch (a.id) {
      case 'first_tree': return _user!.totalTreesPlanted >= 1;
      case 'forest_10': return _user!.totalTreesPlanted >= 10;
      case 'forest_50': return _user!.totalTreesPlanted >= 50;
      case 'forest_100': return _user!.totalTreesPlanted >= 100;
      case 'focus_1h': return _user!.totalFocusMinutes >= 60;
      case 'focus_10h': return _user!.totalFocusMinutes >= 600;
      case 'focus_50h': return _user!.totalFocusMinutes >= 3000;
      case 'focus_100h': return _user!.totalFocusMinutes >= 6000;
      case 'streak_3': return _user!.streakDays >= 3;
      case 'streak_7': return _user!.streakDays >= 7;
      case 'streak_30': return _user!.streakDays >= 30;
      case 'streak_100': return _user!.streakDays >= 100;
      case 'collector_5': return _user!.unlockedTrees.length >= 5;
      case 'collector_15': return _user!.unlockedTrees.length >= 15;
      case 'collector_30': return _user!.unlockedTrees.length >= 30;
      case 'collector_all': return _user!.unlockedTrees.length >= TreeSpecies.getDefaults().length;
      case 'level_5': return _user!.level >= 5;
      case 'level_10': return _user!.level >= 10;
      case 'level_25': return _user!.level >= 25;
      case 'level_50': return _user!.level >= 50;
      case 'tasks_10': return _user!.completedTasks >= 10;
      case 'tasks_50': return _user!.completedTasks >= 50;
      case 'tasks_200': return _user!.completedTasks >= 200;
      case 'prayers_50': return _user!.totalPrayersOnTime >= 50;
      case 'prayers_200': return _user!.totalPrayersOnTime >= 200;
      case 'prayers_1000': return _user!.totalPrayersOnTime >= 1000;
      case 'coins_1000': return _user!.coins >= 1000;
      case 'coins_10000': return _user!.coins >= 10000;
      case 'coins_50000': return _user!.coins >= 50000;
      default: return false;
    }
  }

  // Theme
  void toggleDarkMode() {
    _user!.isDarkMode = !_user!.isDarkMode;
    _storage.saveUser(_user!);
    notifyListeners();
  }
}
