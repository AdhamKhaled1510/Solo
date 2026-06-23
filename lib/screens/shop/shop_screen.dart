import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/cyberpunk_theme.dart';
import '../../core/widgets/cyberpunk_widgets.dart';
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
          body: CustomPaint(
            painter: GridBackground(),
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MARKETPLACE / المتجر',
                              style: TextStyle(color: CyberColors.neonCyan, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                            ),
                            Text('ACQUIRE ASSETS / شراء العتاد والأشجار', style: TextStyle(color: CyberColors.textDim, fontSize: 9, fontFamily: 'monospace')),
                          ],
                        ),
                        HexBadge(label: 'COINS', value: '${user.coins}', color: CyberColors.amberGold),
                      ],
                    ),
                  ),
                  // Tabs
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: CyberColors.surface,
                      border: Border.all(color: CyberColors.dimCyan.withAlpha(50), width: 0.5),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: CyberColors.neonCyan,
                      labelColor: CyberColors.neonCyan,
                      unselectedLabelColor: CyberColors.textDim,
                      labelStyle: const TextStyle(fontSize: 10, fontFamily: 'monospace', fontWeight: FontWeight.bold),
                      tabs: const [
                        Tab(text: 'TREES / الأشجار'),
                        Tab(text: 'BOOSTERS / معززات'),
                        Tab(text: 'COSMETICS / مظهر'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Tab content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Tab 1: Trees
                        trees.isEmpty
                            ? const Center(
                                child: Text('جميع الأشجار مملوكة بالكامل!', style: TextStyle(color: CyberColors.textDim, fontFamily: 'monospace')),
                              )
                            : GridView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 0.9,
                                ),
                                itemCount: trees.length,
                                itemBuilder: (context, idx) {
                                  final tree = trees[idx];
                                  final canAfford = user.coins >= tree.cost;
                                  final hasLevel = user.level >= tree.requiredLevel;

                                  // Choose color based on rarity
                                  Color rarityColor = CyberColors.neonCyan;
                                  if (tree.rarity == TreeRarity.uncommon) {
                                    rarityColor = Colors.purple;
                                  } else if (tree.rarity == TreeRarity.rare || tree.rarity == TreeRarity.legendary) {
                                    rarityColor = CyberColors.hotMagenta;
                                  }

                                  return _ShopItemCard(
                                    title: tree.name,
                                    subtitle: tree.rarity.label,
                                    iconText: tree.emoji,
                                    cost: tree.cost,
                                    requiredLevel: tree.requiredLevel,
                                    canAfford: canAfford,
                                    hasLevel: hasLevel,
                                    color: rarityColor,
                                    onBuy: () {
                                      if (app.buyTree(tree.id)) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('تم شراء ${tree.name}! 🎉'),
                                            backgroundColor: CyberColors.neonCyan,
                                          ),
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                        // Tab 2: Boosters
                        GridView.count(
                          crossAxisCount: 2,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.9,
                          children: [
                            _ShopItemCard(
                              title: 'XP BOOSTER / مضاعف الخبرة',
                              subtitle: '+100% XP لمدة ساعة',
                              iconText: '⚡',
                              cost: 300,
                              requiredLevel: 1,
                              canAfford: user.coins >= 300,
                              hasLevel: true,
                              color: CyberColors.neonCyan,
                              onBuy: () {
                                if (user.coins >= 300) {
                                  app.activateBooster(60, 300);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('تم تفعيل مضاعف الخبرة بنجاح! ⚡'),
                                      backgroundColor: CyberColors.neonCyan,
                                    ),
                                  );
                                }
                              },
                            ),
                            _ShopItemCard(
                              title: 'STREAK SHIELD / درع الحماية',
                              subtitle: 'حماية السلسلة من الانقطاع',
                              iconText: '🛡️',
                              cost: 500,
                              requiredLevel: 5,
                              canAfford: user.coins >= 500,
                              hasLevel: user.level >= 5,
                              color: CyberColors.amberGold,
                              onBuy: () {
                                user.coins -= 500;
                                user.shields += 1;
                                app.init(); // Reload
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('تم شراء درع الحماية بنجاح! 🛡️'),
                                    backgroundColor: CyberColors.amberGold,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        // Tab 3: Cosmetics
                        const Center(
                          child: Text('سيتم تفعيل العتاد الحربي ومستحضرات الهولوغرام قريباً!', style: TextStyle(color: CyberColors.textDim, fontFamily: 'monospace')),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ShopItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconText;
  final int cost;
  final int requiredLevel;
  final bool canAfford;
  final bool hasLevel;
  final Color color;
  final VoidCallback onBuy;

  const _ShopItemCard({
    required this.title,
    required this.subtitle,
    required this.iconText,
    required this.cost,
    required this.requiredLevel,
    required this.canAfford,
    required this.hasLevel,
    required this.color,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    final border = hasLevel ? color : CyberColors.textDim;
    return BracketFrame(
      color: border.withAlpha(120),
      padding: 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(iconText, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'monospace', color: CyberColors.textPrimary),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(subtitle, style: const TextStyle(fontSize: 8, color: CyberColors.textDim), textAlign: TextAlign.center),
          const Spacer(),
          if (!hasLevel)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: CyberColors.hotMagenta.withAlpha(100)),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text('LVL $requiredLevel', style: const TextStyle(fontSize: 9, color: CyberColors.hotMagenta, fontFamily: 'monospace')),
            )
          else
            GestureDetector(
              onTap: canAfford ? onBuy : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: canAfford ? CyberColors.amberGold.withAlpha(20) : Colors.transparent,
                  border: Border.all(color: canAfford ? CyberColors.amberGold : CyberColors.textDim.withAlpha(80)),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.monetization_on, size: 11, color: canAfford ? CyberColors.amberGold : CyberColors.textDim),
                    const SizedBox(width: 4),
                    Text(
                      '$cost',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: canAfford ? CyberColors.amberGold : CyberColors.textDim,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
