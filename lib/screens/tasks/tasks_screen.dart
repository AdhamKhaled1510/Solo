import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/task_model.dart';
import '../../providers/app_provider.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  TaskPriority _selectedPriority = TaskPriority.medium;
  String _selectedTag = '';
  final List<String> _tags = ['#فيزياء', '#عربي', '#إنجليزي', '#أحياء', '#كيمياء', '#تاريخ', '#عام'];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _showAddDialog() {
    _titleController.clear();
    _descController.clear();
    _selectedPriority = TaskPriority.medium;
    _selectedTag = '';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة مهمة جديدة'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'عنوان المهمة'),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'وصف (اختياري)'),
                maxLines: 2,
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<TaskPriority>(
                initialValue: _selectedPriority,
                decoration: const InputDecoration(labelText: 'الأولوية'),
                items: const [
                  DropdownMenuItem(value: TaskPriority.low, child: Text('🟢 منخفضة')),
                  DropdownMenuItem(value: TaskPriority.medium, child: Text('🟡 متوسطة')),
                  DropdownMenuItem(value: TaskPriority.high, child: Text('🔴 عالية')),
                ],
                onChanged: (v) => setState(() => _selectedPriority = v!),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: _tags.map((tag) => ChoiceChip(
                  label: Text(tag),
                  selected: _selectedTag == tag,
                  onSelected: (_) => setState(() => _selectedTag = tag),
                )).toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('إلغاء')),
          FilledButton(
            onPressed: () {
              if (_titleController.text.trim().isEmpty) return;
              final task = TaskModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: _titleController.text.trim(),
                description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
                priority: _selectedPriority,
                tags: _selectedTag.isNotEmpty ? [_selectedTag] : [],
              );
              context.read<AppProvider>().addTask(task);
              Navigator.of(ctx).pop();
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, app, _) {
        final tasks = app.pendingTasks;
        return Scaffold(
          appBar: AppBar(title: const Text('📋 المهام')),
          floatingActionButton: FloatingActionButton(
            onPressed: _showAddDialog,
            child: const Icon(Icons.add),
          ),
          body: tasks.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('📝', style: TextStyle(fontSize: 80)),
                    const SizedBox(height: 16),
                    Text('لا توجد مهام', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text('أضف مهمة جديدة للبدء', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    child: ListTile(
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) => app.toggleTask(task.id),
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          color: task.isCompleted ? Colors.grey : null,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (task.description != null) Text(task.description!, maxLines: 1, overflow: TextOverflow.ellipsis),
                          if (task.tags.isNotEmpty)
                            Wrap(
                              spacing: 4,
                              children: task.tags.map((t) => Chip(
                                label: Text(t, style: const TextStyle(fontSize: 10)),
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              )).toList(),
                            ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            task.priority == TaskPriority.high ? Icons.flag : Icons.flag_outlined,
                            color: task.priority == TaskPriority.high ? Colors.red : task.priority == TaskPriority.medium ? Colors.orange : Colors.green,
                            size: 18,
                          ),
                          if (task.subtasks.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Text('${task.completedSubtasks}/${task.subtasks.length}', style: const TextStyle(fontSize: 12)),
                            ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18),
                            onPressed: () => app.deleteTask(task.id),
                          ),
                        ],
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
