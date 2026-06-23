import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../providers/app_provider.dart';
import '../../models/prayer_model.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, app, _) {
        final prayer = app.prayerToday;
        return Scaffold(
          appBar: AppBar(title: const Text('🕌 العبادات')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PrayerTracker(prayer: prayer, app: app),
                const SizedBox(height: 16),
                _AzkarSection(app: app),
                const SizedBox(height: 16),
                _QuranSection(app: app),
                const SizedBox(height: 16),
                _TasbeehSection(app: app),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PrayerTracker extends StatelessWidget {
  final PrayerDay prayer;
  final AppProvider app;
  const _PrayerTracker({required this.prayer, required this.app});

  @override
  Widget build(BuildContext context) {
    final prayers = [
      ('Fajr', 'الفجر', '🌅', AppColors.fajr),
      ('Dhuhr', 'الظهر', '☀️', AppColors.dhuhr),
      ('Asr', 'العصر', '🌤', AppColors.asr),
      ('Maghrib', 'المغرب', '🌇', AppColors.maghrib),
      ('Isha', 'العشاء', '🌙', AppColors.isha),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('🕌 الصلوات', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: prayer.completedPrayers == 5 ? Colors.green.withAlpha(25) : Colors.orange.withAlpha(25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${prayer.completedPrayers}/5',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: prayer.completedPrayers == 5 ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...prayers.map((p) {
              final completed = _getPrayerStatus(prayer, p.$1);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: completed ? Colors.green.withAlpha(15) : null,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => app.togglePrayer(p.$1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(
                        children: [
                          Text(p.$3, style: const TextStyle(fontSize: 24)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(p.$2, style: Theme.of(context).textTheme.bodyLarge),
                          ),
                          Icon(
                            completed ? Icons.check_circle : Icons.radio_button_unchecked,
                            color: completed ? Colors.green : Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  bool _getPrayerStatus(PrayerDay prayer, String name) {
    switch (name) {
      case 'Fajr': return prayer.fajr;
      case 'Dhuhr': return prayer.dhuhr;
      case 'Asr': return prayer.asr;
      case 'Maghrib': return prayer.maghrib;
      case 'Isha': return prayer.isha;
      default: return false;
    }
  }
}

class _AzkarSection extends StatelessWidget {
  final AppProvider app;
  const _AzkarSection({required this.app});

  @override
  Widget build(BuildContext context) {
    final prayer = app.prayerToday;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📿 الأذكار', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _AzkarTile(
              label: 'أذكار الصباح',
              completed: prayer.morningAzkar,
              onTap: () => app.toggleAzkar(true),
            ),
            const SizedBox(height: 8),
            _AzkarTile(
              label: 'أذكار المساء',
              completed: prayer.eveningAzkar,
              onTap: () => app.toggleAzkar(false),
            ),
          ],
        ),
      ),
    );
  }
}

class _AzkarTile extends StatelessWidget {
  final String label;
  final bool completed;
  final VoidCallback onTap;
  const _AzkarTile({required this.label, required this.completed, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: completed ? Colors.green.withAlpha(15) : null,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(
                completed ? Icons.check_circle : Icons.radio_button_unchecked,
                color: completed ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 12),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuranSection extends StatefulWidget {
  final AppProvider app;
  const _QuranSection({required this.app});

  @override
  State<_QuranSection> createState() => _QuranSectionState();
}

class _QuranSectionState extends State<_QuranSection> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.app.prayerToday.quranPages.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📖 القرآن', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('🕋', style: TextStyle(fontSize: 32)),
                const SizedBox(width: 16),
                const Text('عدد الصفحات اليوم:'),
                const SizedBox(width: 12),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: '0',
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    ),
                    onSubmitted: (v) {
                      final pages = int.tryParse(v) ?? 0;
                      widget.app.setQuranPages(pages);
                    },
                  ),
                ),
                const Text(' صفحة', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TasbeehSection extends StatefulWidget {
  final AppProvider app;
  const _TasbeehSection({required this.app});

  @override
  State<_TasbeehSection> createState() => _TasbeehSectionState();
}

class _TasbeehSectionState extends State<_TasbeehSection> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('☝️ التسبيح', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Text(_count.toString(), style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  )),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => setState(() => _count++),
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child: Center(
                        child: Text('ﷲ', style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => setState(() => _count = 0),
                    child: const Text('إعادة'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
