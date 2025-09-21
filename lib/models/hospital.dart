class Hospital {
  final String id;
  final String name;
  final String city;
  final String district;
  final double rating;
  final double latitude;
  final double longitude;
  final List<Employee> employees;
  final List<Review> reviews;
  final String address;
  final String phone;
  final String email;

  Hospital({
    required this.id,
    required this.name,
    required this.city,
    required this.district,
    required this.rating,
    required this.latitude,
    required this.longitude,
    required this.employees,
    required this.reviews,
    required this.address,
    required this.phone,
    required this.email,
  });

  String get location => '$city / $district';

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      district: json['district'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      employees: (json['employees'] as List<dynamic>?)
          ?.map((e) => Employee.fromJson(e))
          .toList() ?? [],
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => Review.fromJson(e))
          .toList() ?? [],
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'district': district,
      'rating': rating,
      'latitude': latitude,
      'longitude': longitude,
      'employees': employees.map((e) => e.toJson()).toList(),
      'reviews': reviews.map((e) => e.toJson()).toList(),
      'address': address,
      'phone': phone,
      'email': email,
    };
  }
}

class Employee {
  final String id;
  final String name;
  final String role;
  final String photoUrl;
  final String specialization;
  final int experienceYears;

  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.photoUrl,
    required this.specialization,
    required this.experienceYears,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      specialization: json['specialization'] ?? '',
      experienceYears: json['experienceYears'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'photoUrl': photoUrl,
      'specialization': specialization,
      'experienceYears': experienceYears,
    };
  }
}

class Review {
  final String id;
  final String userName;
  final String userPhotoUrl;
  final double rating;
  final String comment;
  final DateTime date;
  final List<String> photos;

  Review({
    required this.id,
    required this.userName,
    required this.userPhotoUrl,
    required this.rating,
    required this.comment,
    required this.date,
    required this.photos,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? '',
      userName: json['userName'] ?? '',
      userPhotoUrl: json['userPhotoUrl'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      comment: json['comment'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
      'photos': photos,
    };
  }
}

