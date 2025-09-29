import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/hospital.dart';
import '../services/database_service.dart';

class HospitalProvider with ChangeNotifier {
  List<Hospital> _hospitals = [];
  bool _isLoading = false;
  String? _error;

  List<Hospital> get hospitals => _hospitals;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final List<Map<String, dynamic>> _sampleHospitals = [
    {
      'id': '1',
      'name': 'Ağız ve Diş Sağlığı Merkezi',
      'city': 'İstanbul',
      'district': 'Kadıköy',
      'rating': 4.5,
      'latitude': 40.9888,
      'longitude': 29.0238,
      'address': 'Moda Caddesi No:123, Kadıköy/İstanbul',
      'phone': '+90 216 123 45 67',
      'email': 'info@agizdis.com',
      'employees': [
        {
          'id': '1',
          'name': 'Dr. Ahmet Yılmaz',
          'role': 'Başhekim',
          'photoUrl': 'https://via.placeholder.com/150',
          'specialization': 'Ortodonti',
          'experienceYears': 15,
        },
        {
          'id': '2',
          'name': 'Dr. Ayşe Demir',
          'role': 'Diş Hekimi',
          'photoUrl': 'https://via.placeholder.com/150',
          'specialization': 'Protez',
          'experienceYears': 8,
        },
      ],
      'reviews': [
        {
          'id': '1',
          'userName': 'Mehmet K.',
          'userPhotoUrl': 'https://via.placeholder.com/50',
          'rating': 5.0,
          'comment': 'Çok profesyonel bir ekip, memnun kaldım.',
          'date': '2024-01-15T10:30:00Z',
          'photos': [],
        },
      ],
    },
    {
      'id': '2',
      'name': 'Gülümseme Diş Kliniği',
      'city': 'Ankara',
      'district': 'Çankaya',
      'rating': 4.2,
      'latitude': 39.9208,
      'longitude': 32.8541,
      'address': 'Tunalı Hilmi Caddesi No:45, Çankaya/Ankara',
      'phone': '+90 312 987 65 43',
      'email': 'info@gulumseme.com',
      'employees': [
        {
          'id': '3',
          'name': 'Dr. Fatma Özkan',
          'role': 'Başhekim',
          'photoUrl': 'https://via.placeholder.com/150',
          'specialization': 'Endodonti',
          'experienceYears': 12,
        },
      ],
      'reviews': [
        {
          'id': '2',
          'userName': 'Ali V.',
          'userPhotoUrl': 'https://via.placeholder.com/50',
          'rating': 4.0,
          'comment': 'Temiz ve modern bir klinik.',
          'date': '2024-01-10T14:20:00Z',
          'photos': [],
        },
      ],
    },
    {
      'id': '3',
      'name': 'Beyaz Dişler Merkezi',
      'city': 'İzmir',
      'district': 'Konak',
      'rating': 4.8,
      'latitude': 38.4192,
      'longitude': 27.1287,
      'address': 'Kıbrıs Şehitleri Caddesi No:78, Konak/İzmir',
      'phone': '+90 232 555 12 34',
      'email': 'info@beyazdisler.com',
      'employees': [
        {
          'id': '4',
          'name': 'Dr. Can Yıldız',
          'role': 'Başhekim',
          'photoUrl': 'https://via.placeholder.com/150',
          'specialization': 'Estetik Diş Hekimliği',
          'experienceYears': 20,
        },
        {
          'id': '5',
          'name': 'Dr. Zeynep Kaya',
          'role': 'Diş Hekimi',
          'photoUrl': 'https://via.placeholder.com/150',
          'specialization': 'Pedodonti',
          'experienceYears': 6,
        },
        {
          'id': '6',
          'name': 'Dr. Murat Arslan',
          'role': 'Diş Hekimi',
          'photoUrl': 'https://via.placeholder.com/150',
          'specialization': 'Periodontoloji',
          'experienceYears': 10,
        },
      ],
      'reviews': [
        {
          'id': '3',
          'userName': 'Elif S.',
          'userPhotoUrl': 'https://via.placeholder.com/50',
          'rating': 5.0,
          'comment': 'Harika bir deneyim, kesinlikle tavsiye ederim!',
          'date': '2024-01-20T09:15:00Z',
          'photos': [],
        },
        {
          'id': '4',
          'userName': 'Oğuz T.',
          'userPhotoUrl': 'https://via.placeholder.com/50',
          'rating': 4.5,
          'comment': 'Çok memnun kaldım, teşekkürler.',
          'date': '2024-01-18T16:45:00Z',
          'photos': [],
        },
      ],
    },
  ];

  HospitalProvider() {
    _loadHospitals();
  }

  Future<void> _loadHospitals() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Veritabanından hastaneleri yükle
      _hospitals = await DatabaseService.getAllHospitals();
      
      // Eğer veritabanında hastane yoksa örnek verileri ekle
      if (_hospitals.isEmpty) {
        for (final hospitalData in _sampleHospitals) {
          final hospital = Hospital.fromJson(hospitalData);
          await DatabaseService.createHospital(hospital);
        }
        _hospitals = await DatabaseService.getAllHospitals();
      }
      
      _error = null;
    } catch (e) {
      _error = 'Hastaneler yüklenirken hata oluştu: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveHospitals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hospitalsJson = json.encode(_hospitals.map((h) => h.toJson()).toList());
      await prefs.setString('hospitals', hospitalsJson);
    } catch (e) {
      _error = 'Hastaneler kaydedilirken hata oluştu: $e';
      notifyListeners();
    }
  }

  Future<void> addHospital(Hospital hospital) async {
    try {
      final createdHospital = await DatabaseService.createHospital(hospital);
      _hospitals.add(createdHospital);
      notifyListeners();
    } catch (e) {
      _error = 'Hastane eklenirken hata oluştu: $e';
      notifyListeners();
    }
  }

  Future<void> updateHospital(Hospital hospital) async {
    final index = _hospitals.indexWhere((h) => h.id == hospital.id);
    if (index != -1) {
      _hospitals[index] = hospital;
      await _saveHospitals();
      notifyListeners();
    }
  }

  Future<void> deleteHospital(String hospitalId) async {
    _hospitals.removeWhere((h) => h.id.toString() == hospitalId);
    await _saveHospitals();
    notifyListeners();
  }

  Hospital? getHospitalById(int id) {
    try {
      return _hospitals.firstWhere((h) => h.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Hospital> searchHospitals(String query) {
    if (query.isEmpty) return _hospitals;
    
    return _hospitals.where((hospital) {
      return hospital.name.toLowerCase().contains(query.toLowerCase()) ||
             hospital.address.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  Future<void> reloadHospitals() async {
    await _loadHospitals();
  }
}

