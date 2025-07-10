class UserRegistrationModel {
  final String name;
  final String motherTongue;
  final String phoneNumber;
  final String email;
  final String address;

  UserRegistrationModel({
    required this.name,
    required this.motherTongue,
    required this.phoneNumber,
    required this.email,
    required this.address,
  });

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mother_tongue': motherTongue,
      'phone_number': phoneNumber,
      'email': email,
      'address': address,
    };
  }

  // Create object from JSON
  factory UserRegistrationModel.fromJson(Map<String, dynamic> json) {
    return UserRegistrationModel(
      name: json['name'],
      motherTongue: json['mother_tongue'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      address: json['address'],
    );
  }

  // Override toString for debugging
  @override
  String toString() {
    return '''
UserRegistrationModel(
  name: $name,
  motherTongue: $motherTongue,
  phoneNumber: $phoneNumber,
  email: $email,
  address: $address
)''';
  }

  // Create a copy of the current object with optional new values
  UserRegistrationModel copyWith({
    String? name,
    String? motherTongue,
    String? phoneNumber,
    String? email,
    String? address,
  }) {
    return UserRegistrationModel(
      name: name ?? this.name,
      motherTongue: motherTongue ?? this.motherTongue,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      address: address ?? this.address,
    );
  }
}
