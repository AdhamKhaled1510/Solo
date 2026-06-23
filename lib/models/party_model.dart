enum PartyMemberRole { leader, member }

class PartyModel {
  final String id;
  final String name;
  final String leaderId;
  final List<String> memberIds;
  final DateTime createdAt;
  int weeklyScore;
  int totalScore;

  PartyModel({
    required this.id,
    required this.name,
    required this.leaderId,
    this.memberIds = const [],
    DateTime? createdAt,
    this.weeklyScore = 0,
    this.totalScore = 0,
  }) : createdAt = createdAt ?? DateTime.now();

  int get memberCount => memberIds.length + 1;
  bool get isFull => memberCount >= 5;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'leaderId': leaderId,
    'memberIds': memberIds,
    'createdAt': createdAt.toIso8601String(),
    'weeklyScore': weeklyScore,
    'totalScore': totalScore,
  };

  factory PartyModel.fromJson(Map<String, dynamic> json) => PartyModel(
    id: json['id'],
    name: json['name'],
    leaderId: json['leaderId'],
    memberIds: List<String>.from(json['memberIds'] ?? []),
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    weeklyScore: json['weeklyScore'] ?? 0,
    totalScore: json['totalScore'] ?? 0,
  );
}

class BossFight {
  final String id;
  final String name;
  final String subject;
  final String chapter;
  final int totalXp;
  bool defeated;
  int attempts;

  BossFight({
    required this.id,
    required this.name,
    required this.subject,
    required this.chapter,
    this.totalXp = 500,
    this.defeated = false,
    this.attempts = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'subject': subject,
    'chapter': chapter,
    'totalXp': totalXp,
    'defeated': defeated,
    'attempts': attempts,
  };

  factory BossFight.fromJson(Map<String, dynamic> json) => BossFight(
    id: json['id'],
    name: json['name'],
    subject: json['subject'],
    chapter: json['chapter'],
    totalXp: json['totalXp'] ?? 500,
    defeated: json['defeated'] ?? false,
    attempts: json['attempts'] ?? 0,
  );
}
