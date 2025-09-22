import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/appointment.dart';
import '../models/user.dart';
import '../models/hospital.dart';

class AppointmentProvider with ChangeNotifier {
  List<Appointment> _appointments = [];
  bool _isLoading = false;
  String? _error;

  List<Appointment> get appointments => _appointments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Kullanıcının aktif randevusu
  Appointment? getActiveAppointment(String userId) {
    try {
      return _appointments.firstWhere(
        (appointment) => appointment.userId == userId && appointment.isActive,
      );
    } catch (e) {
      return null;
    }
  }

  // Belirli bir tarih ve saat için randevu var mı?
  bool isTimeSlotBooked(DateTime date, String timeSlot, String employeeId) {
    return _appointments.any((appointment) {
      final appointmentDate = appointment.appointmentDate;
      return appointmentDate.year == date.year &&
          appointmentDate.month == date.month &&
          appointmentDate.day == date.day &&
          appointment.timeSlot == timeSlot &&
          appointment.employeeId == employeeId &&
          appointment.isActive;
    });
  }

  // Belirli bir tarih için müsait saatler
  List<String> getAvailableTimeSlots(DateTime date, String employeeId) {
    final timeSlots = [
      '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
      '12:00', '12:30', '13:00', '13:30', '14:00', '14:30',
      '15:00', '15:30', '16:00', '16:30', '17:00', '17:30',
    ];

    return timeSlots.where((timeSlot) => 
        !isTimeSlotBooked(date, timeSlot, employeeId)
    ).toList();
  }

  AppointmentProvider() {
    loadAppointments();
  }

  Future<void> loadAppointments() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final appointmentsJson = prefs.getString('appointments');
      
      if (appointmentsJson != null) {
        final List<dynamic> appointmentsList = json.decode(appointmentsJson);
        _appointments = appointmentsList.map((json) => Appointment.fromJson(json)).toList();
      }
      
      _error = null;
    } catch (e) {
      _error = 'Randevular yüklenirken hata oluştu: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveAppointments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final appointmentsJson = json.encode(_appointments.map((a) => a.toJson()).toList());
      await prefs.setString('appointments', appointmentsJson);
    } catch (e) {
      _error = 'Randevular kaydedilirken hata oluştu: $e';
      notifyListeners();
    }
  }

  Future<bool> createAppointment({
    required String userId,
    required String hospitalId,
    required String employeeId,
    required DateTime appointmentDate,
    required String timeSlot,
    required String notes,
  }) async {
    try {
      // Kullanıcının aktif randevusu var mı kontrol et
      if (getActiveAppointment(userId) != null) {
        _error = 'Zaten aktif bir randevunuz bulunmaktadır';
        notifyListeners();
        return false;
      }

      // Bu saat dilimi dolu mu kontrol et
      if (isTimeSlotBooked(appointmentDate, timeSlot, employeeId)) {
        _error = 'Seçilen saat dilimi dolu';
        notifyListeners();
        return false;
      }

      // Randevu oluştur
      final appointment = Appointment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        hospitalId: hospitalId,
        employeeId: employeeId,
        appointmentDate: appointmentDate,
        timeSlot: timeSlot,
        status: 'active',
        notes: notes,
        createdAt: DateTime.now(),
      );

      _appointments.add(appointment);
      await _saveAppointments();
      
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Randevu oluşturulurken hata oluştu: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> cancelAppointment(String appointmentId) async {
    try {
      final index = _appointments.indexWhere((a) => a.id == appointmentId);
      if (index != -1) {
        _appointments[index] = _appointments[index].copyWith(status: 'cancelled');
        await _saveAppointments();
        
        _error = null;
        notifyListeners();
        return true;
      }
      
      _error = 'Randevu bulunamadı';
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Randevu iptal edilirken hata oluştu: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> completeAppointment(String appointmentId) async {
    try {
      final index = _appointments.indexWhere((a) => a.id == appointmentId);
      if (index != -1) {
        _appointments[index] = _appointments[index].copyWith(status: 'completed');
        await _saveAppointments();
        
        _error = null;
        notifyListeners();
        return true;
      }
      
      _error = 'Randevu bulunamadı';
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Randevu tamamlanırken hata oluştu: $e';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
