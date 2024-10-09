// models/user.dart

class User {
  int? id;
  String name;
  String email;
  String phone;
  String city;
  String password; // Hashed password
  String? plainPassword; // Plain password for syncing
  bool isSynced;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.city,
    required this.password,
    this.plainPassword,
    this.isSynced = false,
  });

  // Convert User to Map
  Map<String, dynamic> toMap() {
    print('Converting User to Map: $name, $email');
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'city': city,
      'password': password, // Hashed password
      'plain_password': plainPassword,
      'is_synced': isSynced ? 1 : 0,
    };
  }

  // Create User from Map
  factory User.fromMap(Map<String, dynamic> map) {
    print('Creating User from Map: ${map['email']}');
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      city: map['city'],
      password: map['password'], // Hashed password
      plainPassword: map['plain_password'],
      isSynced: map['is_synced'] == 1,
    );
  }
}
