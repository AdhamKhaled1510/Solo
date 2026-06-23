import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/inventory_item.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  ItemType _selectedType = ItemType.flashcard;
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedSubject = '';
  final List<String> _subjects = ['فيزياء', 'كيمياء', 'أحياء', 'عربي', 'إنجليزي', 'تاريخ', 'جغرافيا', 'رياضيات', 'فلسفة', 'عام'];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _showAddDialog() {
    _titleController.clear();
    _contentController.clear();
    _selectedSubject = '';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('إضافة ${_selectedType == ItemType.flashcard ? 'بطاقة' : _selectedType == ItemType.summary ? 'ملخص' : 'قانون'}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'العنوان'),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: _selectedType == ItemType.flashcard ? 'السؤال/الإجابة' : 'المحتوى',
                ),
                maxLines: 3,
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedSubject.isEmpty ? null : _selectedSubject,
                decoration: const InputDecoration(labelText: 'المادة'),
                items: _subjects.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _selectedSubject = v ?? ''),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('إلغاء')),
          FilledButton(
            onPressed: () {
              if (_titleController.text.trim().isEmpty) return;
              context.read<AppProvider>().addToInventory(InventoryItem(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: _titleController.text.trim(),
                content: _contentController.text.trim(),
                type: _selectedType,
                subject: _selectedSubject.isNotEmpty ? _selectedSubject : null,
              ));
              Navigator.of(ctx).pop();
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, app, _) {
        final items = app.inventory.where((i) => i.type == _selectedType).toList();
        return Scaffold(
          appBar: AppBar(title: const Text('🎒 الحقيبة')),
          floatingActionButton: FloatingActionButton(
            onPressed: _showAddDialog,
            child: const Icon(Icons.add),
          ),
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _TypeChip(label: '📇 بطاقات', type: ItemType.flashcard, selected: _selectedType == ItemType.flashcard, onTap: () => setState(() => _selectedType = ItemType.flashcard)),
                    const SizedBox(width: 8),
                    _TypeChip(label: '📝 ملخصات', type: ItemType.summary, selected: _selectedType == ItemType.summary, onTap: () => setState(() => _selectedType = ItemType.summary)),
                    const SizedBox(width: 8),
                    _TypeChip(label: '📐 قوانين', type: ItemType.formula, selected: _selectedType == ItemType.formula, onTap: () => setState(() => _selectedType = ItemType.formula)),
                  ],
                ),
              ),
              Expanded(
                child: items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('📂', style: TextStyle(fontSize: 60)),
                          const SizedBox(height: 16),
                          Text('لا توجد ${_selectedType == ItemType.flashcard ? 'بطاقات' : _selectedType == ItemType.summary ? 'ملخصات' : 'قوانين'}', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text('اضف + للإضافة', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Card(
                          child: ListTile(
                            leading: Text(item.typeEmoji, style: const TextStyle(fontSize: 28)),
                            title: Text(item.title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (item.subject != null) Text(item.subject!, style: TextStyle(color: Colors.blue, fontSize: 12)),
                                if (item.content.isNotEmpty) Text(item.content, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, size: 18),
                              onPressed: () => app.removeFromInventory(item.id),
                            ),
                            onTap: () => _showItemDetail(context, item),
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

  void _showItemDetail(BuildContext context, InventoryItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Text(item.typeEmoji),
            const SizedBox(width: 8),
            Expanded(child: Text(item.title)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.subject != null) Text('المادة: ${item.subject}', style: TextStyle(color: Colors.blue)),
            const SizedBox(height: 8),
            Text(item.content.isNotEmpty ? item.content : 'لا يوجد محتوى'),
            const SizedBox(height: 8),
            Text('🕐 ${_formatDate(item.createdAt)}', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('إغلاق')),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) => '${d.year}/${d.month}/${d.day}';
}

class _TypeChip extends StatelessWidget {
  final String label;
  final ItemType type;
  final bool selected;
  final VoidCallback onTap;
  const _TypeChip({required this.label, required this.type, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ChoiceChip(
        label: Text(label, style: TextStyle(fontSize: 11)),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}
