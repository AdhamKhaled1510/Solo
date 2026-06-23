import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';
import '../models/task_model.dart';
import '../models/prayer_model.dart';
import '../models/focus_session.dart';
import '../models/quest_model.dart';

class StorageService {
  static const _userBox = 'user';
  static const _tasksBox = 'tasks';
  static const _prayerBox = 'prayers';
  static const _sessionsBox = 'sessions';
  static const _questsBox = 'quests';
  static const _gardenBox = 'garden';
  static const _buddiesBox = 'buddies';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_userBox);
    await Hive.openBox(_tasksBox);
    await Hive.openBox(_prayerBox);
    await Hive.openBox(_sessionsBox);
    await Hive.openBox(_questsBox);
    await Hive.openBox(_gardenBox);
    await Hive.openBox(_buddiesBox);
  }

  Box get _user => Hive.box(_userBox);
  Box get _tasks => Hive.box(_tasksBox);
  Box get _prayer => Hive.box(_prayerBox);
  Box get _sessions => Hive.box(_sessionsBox);
  Box get _quests => Hive.box(_questsBox);
  Box get _garden => Hive.box(_gardenBox);
  Box get _buddies => Hive.box(_buddiesBox);

  // User
  UserModel? loadUser() {
    final data = _user.get('currentUser');
    if (data != null) return UserModel.fromJson(jsonDecode(data));
    return null;
  }

  void saveUser(UserModel user) {
    _user.put('currentUser', jsonEncode(user.toJson()));
  }

  UserModel createNewUser(String uuid) {
    final user = UserModel(id: uuid);
    saveUser(user);
    return user;
  }

  // Tasks
  List<TaskModel> loadTasks() {
    final data = _tasks.get('tasks');
    if (data != null) {
      return (jsonDecode(data) as List).map((e) => TaskModel.fromJson(e)).toList();
    }
    return [];
  }

  void saveTasks(List<TaskModel> tasks) {
    _tasks.put('tasks', jsonEncode(tasks.map((t) => t.toJson()).toList()));
  }

  // Prayer
  PrayerDay? loadPrayerToday() {
    final key = _todayKey();
    final data = _prayer.get(key);
    if (data != null) return PrayerDay.fromJson(jsonDecode(data));
    return null;
  }

  void savePrayerToday(PrayerDay prayer) {
    _prayer.put(_todayKey(), jsonEncode(prayer.toJson()));
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  PrayerDay getOrCreatePrayerToday() {
    final today = loadPrayerToday() ?? PrayerDay(date: DateTime.now());
    savePrayerToday(today);
    return today;
  }

  // Sessions
  List<FocusSession> loadSessions() {
    final data = _sessions.get('sessions');
    if (data != null) {
      return (jsonDecode(data) as List).map((e) => FocusSession.fromJson(e)).toList();
    }
    return [];
  }

  void saveSessions(List<FocusSession> sessions) {
    _sessions.put('sessions', jsonEncode(sessions.map((s) => s.toJson()).toList()));
  }

  // Quests
  List<QuestModel> loadQuests() {
    final data = _quests.get('quests');
    if (data != null) {
      return (jsonDecode(data) as List).map((e) => QuestModel.fromJson(e)).toList();
    }
    return [];
  }

  void saveQuests(List<QuestModel> quests) {
    _quests.put('quests', jsonEncode(quests.map((q) => q.toJson()).toList()));
  }

  // Garden (list of planted trees as strings)
  List<Map<String, dynamic>> loadGarden() {
    final data = _garden.get('garden');
    if (data != null) {
      return List<Map<String, dynamic>>.from(jsonDecode(data));
    }
    return [];
  }

  void saveGarden(List<Map<String, dynamic>> garden) {
    _garden.put('garden', jsonEncode(garden));
  }

  void addTreeToGarden(String treeType) {
    final garden = loadGarden();
    garden.add({
      'type': treeType,
      'plantedAt': DateTime.now().toIso8601String(),
    });
    saveGarden(garden);
  }

  // Study Buddies
  List<Map<String, String>> getStudyBuddies() {
    final data = _buddies.get('buddies');
    if (data != null) {
      return List<Map<String, String>>.from((jsonDecode(data) as List).map((e) => Map<String, String>.from(e)));
    }
    return [];
  }

  void saveStudyBuddies(List<Map<String, String>> buddies) {
    _buddies.put('buddies', jsonEncode(buddies));
  }

  void addStudyBuddy(String name) {
    final buddies = getStudyBuddies();
    buddies.add({
      'name': name,
      'totalFocus': '0',
      'lastActive': 'اليوم',
    });
    saveStudyBuddies(buddies);
  }

  void removeStudyBuddy(int index) {
    final buddies = getStudyBuddies();
    if (index >= 0 && index < buddies.length) {
      buddies.removeAt(index);
      saveStudyBuddies(buddies);
    }
  }
}
