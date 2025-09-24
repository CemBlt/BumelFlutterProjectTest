import 'user.dart';
import 'hospital.dart';

class Appointment {
  final String id;
  final String userId;
  final String hospitalId;
  final String employeeId;
  final DateTime appointmentDate;
  final String timeSlot;
  final String status; // 'active', 'completed', 'cancelled'
  final String notes;
  final DateTime createdAt;
  final User? user;
  final Hospital? hospital;
  final Employee? employee;

  Appointment({
    required this.id,
    required this.userId,
    required this.hospitalId,
    required this.employeeId,
    required this.appointmentDate,
    required this.timeSlot,
    required this.status,
    required this.notes,
    required this.createdAt,
    this.user,
    this.hospital,
    this.employee,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      userId: json['userId'],
      hospitalId: json['hospitalId'],
      employeeId: json['employeeId'],
      appointmentDate: DateTime.parse(json['appointmentDate']),
      timeSlot: json['timeSlot'],
      status: json['status'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      hospital: json['hospital'] != null ? Hospital.fromJson(json['hospital']) : null,
      employee: json['employee'] != null ? Employee.fromJson(json['employee']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'hospitalId': hospitalId,
      'employeeId': employeeId,
      'appointmentDate': appointmentDate.toIso8601String(),
      'timeSlot': timeSlot,
      'status': status,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'user': user?.toJson(),
      'hospital': hospital?.toJson(),
      'employee': employee?.toJson(),
    };
  }

  Appointment copyWith({
    String? id,
    String? userId,
    String? hospitalId,
    String? employeeId,
    DateTime? appointmentDate,
    String? timeSlot,
    String? status,
    String? notes,
    DateTime? createdAt,
    User? user,
    Hospital? hospital,
    Employee? employee,
  }) {
    return Appointment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      hospitalId: hospitalId ?? this.hospitalId,
      employeeId: employeeId ?? this.employeeId,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      timeSlot: timeSlot ?? this.timeSlot,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
      hospital: hospital ?? this.hospital,
      employee: employee ?? this.employee,
    );
  }

  bool get isActive => status == 'active';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
}

