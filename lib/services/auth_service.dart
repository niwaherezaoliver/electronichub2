import 'package:flutter/foundation.dart';

/// Abstract service interface for authentication
abstract class AuthService {
  Future<void> initialize();
  Future<void> signInWithEmail(String email, String password);
  Future<void> signUpWithEmail(String email, String password, String name);
  Future<void> signOut();
  Stream get authStateChanges;
  bool get isAuthenticated;
  String? get currentUserId;
  String? get currentUserEmail;
  String? get currentUserName;
  Future<void> sendPasswordResetEmail(String email);
}

/// Factory to create the appropriate auth service based on platform
class AuthServiceFactory {
  static AuthService create() {
    if (kIsWeb) {
      return WebAuthService();
    } else {
      return FirebaseAuthService();
    }
  }
}

/// Firebase-based authentication implementation
class FirebaseAuthService implements AuthService {
  // Will be implemented with firebase_auth package
  @override
  Future<void> initialize() async {
    // TODO: Initialize Firebase Auth
    debugPrint('Firebase Auth initialized');
  }

  @override
  Future<void> signInWithEmail(String email, String password) async {
    // TODO: Implement Firebase sign-in
    debugPrint('Firebase sign in: $email');
  }

  @override
  Future<void> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    // TODO: Implement Firebase sign-up
    debugPrint('Firebase sign up: $email, name: $name');
  }

  @override
  Future<void> signOut() async {
    // TODO: Sign out from Firebase
    debugPrint('Firebase sign out');
  }

  @override
  Stream get authStateChanges {
    // TODO: Return Firebase auth state stream
    return const Stream.empty();
  }

  @override
  bool get isAuthenticated => false;

  @override
  String? get currentUserId => null;

  @override
  String? get currentUserEmail => null;

  @override
  String? get currentUserName => null;

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    // TODO: Implement password reset
    debugPrint('Password reset email sent to: $email');
  }
}

/// Web-based authentication using localStorage (fallback)
class WebAuthService implements AuthService {
  final Map<String, String> _mockUsers = {};
  String? _currentUser;

  @override
  Future<void> initialize() async {
    debugPrint('Web Auth initialized (using localStorage)');
  }

  @override
  Future<void> signInWithEmail(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_mockUsers[email] != password) {
      throw Exception('Invalid email or password');
    }
    _currentUser = email;
    debugPrint('Signed in: $email');
  }

  @override
  Future<void> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_mockUsers.containsKey(email)) {
      throw Exception('Email already registered');
    }
    _mockUsers[email] = password;
    _currentUser = email;
    debugPrint('Signed up: $email, name: $name');
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    debugPrint('Signed out');
  }

  @override
  Stream get authStateChanges {
    // Simple stream that emits when auth state changes
    return const Stream.empty();
  }

  @override
  bool get isAuthenticated => _currentUser != null;

  @override
  String? get currentUserId => _currentUser;

  @override
  String? get currentUserEmail => _currentUser;

  @override
  String? get currentUserName => _currentUser?.split('@')[0];

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    if (!_mockUsers.containsKey(email)) {
      throw Exception('Email not found');
    }
    debugPrint('Password reset email sent to: $email');
  }
}
