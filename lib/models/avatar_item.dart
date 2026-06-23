import 'solo_rank.dart';

enum AvatarItemType { crown, aura, glasses, outfit, pet_skin, title }

class AvatarItem {
  final String id;
  final String name;
  final String description;
  final AvatarItemType type;
  final String emoji;
  final int cost;
  final int requiredLevel;
  final SoloRank? requiredRank;
  bool owned;
  bool equipped;

  AvatarItem({
    required this.id,
    required this.name,
    this.description = '',
    required this.type,
    required this.emoji,
    this.cost = 0,
    this.requiredLevel = 0,
    this.requiredRank,
    this.owned = false,
    this.equipped = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'type': type.index,
    'emoji': emoji,
    'cost': cost,
    'requiredLevel': requiredLevel,
    'requiredRank': requiredRank?.index,
    'owned': owned,
    'equipped': equipped,
  };

  factory AvatarItem.fromJson(Map<String, dynamic> json) => AvatarItem(
    id: json['id'],
    name: json['name'],
    description: json['description'] ?? '',
    type: AvatarItemType.values[json['type']],
    emoji: json['emoji'],
    cost: json['cost'] ?? 0,
    requiredLevel: json['requiredLevel'] ?? 0,
    requiredRank: json['requiredRank'] != null ? SoloRank.values[json['requiredRank']] : null,
    owned: json['owned'] ?? false,
    equipped: json['equipped'] ?? false,
  );

  String get typeName {
    switch (type) {
      case AvatarItemType.crown: return 'تاج';
      case AvatarItemType.aura: return 'هالة';
      case AvatarItemType.glasses: return 'نظارة';
      case AvatarItemType.outfit: return 'زي';
      case AvatarItemType.pet_skin: return 'جلد حيوان';
      case AvatarItemType.title: return 'لقب';
    }
  }

  static List<AvatarItem> getDefaultItems() => [
    AvatarItem(id: 'crown_bronze', name: 'التاج البرونزي', type: AvatarItemType.crown, emoji: '🪙',
      cost: 200, requiredLevel: 5),
    AvatarItem(id: 'crown_silver', name: 'التاج الفضي', type: AvatarItemType.crown, emoji: '🥈',
      cost: 500, requiredLevel: 15),
    AvatarItem(id: 'crown_gold', name: 'التاج الذهبي', type: AvatarItemType.crown, emoji: '👑',
      cost: 1000, requiredLevel: 30),
    AvatarItem(id: 'crown_legendary', name: 'تاج الأسطورة', type: AvatarItemType.crown, emoji: '👑✨',
      cost: 5000, requiredRank: SoloRank.s),

    AvatarItem(id: 'aura_blue', name: 'هالة زرقاء', type: AvatarItemType.aura, emoji: '💙',
      cost: 300, requiredLevel: 10),
    AvatarItem(id: 'aura_purple', name: 'هالة بنفسجية', type: AvatarItemType.aura, emoji: '💜',
      cost: 800, requiredLevel: 25),
    AvatarItem(id: 'aura_golden', name: 'هالة ذهبية', type: AvatarItemType.aura, emoji: '⭐',
      cost: 2000, requiredRank: SoloRank.a),
    AvatarItem(id: 'aura_flame', name: 'هالة النار', type: AvatarItemType.aura, emoji: '🔥',
      cost: 5000, requiredRank: SoloRank.s),

    AvatarItem(id: 'glasses_shades', name: 'نظارة شمسية', type: AvatarItemType.glasses, emoji: '😎',
      cost: 150, requiredLevel: 3),
    AvatarItem(id: 'glasses_vr', name: 'نظارة الواقع', type: AvatarItemType.glasses, emoji: '🤓',
      cost: 400, requiredLevel: 12),
    AvatarItem(id: 'glasses_golden', name: 'نظارة ذهبية', type: AvatarItemType.glasses, emoji: '👓✨',
      cost: 1500, requiredLevel: 35),

    AvatarItem(id: 'outfit_casual', name: 'زي عادي', type: AvatarItemType.outfit, emoji: '👕',
      cost: 100),
    AvatarItem(id: 'outfit_robe', name: 'رداء الحكيم', type: AvatarItemType.outfit, emoji: '🧙',
      cost: 600, requiredLevel: 20),
    AvatarItem(id: 'outfit_armor', name: 'درع الفارس', type: AvatarItemType.outfit, emoji: '⚔️',
      cost: 1500, requiredRank: SoloRank.a),
    AvatarItem(id: 'outfit_shadow', name: 'عباءة الظل', type: AvatarItemType.outfit, emoji: '🗡️',
      cost: 4000, requiredRank: SoloRank.s),

    AvatarItem(id: 'title_focus', name: 'لقب: المركّز', type: AvatarItemType.title, emoji: '🎯',
      cost: 300, requiredLevel: 8),
    AvatarItem(id: 'title_prayer', name: 'لقب: الخاشع', type: AvatarItemType.title, emoji: '🕌',
      cost: 500, requiredLevel: 15),
    AvatarItem(id: 'title_legend', name: 'لقب: الأسطورة', type: AvatarItemType.title, emoji: '🏆',
      cost: 10000, requiredRank: SoloRank.s),
  ];
}
