class FocusSession {
  final String id;
  final DateTime startTime;
  DateTime? endTime;
  int durationMinutes;
  bool completed;
  bool treeAlive;
  String treeType;
  String tag;
  String? roomId;

  FocusSession({
    required this.id,
    required this.startTime,
    this.endTime,
    this.durationMinutes = 0,
    this.completed = false,
    this.treeAlive = true,
    this.treeType = 'star_coral',
    this.tag = '',
    this.roomId,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
    'durationMinutes': durationMinutes,
    'completed': completed,
    'treeAlive': treeAlive,
    'treeType': treeType,
    'tag': tag,
    'roomId': roomId,
  };

  factory FocusSession.fromJson(Map<String, dynamic> json) => FocusSession(
    id: json['id'],
    startTime: DateTime.parse(json['startTime']),
    endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
    durationMinutes: json['durationMinutes'] ?? 0,
    completed: json['completed'] ?? false,
    treeAlive: json['treeAlive'] ?? true,
    treeType: json['treeType'] ?? 'star_coral',
    tag: json['tag'] ?? '',
    roomId: json['roomId'],
  );

  static const List<FocusTag> availableTags = [
    FocusTag('study', '📚', 'دراسة'),
    FocusTag('work', '💼', 'عمل'),
    FocusTag('reading', '📖', 'قراءة'),
    FocusTag('exercise', '🏋️', 'رياضة'),
    FocusTag('meditation', '🧘', 'تأمل'),
    FocusTag('writing', '✍️', 'كتابة'),
    FocusTag('coding', '💻', 'برمجة'),
    FocusTag('art', '🎨', 'فن'),
    FocusTag('music', '🎵', 'موسيقى'),
    FocusTag('other', '🔵', 'أخرى'),
  ];

  static FocusTag getTagById(String id) {
    return availableTags.firstWhere((t) => t.id == id, orElse: () => availableTags.last);
  }
}

class FocusTag {
  final String id;
  final String emoji;
  final String name;
  const FocusTag(this.id, this.emoji, this.name);
}
