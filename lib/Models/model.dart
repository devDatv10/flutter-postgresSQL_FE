
// Model class for Patient
class Patient {
  final String id;
  final String name;
  final String address;
  final String city;
  final int age;
  final String gender;

  Patient(
      {required this.id,
      required this.name,
      required this.address,
      required this.city,
      required this.age,
      required this.gender});

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      age: json['age'],
      gender: json['gender']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'city': city,
        'age': age,
        'gender' :gender
      };
}
