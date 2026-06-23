import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/tree_species.dart';
import '../../providers/app_provider.dart';

class GardenScreen extends StatelessWidget {
  const GardenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, app, _) {
        final garden = app.garden;
        return Scaffold(
          appBar: AppBar(title: const Text('🌳 حديقتي')),
          body: Column(
            children: [
              _GardenHeader(app: app),
              Expanded(
                child: garden.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🌱', style: TextStyle(fontSize: 80)),
                          const SizedBox(height: 16),
                          Text(
                            'لا توجد أشجار بعد',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'ابدأ جلسة تركيز لزراعة أول شجرة',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(context, '/timer');
                            },
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('ابدأ جلسة تركيز'),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: garden.length,
                      itemBuilder: (context, index) {
                        final tree = garden[index];
                        final treeType = tree['type'] ?? 'oak';
                        final species = TreeSpecies.getById(treeType);
                        return Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(species.emoji, style: const TextStyle(fontSize: 28)),
                              const SizedBox(height: 2),
                              Text(species.rarity.emoji, style: const TextStyle(fontSize: 10)),
                            ],
                          ),
                        );
                      },
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GardenHeader extends StatelessWidget {
  final AppProvider app;
  const _GardenHeader({required this.app});

  @override
  Widget build(BuildContext context) {
    final user = app.user;
    final garden = app.garden;
    final totalSpecies = TreeSpecies.getDefaults().length;
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade100, Colors.green.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _GardenStat(label: '🌳 كل', value: '${garden.length}'),
          _GardenStat(label: '⏱ ساعات', value: '${user.totalFocusMinutes ~/ 60}'),
          _GardenStat(label: '🔥 الأيام', value: '${user.streakDays}'),
          _GardenStat(label: '🏆 أنواع', value: '${user.unlockedTrees.length}/$totalSpecies'),
        ],
      ),
    );
  }
}

class _GardenStat extends StatelessWidget {
  final String label;
  final String value;
  const _GardenStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
