import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import '../models/user_role.dart';

/// Provider for authentication state management
class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;
  String? _userId;
  String? _userEmail;
  String? _userName;
  UserRole? _userRole;

  AuthProvider() : _authService = AuthServiceFactory.create() {
    _init();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;
  String? get userEmail => _userEmail;
  String? get userName => _userName;
  UserRole? get userRole => _userRole;
  bool get isAdmin => _userRole == UserRole.admin;
  bool get isStaff =>
      _userRole == UserRole.staff || _userRole == UserRole.admin;

  Future<void> _init() async {
    await _authService.initialize();
    _userRole = _authService.getUserRole();
    _isAuthenticated = _authService.isAuthenticated;
    _userId = _authService.currentUserId;
    _userEmail = _authService.currentUserEmail;
    _userName = _authService.currentUserName;
    _authService.authStateChanges.listen((user) {
      _isAuthenticated = _authService.isAuthenticated;
      _userId = _authService.currentUserId;
      _userEmail = _authService.currentUserEmail;
      _userName = _authService.currentUserName;
      _userRole = _authService.getUserRole();
      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.signInWithEmail(email, password);
      _userRole = _authService.getUserRole();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.signUpWithEmail(email, password, name);
      _userRole = _authService.getUserRole();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    _clearError();
    try {
      await _authService.sendPasswordResetEmail(email);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  void updateProfile({String? name, String? email}) {
    if (name != null) {
      _userName = name;
    }
    if (email != null) {
      _userEmail = email;
    }
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
