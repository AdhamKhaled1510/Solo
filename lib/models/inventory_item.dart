enum ItemType { flashcard, summary, formula, booster }

class InventoryItem {
  final String id;
  final String title;
  final String content;
  final ItemType type;
  final String? subject;
  final DateTime createdAt;

  InventoryItem({
    required this.id,
    required this.title,
    this.content = '',
    required this.type,
    this.subject,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  String get typeEmoji {
    switch (type) {
      case ItemType.flashcard: return '📇';
      case ItemType.summary: return '📝';
      case ItemType.formula: return '📐';
      case ItemType.booster: return '⚡';
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'type': type.index,
    'subject': subject,
    'createdAt': createdAt.toIso8601String(),
  };

  factory InventoryItem.fromJson(Map<String, dynamic> json) => InventoryItem(
    id: json['id'],
    title: json['title'],
    content: json['content'] ?? '',
    type: ItemType.values[json['type']],
    subject: json['subject'],
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
  );
}
