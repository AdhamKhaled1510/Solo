import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/user_model.dart';
import '../models/task_model.dart';
import '../models/prayer_model.dart';
import '../models/focus_session.dart';
import '../models/quest_model.dart';

class FirebaseService {
  final FirebaseAuth? _auth;
  final FirebaseFirestore? _firestore;

  FirebaseService()
      : _auth = _tryAuth(),
        _firestore = _tryFirestore();

  static FirebaseAuth? _tryAuth() {
    try { return FirebaseAuth.instance; } catch (_) { return null; }
  }

  static FirebaseFirestore? _tryFirestore() {
    try { return FirebaseFirestore.instance; } catch (_) { return null; }
  }

  bool get isAvailable => _auth != null && _firestore != null;

  User? get currentUser => _auth?.currentUser;
  bool get isLoggedIn => _auth?.currentUser != null;
  Stream<User?> get authStateChanges => _auth != null ? _auth!.authStateChanges() : const Stream.empty();

  Future<UserCredential?> signUp(String email, String password, String name) async {
    if (_auth == null || _firestore == null) return null;
    final cred = await _auth!.createUserWithEmailAndPassword(
      email: email, password: password,
    );
    await cred.user!.updateDisplayName(name);
    await _firestore!.collection('users').doc(cred.user!.uid).set({
      'name': name,
      'email': email,
      'level': 1,
      'xp': 0,
      'coins': 0,
      'streakDays': 0,
      'totalFocusMinutes': 0,
      'totalTreesPlanted': 0,
      'totalPrayersOnTime': 0,
      'completedTasks': 0,
      'completedQuests': 0,
    });
    return cred;
  }

  Future<UserCredential?> signIn(String email, String password) async {
    if (_auth == null) return null;
    return _auth!.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth?.signOut();
  }

  Future<void> saveUserData(UserModel user) async {
    if (_auth == null || _firestore == null) return;
    await _firestore!.collection('users').doc(user.id).set(user.toJson());
  }

  Future<UserModel?> loadUserData() async {
    if (_auth == null || _firestore == null || currentUser == null) return null;
    final doc = await _firestore!.collection('users').doc(currentUser!.uid).get();
    if (doc.exists) return UserModel.fromJson(doc.data()!);
    return null;
  }

  Future<void> saveTasks(List<TaskModel> tasks) async {
    if (_auth == null || _firestore == null) return;
    await _firestore!.collection('users').doc(currentUser!.uid).collection('tasks').doc('data').set({
      'tasks': tasks.map((t) => t.toJson()).toList(),
    });
  }

  Future<List<TaskModel>> loadTasks() async {
    if (_auth == null || _firestore == null || currentUser == null) return [];
    final doc = await _firestore!.collection('users').doc(currentUser!.uid).collection('tasks').doc('data').get();
    if (doc.exists && doc.data()!.containsKey('tasks')) {
      return (doc.data()!['tasks'] as List).map((e) => TaskModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> saveSessions(List<FocusSession> sessions) async {
    if (_auth == null || _firestore == null) return;
    await _firestore!.collection('users').doc(currentUser!.uid).collection('sessions').doc('data').set({
      'sessions': sessions.map((s) => s.toJson()).toList(),
    });
  }

  Future<List<FocusSession>> loadSessions() async {
    if (_auth == null || _firestore == null || currentUser == null) return [];
    final doc = await _firestore!.collection('users').doc(currentUser!.uid).collection('sessions').doc('data').get();
    if (doc.exists && doc.data()!.containsKey('sessions')) {
      return (doc.data()!['sessions'] as List).map((e) => FocusSession.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> savePrayerData(PrayerDay prayer) async {
    if (_auth == null || _firestore == null) return;
    final dateKey = '${prayer.date.year}-${prayer.date.month}-${prayer.date.day}';
    await _firestore!.collection('users').doc(currentUser!.uid)
        .collection('prayers').doc(dateKey).set(prayer.toJson());
  }

  Future<PrayerDay?> loadPrayerData(DateTime date) async {
    if (_auth == null || _firestore == null || currentUser == null) return null;
    final dateKey = '${date.year}-${date.month}-${date.day}';
    final doc = await _firestore!.collection('users').doc(currentUser!.uid)
        .collection('prayers').doc(dateKey).get();
    if (doc.exists) return PrayerDay.fromJson(doc.data()!);
    return null;
  }

  Future<void> saveQuests(List<QuestModel> quests) async {
    if (_auth == null || _firestore == null) return;
    await _firestore!.collection('users').doc(currentUser!.uid).collection('quests').doc('data').set({
      'quests': quests.map((q) => q.toJson()).toList(),
    });
  }

  Future<List<QuestModel>> loadQuests() async {
    if (_auth == null || _firestore == null || currentUser == null) return [];
    final doc = await _firestore!.collection('users').doc(currentUser!.uid).collection('quests').doc('data').get();
    if (doc.exists && doc.data()!.containsKey('quests')) {
      return (doc.data()!['quests'] as List).map((e) => QuestModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> syncAll({
    required UserModel user,
    required List<TaskModel> tasks,
    required List<FocusSession> sessions,
    required List<QuestModel> quests,
    PrayerDay? prayer,
  }) async {
    await saveUserData(user);
    await saveTasks(tasks);
    await saveSessions(sessions);
    await saveQuests(quests);
    if (prayer != null) await savePrayerData(prayer);
  }
}
