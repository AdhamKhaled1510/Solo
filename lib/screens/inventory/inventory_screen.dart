import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/cyberpunk_theme.dart';
import '../../core/widgets/cyberpunk_widgets.dart';
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
        data: CyberpunkTheme.dark,
        child: AlertDialog(
          backgroundColor: CyberColors.surface,
          shape: const BeveledRectangleBorder(
            side: BorderSide(color: CyberColors.neonCyan, width: 1.5),
          ),
          title: Text(
            'ADD ASSET / إضافة ${_selectedType == ItemType.flashcard ? 'بطاقة' : _selectedType == ItemType.summary ? 'ملخص' : 'قانون'}',
            style: const TextStyle(color: CyberColors.neonCyan, fontSize: 13, fontFamily: 'monospace', fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'TITLE / العنوان',
                    labelStyle: TextStyle(color: CyberColors.neonCyan, fontSize: 11, fontFamily: 'monospace'),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: CyberColors.dimCyan)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: CyberColors.neonCyan, width: 2)),
                  ),
                  style: const TextStyle(color: CyberColors.textPrimary, fontSize: 13),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: _selectedType == ItemType.flashcard ? 'Q&A / السؤال والإجابة' : 'CONTENT / المحتوى',
                    labelStyle: const TextStyle(color: CyberColors.neonCyan, fontSize: 11, fontFamily: 'monospace'),
                    enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: CyberColors.dimCyan)),
                    focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: CyberColors.neonCyan, width: 2)),
                  ),
                  style: const TextStyle(color: CyberColors.textPrimary, fontSize: 13),
                  maxLines: 3,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _selectedSubject.isEmpty ? null : _selectedSubject,
                  decoration: const InputDecoration(
                    labelText: 'SUBJECT / المادة',
                    labelStyle: TextStyle(color: CyberColors.neonCyan, fontSize: 11, fontFamily: 'monospace'),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: CyberColors.dimCyan)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: CyberColors.neonCyan, width: 2)),
                  ),
                  dropdownColor: CyberColors.surface,
                  items: _subjects.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(color: CyberColors.textPrimary, fontSize: 12)))).toList(),
                  onChanged: (v) => setState(() => _selectedSubject = v ?? ''),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('CANCEL', style: TextStyle(color: CyberColors.textDim, fontSize: 11, fontFamily: 'monospace')),
            ),
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
              style: ElevatedButton.styleFrom(backgroundColor: CyberColors.neonCyan),
              child: const Text('SAVE / حفظ', style: TextStyle(color: CyberColors.bg, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
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
          body: CustomPaint(
            painter: GridBackground(),
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BAG / الحقيبة',
                              style: TextStyle(color: CyberColors.neonCyan, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                            ),
                            Text('EARNED ASSETS / العتاد والبطاقات التعليمية', style: TextStyle(color: CyberColors.textDim, fontSize: 9, fontFamily: 'monospace')),
                          ],
                        ),
                        Icon(Icons.backpack_outlined, color: CyberColors.neonCyan, size: 24),
                      ],
                    ),
                  ),
                  const Divider(color: CyberColors.darkTeal, height: 1),
                  // Inventory Category Tabs
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _CategoryTabButton(
                          type: ItemType.flashcard,
                          label: 'CARDS',
                          icon: Icons.style_outlined,
                          isSelected: _selectedType == ItemType.flashcard,
                          onTap: () => setState(() => _selectedType = ItemType.flashcard),
                        ),
                        _CategoryTabButton(
                          type: ItemType.summary,
                          label: 'SUMMARIES',
                          icon: Icons.description_outlined,
                          isSelected: _selectedType == ItemType.summary,
                          onTap: () => setState(() => _selectedType = ItemType.summary),
                        ),
                        _CategoryTabButton(
                          type: ItemType.formula,
                          label: 'LAWS',
                          icon: Icons.functions_outlined,
                          isSelected: _selectedType == ItemType.formula,
                          onTap: () => setState(() => _selectedType = ItemType.formula),
                        ),
                      ],
                    ),
                  ),
                  // Inventory Items List
                  Expanded(
                    child: items.isEmpty
                        ? const Center(
                            child: Text(
                              'الحقيبة فارغة. أضف بعض البطاقات أو الملخصات!',
                              style: TextStyle(color: CyberColors.textDim, fontSize: 12, fontFamily: 'monospace'),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1.1,
                            ),
                            itemCount: items.length,
                            itemBuilder: (context, idx) {
                              final item = items[idx];
                              return _InventoryItemCard(item: item, app: app, onReload: () => setState(() {}));
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showAddDialog,
            backgroundColor: CyberColors.neonCyan,
            shape: const BeveledRectangleBorder(
              side: BorderSide(color: CyberColors.neonCyan, width: 1),
            ),
            child: const Icon(Icons.add, color: CyberColors.bg),
          ),
        );
      },
    );
  }
}

class _CategoryTabButton extends StatelessWidget {
  final ItemType type;
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryTabButton({
    required this.type,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? CyberColors.neonCyan : CyberColors.textDim;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? CyberColors.neonCyan.withAlpha(20) : Colors.transparent,
          border: Border.all(color: color.withAlpha(100), width: isSelected ? 1.5 : 0.5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
          ],
        ),
      ),
    );
  }
}

class _InventoryItemCard extends StatelessWidget {
  final InventoryItem item;
  final AppProvider app;
  final VoidCallback onReload;

  const _InventoryItemCard({required this.item, required this.app, required this.onReload});

  @override
  Widget build(BuildContext context) {
    return BracketFrame(
      color: CyberColors.neonCyan.withAlpha(120),
      padding: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: CyberColors.dimCyan, width: 0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  item.subject ?? 'GENERAL',
                  style: const TextStyle(fontSize: 8, color: CyberColors.neonCyan, fontFamily: 'monospace'),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  app.removeFromInventory(item.id);
                  onReload();
                },
                child: const Icon(Icons.delete_outline, size: 14, color: CyberColors.hotMagenta),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            item.title,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: CyberColors.textPrimary, fontFamily: 'monospace'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Text(
            item.content,
            style: const TextStyle(fontSize: 9, color: CyberColors.textDim),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
