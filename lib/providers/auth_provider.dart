import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseService _firebase = FirebaseService();
  bool _isLoading = true;
  bool _isLoggedIn = false;
  UserModel? _user;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  UserModel? get user => _user;
  FirebaseService get firebase => _firebase;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    if (!_firebase.isAvailable) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    _firebase.authStateChanges.listen((user) async {
      if (user != null) {
        _user = await _firebase.loadUserData();
        _isLoggedIn = true;
      } else {
        _user = null;
        _isLoggedIn = false;
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> signUp(String email, String password, String name) async {
    final cred = await _firebase.signUp(email, password, name);
    if (cred == null || cred.user == null) return;
    _user = UserModel(
      id: cred.user!.uid,
      name: name,
      email: email,
    );
    await _firebase.saveUserData(_user!);
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    final cred = await _firebase.signIn(email, password);
    if (cred == null) return;
    _user = await _firebase.loadUserData();
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _firebase.signOut();
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
