import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, app, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('⚙️ الإعدادات')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: SwitchListTile(
                  title: const Text('🌙 الوضع الليلي'),
                  subtitle: Text(app.user.isDarkMode ? 'مفعل' : 'غير مفعل'),
                  value: app.user.isDarkMode,
                  onChanged: (_) => app.toggleDarkMode(),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.timer_outlined),
                      title: const Text('مدة التركيز'),
                      subtitle: Text('${app.focusDuration} دقيقة'),
                      onTap: () => _showDurationPicker(context, app.focusDuration, (v) {
                        app.setFocusDuration(v);
                        Navigator.of(context).pop();
                      }),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.free_breakfast_outlined),
                      title: const Text('مدة الراحة'),
                      subtitle: Text('${app.breakDuration} دقيقة'),
                      onTap: () => _showDurationPicker(context, app.breakDuration, (v) {
                        app.setBreakDuration(v);
                        Navigator.of(context).pop();
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('عن التطبيق'),
                  subtitle: const Text('دراستي v1.0.0'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDurationPicker(BuildContext context, int current, Function(int) onSelected) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('اختر المدة', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [5, 10, 15, 20, 25, 30, 45, 60, 90, 120].map((m) => ChoiceChip(
                label: Text('$m دقيقة'),
                selected: current == m,
                onSelected: (_) => onSelected(m),
              )).toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
