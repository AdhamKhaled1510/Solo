import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/tree_species.dart';
import '../../providers/app_provider.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, app, _) {
        final trees = app.shopTrees;

        return Scaffold(
          appBar: AppBar(
            title: const Text('🛒 المتجر'),
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
                    child: Text('🪙 ${app.user.coins}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
          body: trees.isEmpty
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('🌟', style: TextStyle(fontSize: 60)),
                    SizedBox(height: 16),
                    Text('جميع الأشجار مملوكة!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: trees.length,
                itemBuilder: (context, index) {
                  final tree = trees[index];
                  final canAfford = app.user.coins >= tree.cost;
                  final hasLevel = app.user.level >= tree.requiredLevel;

                  return Card(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: (!canAfford || !hasLevel) ? null : () {
                        if (app.buyTree(tree.id)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('تم شراء ${tree.name}! 🎉')),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(tree.emoji, style: const TextStyle(fontSize: 36)),
                            const SizedBox(height: 4),
                            Text(tree.rarity.emoji, style: const TextStyle(fontSize: 12)),
                            const SizedBox(height: 2),
                            Text(tree.name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                            const SizedBox(height: 2),
                            Text(tree.rarity.label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
                            const SizedBox(height: 4),
                            if (!hasLevel)
                              Text('المستوى ${tree.requiredLevel}', style: const TextStyle(fontSize: 10, color: Colors.red))
                            else
                              Text('🪙 ${tree.cost}', style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold,
                                color: canAfford ? Colors.amber : Colors.red,
                              )),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
        );
      },
    );
  }
}
