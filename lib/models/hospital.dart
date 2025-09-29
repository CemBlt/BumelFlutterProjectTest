class Hospital {
  final int id;
  final String name;
  final String address;
  final String? phone;
  final String? email;
  final String? website;
  final String? description;
  final double? rating; // Nullable yapıldı - hiç yorum yoksa null
  final String? imageUrl;
  final DateTime createdAt;
  final List<Employee> employees;
  final List<Review> reviews;
  final String city;
  final String district;

  Hospital({
    required this.id,
    required this.name,
    required this.address,
    this.phone,
    this.email,
    this.website,
    this.description,
    this.rating, // Artık nullable
    this.imageUrl,
    required this.createdAt,
    this.employees = const [],
    this.reviews = const [],
    required this.city,
    required this.district,
  });

  String get location => address;

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
      description: json['description'],
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      employees: (json['employees'] as List<dynamic>?)
          ?.map((e) => Employee.fromJson(e))
          .toList() ?? [],
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => Review.fromJson(e))
          .toList() ?? [],
      city: json['city'] ?? '',
      district: json['district'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'website': website,
      'description': description,
      'rating': rating,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'employees': employees.map((e) => e.toJson()).toList(),
      'reviews': reviews.map((e) => e.toJson()).toList(),
      'city': city,
      'district': district,
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

