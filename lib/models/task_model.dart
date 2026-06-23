enum TaskPriority { low, medium, high }

class TaskModel {
  final String id;
  String title;
  String? description;
  TaskPriority priority;
  List<String> tags;
  List<Subtask> subtasks;
  DateTime? dueDate;
  bool isCompleted;
  DateTime? completedAt;
  String? subjectId;
  DateTime createdAt;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.priority = TaskPriority.medium,
    this.tags = const [],
    this.subtasks = const [],
    this.dueDate,
    this.isCompleted = false,
    this.completedAt,
    this.subjectId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  int get completedSubtasks => subtasks.where((s) => s.isDone).length;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'priority': priority.index,
    'tags': tags,
    'subtasks': subtasks.map((s) => s.toJson()).toList(),
    'dueDate': dueDate?.toIso8601String(),
    'isCompleted': isCompleted,
    'completedAt': completedAt?.toIso8601String(),
    'subjectId': subjectId,
    'createdAt': createdAt.toIso8601String(),
  };

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    priority: TaskPriority.values[json['priority'] ?? 1],
    tags: List<String>.from(json['tags'] ?? []),
    subtasks: (json['subtasks'] as List?)?.map((s) => Subtask.fromJson(s)).toList() ?? [],
    dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
    isCompleted: json['isCompleted'] ?? false,
    completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
    subjectId: json['subjectId'],
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
  );
}

class Subtask {
  String title;
  bool isDone;

  Subtask({required this.title, this.isDone = false});

  Map<String, dynamic> toJson() => {'title': title, 'isDone': isDone};

  factory Subtask.fromJson(Map<String, dynamic> json) => Subtask(
    title: json['title'],
    isDone: json['isDone'] ?? false,
  );
}
