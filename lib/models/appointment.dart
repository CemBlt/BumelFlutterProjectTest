import 'user.dart';
import 'hospital.dart';

class Appointment {
  final String id;
  final String userId;
  final String hospitalId;
  final String doctorName;
  final DateTime appointmentDate;
  final String appointmentTime;
  final String status; // 'pending', 'confirmed', 'completed', 'cancelled'
  final String? notes;
  final DateTime createdAt;
  final String hospitalName;
  final String timeSlot;
  final String employeeId;
  final User? user;
  final Hospital? hospital;
  final Employee? employee;

  Appointment({
    required this.id,
    required this.userId,
    required this.hospitalId,
    required this.doctorName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.hospitalName,
    required this.timeSlot,
    required this.employeeId,
    this.user,
    this.hospital,
    this.employee,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      hospitalId: json['hospitalId']?.toString() ?? '',
      doctorName: json['doctorName'] ?? '',
      appointmentDate: DateTime.parse(json['appointmentDate'] ?? DateTime.now().toIso8601String()),
      appointmentTime: json['appointmentTime'] ?? '',
      status: json['status'] ?? 'pending',
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      hospitalName: json['hospitalName'] ?? '',
      timeSlot: json['timeSlot'] ?? '',
      employeeId: json['employeeId'] ?? '',
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
      'doctorName': doctorName,
      'appointmentDate': appointmentDate.toIso8601String(),
      'appointmentTime': appointmentTime,
      'status': status,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'hospitalName': hospitalName,
      'timeSlot': timeSlot,
      'employeeId': employeeId,
      'user': user?.toJson(),
      'hospital': hospital?.toJson(),
      'employee': employee?.toJson(),
    };
  }

  Appointment copyWith({
    String? id,
    String? userId,
    String? hospitalId,
    String? doctorName,
    DateTime? appointmentDate,
    String? appointmentTime,
    String? status,
    String? notes,
    DateTime? createdAt,
    String? hospitalName,
    String? timeSlot,
    String? employeeId,
    User? user,
    Hospital? hospital,
    Employee? employee,
  }) {
    return Appointment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      hospitalId: hospitalId ?? this.hospitalId,
      doctorName: doctorName ?? this.doctorName,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      hospitalName: hospitalName ?? this.hospitalName,
      timeSlot: timeSlot ?? this.timeSlot,
      employeeId: employeeId ?? this.employeeId,
      user: user ?? this.user,
      hospital: hospital ?? this.hospital,
      employee: employee ?? this.employee,
    );
  }

  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
  bool get isActive => status == 'active';
}

