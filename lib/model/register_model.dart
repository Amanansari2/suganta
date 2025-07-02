class RegisterModel{
  final int id;
  final int role;
  final String name;
  final String email;
  final String phone;

  final String createdAt;
  final String updatedAt;

  RegisterModel({
  required this.id,
  required this.name,
  required this.email,
  required this.phone,
  required this.role,
  required this.createdAt,
  required this.updatedAt
});


  factory RegisterModel.fromJson(Map<String, dynamic>json){
    return RegisterModel(
      id: json["id"] != null ? json["id"] as int : 0,
      role: json["role"] != null ? json["role"] as int : 0,
      name: json["name"] ?? "Unknown",
      email: json["email"] ?? "Unknown",
      phone: json["phone"] != null ? json["phone"].toString() : "Unknown",
      createdAt: json["created_at"] != null ? json["created_at"].toString() : "",
      updatedAt: json["updated_at"] != null ? json["updated_at"].toString() : "",

    );
  }

  Map<String,dynamic> toJson(){
    return {
      "id": id,
      "role": role,
      "name": name,
      "email": email,
      "phone": phone,
      "created_at": createdAt,
      "updated_at": updatedAt,

    };
  }
}