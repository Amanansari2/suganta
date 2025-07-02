const Map<int, String> roleTitles = {
  1: "Admin",
  2: "Vendor | Employee",
  3: "App User",
  4: "Agent Team",
  5: "Client",
  6: "Agent",
  7: "Builder",
  8: "Builder Team",
  9: "User | Owner",
  10: "Project/Developer",
  11: "HR",
  12: "Architecture",
  13: "Interior Designer",
  14: "Painter",
  15: "Sale Agreement",
  16: "Rent Agreement",
  17: "Home Interior",
  18: "Vastu Sastra",
  19: "Pack N Go",
};



class LoginModel {
  final int id;
  final int role;
  final String name;
  final String? image;
  final String? dob;
  final String? gender;
  final String email;
  final String phone;
  final int? bankId;
  final String? logo;
  final String? emailVerifiedAt;
  final int status;
  final String createdAt;
  final String updatedAt;
  final String? userId;
  final String token;
  final String? alternateMno;
  final String? dealsOn;
  final String? officeName;
  final String? aboutUs;
  final String? address;
  final String? country;
  final String? area;
  final String? pinCode;
  final int? stateId;
  final int? cityId;


  LoginModel({
       this.country,
       this.area,
       this.pinCode,
      this.stateId,
       this.cityId,
    required this.id,
    required this.role,
    required this.name,
    this.image,
    this.dob,
    this.gender,
    required this.email,
    required this.phone,
    this.bankId,
    this.logo,
    this.emailVerifiedAt,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.userId,
    required this.token,
    this.alternateMno,
    this.dealsOn,
    this.officeName,
    this.aboutUs,
    this.address,

  });


  String get roleName => roleTitles[role] ?? "Unknown Role";

  factory LoginModel.fromJson(Map<String, dynamic> json) {



    final userData = json.containsKey("data") && json["data"] is Map<String, dynamic>
        ? json["data"]
        : json;

    return LoginModel(
      id: userData["id"] ?? 0,
      role: userData["role"] ?? 0,
      name: userData["name"] ?? "unknown",
      image: userData["image"],
      dob: userData["dob"]?.toString(),
      gender: userData["gender"]?.toString(),
      email: userData["email"] ?? "",
      phone: userData["phone"].toString(),
      bankId: userData["bank_id"],
      logo: userData["logo"]?.toString(),
      emailVerifiedAt: userData["email_verified_at"],
      status: userData["status"] ?? 1,
      createdAt: userData["created_at"] ?? "",
      updatedAt: userData["updated_at"] ?? "",
      userId: userData["user_id"]?.toString(),
      token: json["token"] ?? "",
      alternateMno: userData["alternate_mno"],
      dealsOn: userData["dealsOn"],
      officeName: userData["office_name"],
      aboutUs: userData["about_us"],
      address: userData["address"],
      country: userData["country"]?.toString() ?? '',
      stateId: userData["state_id"]??0,
      cityId: userData["city_id"]??0,
      area: userData["area"]?.toString() ??'',
      pinCode: userData["pincode"]?.toString(),

    );
  }




  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "role": role,
      "name": name,
      "image": image,
      "dob": dob,
      "gender": gender,
      "email": email,
      "phone": phone,
      "bank_id": bankId,
      "logo": logo,
      "email_verified_at": emailVerifiedAt,
      "status": status,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "user_id": userId,
      "token": token,
      "alternate_mno": alternateMno,
      "dealsOn": dealsOn,
      "office_name": officeName,
      "about_us": aboutUs,
      "address": address,
      "country": country,
      "state_id": stateId,
      "city_id": cityId,
      "area": area,
      "pincode": pinCode,
    };
  }
}
