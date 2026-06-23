import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  final _nameController = TextEditingController();
  List<Map<String, String>> _buddies = [];

  @override
  void initState() {
    super.initState();
    _loadBuddies();
  }

  void _loadBuddies() {
    final app = context.read<AppProvider>();
    _buddies = app.getStudyBuddies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addBuddy() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة صديق'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'اسم الصديق',
            hintText: 'مثال: أحمد',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          FilledButton(onPressed: () {
            if (_nameController.text.trim().isNotEmpty) {
              context.read<AppProvider>().addStudyBuddy(_nameController.text.trim());
              _nameController.clear();
              _loadBuddies();
              setState(() {});
              Navigator.pop(ctx);
            }
          }, child: const Text('إضافة')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, app, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('🏠 غرف الدراسة'),
            actions: [
              IconButton(
                icon: const Icon(Icons.person_add),
                onPressed: _addBuddy,
              ),
            ],
          ),
          body: Column(
            children: [
              // Start a room card
              Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text('🧑‍🤝‍🧑', style: TextStyle(fontSize: 40)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ادرس مع الأصدقاء', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text('حفز بعضكم بالتركيز معاً', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('🚀 تم بدء الجلسة! ركز مع أصدقائك')),
                            );
                          },
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('ابدأ جلسة جماعية'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Buddies list
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text('أصدقائي', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text('${_buddies.length}', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _buddies.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('👥', style: TextStyle(fontSize: 60)),
                          const SizedBox(height: 16),
                          Text('لا يوجد أصدقاء بعد', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text('أضف أصدقاء للمذاكرة معاً', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _buddies.length,
                      itemBuilder: (context, index) {
                        final buddy = _buddies[index];
                        final totalFocus = buddy['totalFocus'] ?? '0';
                        final lastActive = buddy['lastActive'] ?? 'لم يبدأ بعد';
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.withAlpha(25),
                              child: Text(
                                (buddy['name'] ?? '?')[0].toUpperCase(),
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                              ),
                            ),
                            title: Text(buddy['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text('⏱ $totalFocus دقيقة | آخر نشاط: $lastActive', style: const TextStyle(fontSize: 11)),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                              onPressed: () {
                                context.read<AppProvider>().removeStudyBuddy(index);
                                _loadBuddies();
                                setState(() {});
                              },
                            ),
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
