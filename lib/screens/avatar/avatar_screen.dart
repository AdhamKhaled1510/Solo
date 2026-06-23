import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../models/solo_rank.dart';
import '../../providers/app_provider.dart';
import '../../models/avatar_item.dart';

class AvatarScreen extends StatelessWidget {
  const AvatarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, app, _) {
        final user = app.user;
        final owned = app.ownedItems;
        return Scaffold(
          appBar: AppBar(
            title: const Text('🎭 شخصيتي'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.withAlpha(25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('🪙 ${user.coins}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _AvatarPreview(user: user),
                const SizedBox(height: 24),
                Text('المعدات', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ...AvatarItemType.values.map((type) => _EquipmentSection(
                  type: type,
                  items: owned.where((a) => a.type == type).toList(),
                  app: app,
                )),
                const SizedBox(height: 16),
                Text('🛒 المتجر', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                if (app.shopItems.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(child: Text('كل القطع مملوكة!', style: TextStyle(color: Colors.grey))),
                    ),
                  )
                else
                  ...app.shopItems.map((item) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Text(item.emoji, style: const TextStyle(fontSize: 32)),
                      title: Text(item.name),
                      subtitle: Text('${item.typeName} • 🪙 ${item.cost}${item.requiredLevel > 0 ? ' • Lv${item.requiredLevel}' : ''}'),
                      trailing: FilledButton.tonal(
                        onPressed: () {
                          if (app.buyAvatarItem(item.id)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('تم شراء ${item.name}! 🎉')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('عملات غير كافية')),
                            );
                          }
                        },
                        child: const Text('شراء'),
                      ),
                    ),
                  )),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AvatarPreview extends StatelessWidget {
  final UserModel user;
  const _AvatarPreview({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        user.currentRank.index >= 5 ? Colors.amber : Colors.grey.shade300,
                        user.currentRank.index >= 5 ? Colors.orange : Colors.grey.shade100,
                      ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(user.equippedOutfitEmoji.isNotEmpty ? user.equippedOutfitEmoji : '🧑', style: const TextStyle(fontSize: 40)),
                  if (user.equippedCrownEmoji.isNotEmpty)
                    Positioned(top: -5, child: Text(user.equippedCrownEmoji, style: const TextStyle(fontSize: 24))),
                  if (user.equippedGlassesEmoji.isNotEmpty)
                    Positioned(child: Text(user.equippedGlassesEmoji, style: const TextStyle(fontSize: 20))),
                ],
              ),
            ),
            if (user.equippedAuraEmoji.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(user.equippedAuraEmoji, style: const TextStyle(fontSize: 28)),
              ),
            const SizedBox(height: 8),
            Text('${_rankEmoji(user.currentRank)} ${_rankName(user.currentRank)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            if (user.equippedTitleEmoji.isNotEmpty)
              Text(user.equippedTitleEmoji, style: const TextStyle(fontSize: 16)),
            if (user.equippedPet != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('🐾 ${user.equippedPet!.emoji} Lv.${user.equippedPet!.level}',
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
              ),
          ],
        ),
      ),
    );
  }
}

class _EquipmentSection extends StatelessWidget {
  final AvatarItemType type;
  final List<AvatarItem> items;
  final AppProvider app;
  const _EquipmentSection({required this.type, required this.items, required this.app});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    final typeName = items.isNotEmpty ? items.first.typeName : '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(typeName, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700])),
        const SizedBox(height: 4),
        SizedBox(
          height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final equipped = item.equipped;
              return GestureDetector(
                onTap: () {
                  if (equipped) app.unequipItem(item.id);
                  else app.equipItem(item.id);
                },
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: equipped ? Colors.green.withAlpha(25) : Colors.grey.withAlpha(15),
                    borderRadius: BorderRadius.circular(12),
                    border: equipped ? Border.all(color: Colors.green, width: 2) : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(item.emoji, style: const TextStyle(fontSize: 24)),
                      if (equipped) const Icon(Icons.check_circle, color: Colors.green, size: 14),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

String _rankEmoji(SoloRank rank) {
  switch (rank) {
    case SoloRank.e: return '🟢';
    case SoloRank.d: return '🔵';
    case SoloRank.c: return '🟣';
    case SoloRank.b: return '🟠';
    case SoloRank.a: return '🔴';
    case SoloRank.s: return '👑';
  }
}

String _rankName(SoloRank rank) {
  switch (rank) {
    case SoloRank.e: return 'E-Rank';
    case SoloRank.d: return 'D-Rank';
    case SoloRank.c: return 'C-Rank';
    case SoloRank.b: return 'B-Rank';
    case SoloRank.a: return 'A-Rank';
    case SoloRank.s: return 'S-Rank';
  }
}
