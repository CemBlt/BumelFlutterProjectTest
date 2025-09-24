import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  AuthProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('current_user');
      
      if (userJson != null) {
        final userData = json.decode(userJson);
        _currentUser = User.fromJson(userData);
      }
      
      _error = null;
    } catch (e) {
      _error = 'Kullanıcı bilgileri yüklenirken hata oluştu: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Basit validasyon
      if (email.isEmpty || password.isEmpty || name.isEmpty || phone.isEmpty) {
        _error = 'Tüm alanlar doldurulmalıdır';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (!email.contains('@')) {
        _error = 'Geçerli bir e-posta adresi giriniz';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (password.length < 6) {
        _error = 'Şifre en az 6 karakter olmalıdır';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Kullanıcı oluştur
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: name,
        phone: phone,
        createdAt: DateTime.now(),
      );

      // Kullanıcıyı kaydet
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', json.encode(user.toJson()));
      
      _currentUser = user;
      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Kayıt olurken hata oluştu: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Basit validasyon
      if (email.isEmpty || password.isEmpty) {
        _error = 'E-posta ve şifre gerekli';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Kayıtlı kullanıcıları kontrol et
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('current_user');
      
      if (userJson != null) {
        final userData = json.decode(userJson);
        final user = User.fromJson(userData);
        
        if (user.email == email) {
          _currentUser = user;
          _error = null;
          _isLoading = false;
          notifyListeners();
          return true;
        }
      }

      _error = 'E-posta veya şifre hatalı';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Giriş yaparken hata oluştu: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('current_user');
      
      _currentUser = null;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Çıkış yaparken hata oluştu: $e';
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

