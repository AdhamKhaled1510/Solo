import 'package:flutter/material.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🎯 المزيد')),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.9,
        children: _items.map((item) => _MoreCard(item: item, context: context)).toList(),
      ),
    );
  }
}

class _MoreItem {
  final String icon;
  final String label;
  final String route;
  final Color color;
  const _MoreItem(this.icon, this.label, this.route, this.color);
}

const List<_MoreItem> _items = [
  _MoreItem('🌳', 'الحديقة', '/garden', Color(0xFF2E7D32)),
  _MoreItem('🌿', 'المهارات', '/skills', Color(0xFF7B1FA2)),
  _MoreItem('🎭', 'الشخصية', '/avatar', Color(0xFFFF6F00)),
  _MoreItem('🎒', 'الحقيبة', '/inventory', Color(0xFF1565C0)),
  _MoreItem('🛒', 'المتجر', '/shop', Color(0xFFFFB300)),
  _MoreItem('🎯', 'المهام', '/quests', Color(0xFFE91E63)),
  _MoreItem('🏆', 'الإنجازات', '/achievements', Color(0xFFFFD700)),
  _MoreItem('⚔️', 'الزعماء', '/boss', Color(0xFFD32F2F)),
  _MoreItem('🏆', 'الصدارة', '/leaderboard', Color(0xFFFF6D00)),
  _MoreItem('📊', 'الإحصائيات', '/stats', Color(0xFF43A047)),
  _MoreItem('🎵', 'الأصوات', '/soundscapes', Color(0xFF00BCD4)),
  _MoreItem('🏠', 'الغرف', '/rooms', Color(0xFFE91E63)),
  _MoreItem('⚙️', 'الإعدادات', '/settings', Color(0xFF546E7A)),
];

Widget _MoreCard({required _MoreItem item, required BuildContext context}) {
  return Card(
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.pushNamed(context, item.route),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(item.icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(item.label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
          ],
        ),
      ),
    ),
  );
}
