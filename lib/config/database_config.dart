import 'dart:io';

class DatabaseConfig {
  // Emülatör için 10.0.2.2, gerçek cihaz için localhost
  static String get host => Platform.isAndroid ? '10.0.2.2' : 'localhost';
  static const int port = 5432;
  static const String databaseName = 'dis_hastaneleri';
  static const String username = 'postgres';
  static const String password = '123456'; // PostgreSQL şifrenizi buraya yazın
  
  static String get connectionString => 
      'postgresql://$username:$password@$host:$port/$databaseName';
}