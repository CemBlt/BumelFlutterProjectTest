import 'package:postgres/postgres.dart';
import '../config/database_config.dart';
import '../models/user.dart';
import '../models/hospital.dart';
import '../models/appointment.dart';

class DatabaseService {
  static Connection? _connection;
  
  static Future<Connection> get connection async {
    if (_connection == null) {
      final endpoint = Endpoint(
        host: DatabaseConfig.host,
        port: DatabaseConfig.port,
        database: DatabaseConfig.databaseName,
        username: DatabaseConfig.username,
        password: DatabaseConfig.password,
      );
      _connection = await Connection.open(
        endpoint,
        settings: ConnectionSettings(
          sslMode: SslMode.disable,
        ),
      );
    }
    return _connection!;
  }
  
  static Future<void> close() async {
    if (_connection != null) {
      await _connection!.close();
    }
  }
  
  // Veritabanı tablolarını oluştur
  static Future<void> initializeDatabase() async {
    try {
      final conn = await connection;
    
    // Users tablosu
    await conn.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        email VARCHAR(255) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL,
        name VARCHAR(255) NOT NULL,
        phone VARCHAR(20),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');
    
    // Hospitals tablosu
    await conn.execute('''
      CREATE TABLE IF NOT EXISTS hospitals (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        address TEXT NOT NULL,
        phone VARCHAR(20),
        email VARCHAR(255),
        website VARCHAR(255),
        description TEXT,
        rating DOUBLE PRECISION DEFAULT 0.0,
        image_url VARCHAR(500),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        city VARCHAR(255) NOT NULL DEFAULT 'İstanbul',
        district VARCHAR(255) NOT NULL DEFAULT 'Merkez'
      )
    ''');
    
    // Appointments tablosu
    await conn.execute('''
      CREATE TABLE IF NOT EXISTS appointments (
        id SERIAL PRIMARY KEY,
        user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
        hospital_id INTEGER REFERENCES hospitals(id) ON DELETE CASCADE,
        doctor_name VARCHAR(255) NOT NULL,
        appointment_date TIMESTAMP NOT NULL,
        appointment_time VARCHAR(10) NOT NULL,
        status VARCHAR(50) DEFAULT 'pending',
        notes TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');
    
    // Reviews tablosu
    await conn.execute('''
      CREATE TABLE IF NOT EXISTS reviews (
        id SERIAL PRIMARY KEY,
        user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
        hospital_id INTEGER REFERENCES hospitals(id) ON DELETE CASCADE,
        rating DOUBLE PRECISION NOT NULL CHECK (rating >= 1 AND rating <= 5),
        comment TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');
    } catch (e) {
      print('Veritabanı bağlantısı başarısız: $e');
      // Hata durumunda uygulama çalışmaya devam eder
    }
  }
  
  // User işlemleri
  static Future<User?> getUserByEmail(String email) async {
    try {
      final conn = await connection;
      final results = await conn.execute(
        Sql.named('SELECT * FROM users WHERE email = @email'),
        parameters: {'email': email}
      );
      
      if (results.isNotEmpty) {
        final row = results.first;
        return User(
          id: row[0].toString(),
          email: row[1] as String,
          password: row[2] as String,
          name: row[3] as String,
          phone: row[4] as String?,
          createdAt: row[5] as DateTime,
        );
      }
      return null;
    } catch (e) {
      print('Veritabanı hatası: $e');
      return null;
    }
  }
  
  static Future<User> createUser(User user) async {
    final conn = await connection;
    final results = await conn.execute(
      Sql.named('INSERT INTO users (email, password, name, phone) VALUES (@email, @password, @name, @phone) RETURNING id, created_at'),
      parameters: {
        'email': user.email,
        'password': user.password,
        'name': user.name,
        'phone': user.phone,
      }
    );
    
    final row = results.first;
    return User(
      id: row[0].toString(),
      email: user.email,
      password: user.password,
      name: user.name,
      phone: user.phone,
      createdAt: row[1] as DateTime,
    );
  }
  
  // Hospital işlemleri
  static Future<List<Hospital>> getAllHospitals() async {
    final conn = await connection;
    final results = await conn.execute(Sql('SELECT * FROM hospitals ORDER BY name'));
    
    List<Hospital> hospitals = [];
    
    for (final row in results) {
      // Güvenli tip dönüşümü
      double parseDouble(dynamic value) {
        if (value == null) return 0.0;
        if (value is double) return value;
        if (value is int) return value.toDouble();
        if (value is String) return double.tryParse(value) ?? 0.0;
        return 0.0;
      }
      
      // Güvenli sütun erişimi
      String? getStringAt(int index) {
        if (index < row.length) return row[index] as String?;
        return null;
      }
      
      final hospitalId = row[0] as int;
      
      // Hastane için ortalama puanı hesapla
      final avgRating = await _calculateHospitalRating(hospitalId);
      
      hospitals.add(Hospital(
        id: hospitalId,
        name: row[1] as String,
        address: row[2] as String,
        phone: getStringAt(3),
        email: getStringAt(4),
        website: getStringAt(5),
        description: getStringAt(6),
        rating: avgRating,
        imageUrl: getStringAt(8),
        createdAt: row[9] as DateTime,
        city: getStringAt(10) ?? 'İstanbul',
        district: getStringAt(11) ?? 'Merkez',
      ));
    }
    
    return hospitals;
  }
  
  // Hastane için ortalama puanı hesapla
  static Future<double?> _calculateHospitalRating(int hospitalId) async {
    try {
      final conn = await connection;
      final results = await conn.execute(
        Sql.named('SELECT AVG(rating) FROM reviews WHERE hospital_id = @hospital_id'),
        parameters: {'hospital_id': hospitalId}
      );
      
      if (results.isNotEmpty) {
        final avgRating = results.first[0];
        if (avgRating != null) {
          return (avgRating as double);
        }
      }
      return null; // Hiç yorum yoksa null döndür
    } catch (e) {
      print('Puan hesaplama hatası: $e');
      return null;
    }
  }
  
  static Future<Hospital> createHospital(Hospital hospital) async {
    final conn = await connection;
    final results = await conn.execute(
      Sql.named('INSERT INTO hospitals (name, address, phone, email, website, description, rating, image_url, city, district) VALUES (@name, @address, @phone, @email, @website, @description, @rating, @image_url, @city, @district) RETURNING id, created_at'),
      parameters: {
        'name': hospital.name,
        'address': hospital.address,
        'phone': hospital.phone,
        'email': hospital.email,
        'website': hospital.website,
        'description': hospital.description,
        'rating': hospital.rating,
        'image_url': hospital.imageUrl,
        'city': hospital.city,
        'district': hospital.district,
      }
    );
    
    final row = results.first;
    return Hospital(
      id: row[0] as int,
      name: hospital.name,
      address: hospital.address,
      phone: hospital.phone,
      email: hospital.email,
      website: hospital.website,
      description: hospital.description,
      rating: hospital.rating,
      imageUrl: hospital.imageUrl,
      createdAt: row[1] as DateTime,
      city: hospital.city,
      district: hospital.district,
    );
  }
  
  // Appointment işlemleri
  static Future<List<Appointment>> getAppointmentsByUserId(String userId) async {
    final conn = await connection;
    final results = await conn.execute(
      Sql.named('SELECT a.*, h.name as hospital_name FROM appointments a JOIN hospitals h ON a.hospital_id = h.id WHERE a.user_id = @user_id ORDER BY a.appointment_date'),
      parameters: {'user_id': userId}
    );
    
    return results.map((row) => Appointment(
      id: row[0].toString(),
      userId: row[1].toString(),
      hospitalId: row[2].toString(),
      doctorName: row[3] as String,
      appointmentDate: row[4] as DateTime,
      appointmentTime: row[5] as String,
      status: row[6] as String,
      notes: row[7] as String?,
      createdAt: row[8] as DateTime,
      hospitalName: row[9] as String,
      timeSlot: row[5] as String, // appointmentTime ile aynı
      employeeId: '', // Varsayılan değer
    )).toList();
  }
  
  static Future<Appointment> createAppointment(Appointment appointment) async {
    final conn = await connection;
    final results = await conn.execute(
      Sql.named('INSERT INTO appointments (user_id, hospital_id, doctor_name, appointment_date, appointment_time, status, notes) VALUES (@user_id, @hospital_id, @doctor_name, @appointment_date, @appointment_time, @status, @notes) RETURNING id, created_at'),
      parameters: {
        'user_id': appointment.userId,
        'hospital_id': appointment.hospitalId,
        'doctor_name': appointment.doctorName,
        'appointment_date': appointment.appointmentDate,
        'appointment_time': appointment.appointmentTime,
        'status': appointment.status,
        'notes': appointment.notes,
      }
    );
    
    final row = results.first;
    return Appointment(
      id: row[0].toString(),
      userId: appointment.userId,
      hospitalId: appointment.hospitalId,
      doctorName: appointment.doctorName,
      appointmentDate: appointment.appointmentDate,
      appointmentTime: appointment.appointmentTime,
      status: appointment.status,
      notes: appointment.notes,
      createdAt: row[1] as DateTime,
      hospitalName: '', // Bu değer ayrıca çekilebilir
      timeSlot: appointment.timeSlot,
      employeeId: appointment.employeeId,
    );
  }
  
  // Review işlemleri
  static Future<List<Review>> getReviewsByHospitalId(int hospitalId) async {
    try {
      final conn = await connection;
      final results = await conn.execute(
        Sql.named('''
          SELECT r.id, r.user_id, r.hospital_id, r.rating, r.comment, r.created_at, u.name as user_name
          FROM reviews r 
          JOIN users u ON r.user_id = u.id 
          WHERE r.hospital_id = @hospital_id 
          ORDER BY r.created_at DESC
        '''),
        parameters: {'hospital_id': hospitalId}
      );
      
      return results.map((row) => Review(
        id: row[0].toString(),
        userName: row[6] as String, // user_name
        userPhotoUrl: '', // Şimdilik boş
        rating: row[3] as double,
        comment: row[4] as String? ?? '',
        date: row[5] as DateTime,
        photos: [], // Şimdilik boş
      )).toList();
    } catch (e) {
      print('Yorumları getirme hatası: $e');
      return [];
    }
  }
  
  static Future<bool> createReview({
    required String userId,
    required int hospitalId,
    required double rating,
    required String comment,
  }) async {
    try {
      final conn = await connection;
      await conn.execute(
        Sql.named('''
          INSERT INTO reviews (user_id, hospital_id, rating, comment) 
          VALUES (@user_id, @hospital_id, @rating, @comment)
        '''),
        parameters: {
          'user_id': userId,
          'hospital_id': hospitalId,
          'rating': rating,
          'comment': comment,
        }
      );
      return true;
    } catch (e) {
      print('Yorum oluşturma hatası: $e');
      return false;
    }
  }
}