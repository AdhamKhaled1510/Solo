import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/skill_model.dart';
import '../models/avatar_item.dart';
import '../models/pet_model.dart';
import '../models/inventory_item.dart';
import '../models/party_model.dart';
import '../models/solo_rank.dart';
import '../services/storage_service.dart';

class SoloProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  UserModel? _user;
  UserModel get user => _user!;

  void init(UserModel user) {
    _user = user;
    if (_user!.skills.isEmpty) {
      _user!.skills = SkillModel.getDefaultSkills();
    }
    if (_user!.avatarItems.isEmpty) {
      _user!.avatarItems = AvatarItem.getDefaultItems();
    }
    if (_user!.pets.isEmpty) {
      _user!.pets = PetModel.getDefaultPets();
      _user!.pets[0].owned = true;
    }
    notifyListeners();
  }

  void save() => _storage.saveUser(_user!);

  // === Rank ===
  SoloRank get rank => _user!.currentRank;

  // === Skills ===
  List<SkillModel> get availableSkills => _user!.skills.where((s) =>
    !s.unlocked &&
    _user!.level >= s.requiredLevel &&
    rank.index >= s.requiredRankLevel
  ).toList();

  List<SkillModel> get unlockedSkills => _user!.skills.where((s) => s.unlocked).toList();

  bool unlockSkill(String skillId) {
    final skill = _user!.skills.firstWhere((s) => s.id == skillId);
    if (_user!.skillPoints >= skill.skillPointsCost && !skill.unlocked) {
      skill.unlocked = true;
      _user!.skillPoints -= skill.skillPointsCost;
      save();
      notifyListeners();
      return true;
    }
    return false;
  }

  // === Avatar Items ===
  List<AvatarItem> get shopItems => _user!.avatarItems.where((a) => !a.owned).toList();
  List<AvatarItem> get ownedItems => _user!.avatarItems.where((a) => a.owned).toList();

  bool buyAvatarItem(String itemId) {
    final item = _user!.avatarItems.firstWhere((a) => a.id == itemId);
    if (_user!.spendCoins(item.cost)) {
      item.owned = true;
      save();
      notifyListeners();
      return true;
    }
    return false;
  }

  void equipItem(String itemId) {
    final item = _user!.avatarItems.firstWhere((a) => a.id == itemId);
    if (!item.owned) return;

    // Unequip same type
    for (final a in _user!.avatarItems) {
      if (a.type == item.type && a.equipped) a.equipped = false;
    }
    item.equipped = true;

    // Update equipped IDs
    switch (item.type) {
      case AvatarItemType.crown: _user!.equippedCrownId = itemId;
      case AvatarItemType.aura: _user!.equippedAuraId = itemId;
      case AvatarItemType.glasses: _user!.equippedGlassesId = itemId;
      case AvatarItemType.outfit: _user!.equippedOutfitId = itemId;
      case AvatarItemType.title: _user!.equippedTitleId = itemId;
      case AvatarItemType.pet_skin: break;
    }
    save();
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
      case AvatarItemType.pet_skin: break;
    }
    save();
    notifyListeners();
  }

  // === Pets ===
  List<PetModel> get availablePets => _user!.pets.where((p) => !p.owned).toList();

  bool buyPet(String petId) {
    final pet = _user!.pets.firstWhere((p) => p.id == petId);
    if (_user!.spendCoins(200)) {
      pet.owned = true;
      save();
      notifyListeners();
      return true;
    }
    return false;
  }

  void equipPet(String petId) {
    for (final p in _user!.pets) p.equipped = false;
    _user!.pets.firstWhere((p) => p.id == petId).equipped = true;
    _user!.equippedPetId = petId;
    save();
    notifyListeners();
  }

  void addPetXp(int amount) {
    final pet = _user!.equippedPet;
    if (pet != null) {
      pet.addXp(amount);
      save();
      notifyListeners();
    }
  }

  // === Inventory ===
  List<InventoryItem> get inventory => _user!.inventory;

  void addToInventory(InventoryItem item) {
    _user!.inventory = [..._user!.inventory, item];
    save();
    notifyListeners();
  }

  void removeFromInventory(String itemId) {
    _user!.inventory = _user!.inventory.where((i) => i.id != itemId).toList();
    save();
    notifyListeners();
  }

  // === Boss Fights ===
  List<BossFight> get bossFights => _user!.bossFights;

  void addBossFight(BossFight boss) {
    _user!.bossFights = [..._user!.bossFights, boss];
    save();
    notifyListeners();
  }

  void defeatBoss(String bossId) {
    final boss = _user!.bossFights.firstWhere((b) => b.id == bossId);
    boss.defeated = true;
    _user!.addXp(boss.totalXp);
    _user!.addCoins(boss.totalXp ~/ 2);
    save();
    notifyListeners();
  }

  void attemptBoss(String bossId) {
    _user!.bossFights.firstWhere((b) => b.id == bossId).attempts++;
    save();
    notifyListeners();
  }

  // === Shields ===
  int get shields => _user!.shieldCount;

  void addShield() {
    _user!.shields++;
    save();
    notifyListeners();
  }

  bool useShield() {
    if (_user!.shieldCount > 0) {
      _user!.useShield();
      save();
      notifyListeners();
      return true;
    }
    return false;
  }

  // === XP Boosters ===
  DateTime? _boosterEndTime;
  bool get hasActiveBooster => _boosterEndTime != null && DateTime.now().isBefore(_boosterEndTime!);
  double get boosterMultiplier => hasActiveBooster ? 2.0 : 1.0;
  int _activeBoosterMinutes = 0;
  int get activeBoosterMinutes => _activeBoosterMinutes;

  void activateBooster(int minutes, int cost) {
    if (_user!.spendCoins(cost)) {
      _boosterEndTime = DateTime.now().add(Duration(minutes: minutes));
      _activeBoosterMinutes = minutes;
      save();
      notifyListeners();
    }
  }

  // === Branch Selection ===
  void setBranch(SubjectBranch branch) {
    _user!.branch = branch;
    save();
    notifyListeners();
  }
}
