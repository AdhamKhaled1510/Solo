import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/clean_theme.dart';
import '../../core/widgets/clean_widgets.dart';
import '../../models/tree_species.dart';
import '../../providers/app_provider.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, app, _) {
        final trees = app.shopTrees;
        final user = app.user;

        return Scaffold(
          appBar: AppBar(
            title: const Text('المتجر'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: BadgeWidget(text: '🪙 ${user.coins}', color: AppColors.coinGold),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.primary,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textDim,
                  labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  tabs: const [
                    Tab(text: 'الأشجار'),
                    Tab(text: 'المعززات'),
                    Tab(text: 'المظهر'),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              // Trees tab
              trees.isEmpty
                ? const Center(child: Text('جميع الأشجار مملوكة!', style: TextStyle(color: AppColors.textSecondary)))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.85,
                    ),
                    itemCount: trees.length,
                    itemBuilder: (_, i) {
                      final tree = trees[i];
                      final canAfford = user.coins >= tree.cost;
                      final hasLevel = user.level >= tree.requiredLevel;
                      Color rarityColor = tree.rarity == TreeRarity.rare || tree.rarity == TreeRarity.legendary ? AppColors.secondary : AppColors.primary;
                      return GlassCard(
                        borderColor: rarityColor.withAlpha(40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(tree.emoji, style: const TextStyle(fontSize: 36)),
                            const SizedBox(height: 4),
                            Text(tree.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                            Text(tree.rarity.label, style: const TextStyle(fontSize: 10, color: AppColors.textDim)),
                            const SizedBox(height: 6),
                            if (!hasLevel)
                              BadgeWidget(text: 'المستوى ${tree.requiredLevel}', color: AppColors.error)
                            else if (!canAfford)
                              BadgeWidget(text: '🪙 ${tree.cost}', color: AppColors.error)
                            else
                              GestureDetector(
                                onTap: () {
                                  if (app.buyTree(tree.id)) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم شراء ${tree.name}! 🎉'), backgroundColor: AppColors.success));
                                  }
                                },
                                child: BadgeWidget(text: '🪙 ${tree.cost}', color: AppColors.coinGold),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
              // Boosters tab
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _BoosterCard(
                      title: 'مضاعف الخبرة',
                      subtitle: '+100% XP لمدة ساعة',
                      icon: '⚡',
                      cost: 300,
                      canBuy: user.coins >= 300,
                      onBuy: () {
                        if (user.coins >= 300) {
                          app.activateBooster(60, 300);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تفعيل مضاعف الخبرة! ⚡'), backgroundColor: AppColors.success));
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    _BoosterCard(
                      title: 'درع الحماية',
                      subtitle: 'يحمي الـ Streak من الانقطاع',
                      icon: '🛡️',
                      cost: 500,
                      canBuy: user.coins >= 500,
                      onBuy: () {
                        if (user.coins >= 500) {
                          user.coins -= 500;
                          user.shields += 1;
                          app.init();
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم شراء درع الحماية! 🛡️'), backgroundColor: AppColors.success));
                        }
                      },
                    ),
                  ],
                ),
              ),
              // Cosmetics tab
              const Center(child: Text('قريبًا...', style: TextStyle(color: AppColors.textSecondary))),
            ],
          ),
        );
      },
    );
  }
}

class _BoosterCard extends StatelessWidget {
  final String title, subtitle, icon;
  final int cost;
  final bool canBuy;
  final VoidCallback onBuy;

  const _BoosterCard({
    required this.title, required this.subtitle, required this.icon,
    required this.cost, required this.canBuy, required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 36)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          GestureDetector(
            onTap: canBuy ? onBuy : null,
            child: BadgeWidget(
              text: '🪙 $cost',
              color: canBuy ? AppColors.coinGold : AppColors.textDim,
            ),
          ),
        ],
      ),
    );
  }
}
