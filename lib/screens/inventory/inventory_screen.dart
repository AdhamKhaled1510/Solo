import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/clean_theme.dart';
import '../../core/widgets/clean_widgets.dart';
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
      builder: (ctx) => Theme(
        data: CleanTheme.dark,
        child: AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'إضافة ${_selectedType == ItemType.flashcard ? 'بطاقة' : _selectedType == ItemType.summary ? 'ملخص' : 'قانون'}',
            style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController, decoration: const InputDecoration(labelText: 'العنوان'),
                  textDirection: TextDirection.rtl, style: const TextStyle(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: _selectedType == ItemType.flashcard ? 'السؤال / الإجابة' : 'المحتوى',
                  ),
                  maxLines: 3, textDirection: TextDirection.rtl,
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _selectedSubject.isEmpty ? null : _selectedSubject,
                  decoration: const InputDecoration(labelText: 'المادة'),
                  dropdownColor: AppColors.surface,
                  items: _subjects.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(color: AppColors.textPrimary)))).toList(),
                  onChanged: (v) => setState(() => _selectedSubject = v ?? ''),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('إلغاء', style: TextStyle(color: AppColors.textSecondary))),
            ElevatedButton(
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
                setState(() {});
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('حفظ', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, app, _) {
        final items = app.inventory.where((i) => i.type == _selectedType).toList();
        return Scaffold(
          appBar: AppBar(title: const Text('الحقيبة')),
          body: Column(
            children: [
              // Category filter chips
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _FilterChip(label: '📇 بطاقات', selected: _selectedType == ItemType.flashcard, onTap: () => setState(() => _selectedType = ItemType.flashcard)),
                    const SizedBox(width: 8),
                    _FilterChip(label: '📝 ملخصات', selected: _selectedType == ItemType.summary, onTap: () => setState(() => _selectedType = ItemType.summary)),
                    const SizedBox(width: 8),
                    _FilterChip(label: '📐 قوانين', selected: _selectedType == ItemType.formula, onTap: () => setState(() => _selectedType = ItemType.formula)),
                  ],
                ),
              ),
              Expanded(
                child: items.isEmpty
                  ? const Center(child: Text('الحقيبة فارغة. أضف بعض البطاقات!', style: TextStyle(color: AppColors.textSecondary)))
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.1,
                      ),
                      itemCount: items.length,
                      itemBuilder: (_, i) {
                        final item = items[i];
                        return GlassCard(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: AppColors.cardLight, borderRadius: BorderRadius.circular(6)),
                                    child: Text(item.subject ?? 'عام', style: const TextStyle(fontSize: 9, color: AppColors.primary)),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      app.removeFromInventory(item.id);
                                      setState(() {});
                                    },
                                    child: const Icon(Icons.delete_outline, color: AppColors.error, size: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                              const Spacer(),
                              Text(item.content, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        );
                      },
                    ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showAddDialog,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withAlpha(20) : AppColors.cardLight,
          borderRadius: BorderRadius.circular(8),
          border: selected ? Border.all(color: AppColors.primary.withAlpha(60)) : null,
        ),
        child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? AppColors.primary : AppColors.textSecondary)),
      ),
    );
  }
}
