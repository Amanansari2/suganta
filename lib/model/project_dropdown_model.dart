class ProjectDropdownItemModel {
  final int id;
  final String name;
  final int type;

  ProjectDropdownItemModel({
    required this.id,
    required this.name,
    required this.type,
  });

  factory ProjectDropdownItemModel.fromJson(Map<String, dynamic> json) {
    return ProjectDropdownItemModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
    );
  }
  @override
  bool operator ==(Object other) =>
  identical(this,other) ||
  other is ProjectDropdownItemModel &&
  runtimeType == other.runtimeType &&
  id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'DropdownItem(id: $id, name: $name, type: $type)';
}





class StatusResponseModel {
  final String message;
  final Map<String, String> data;
  final int status;

  StatusResponseModel({
    required this.message,
    required this.data,
    required this.status,
  });

  factory StatusResponseModel.fromJson(Map<String, dynamic> json) {
    final nestedData = json['data'];
    final actualDataMap = nestedData is Map ? nestedData['data'] as Map : {};

    final parsedData = actualDataMap.map(
          (key, value) => MapEntry(key.toString(), value.toString()),
    );



    return StatusResponseModel(
      message: json['message'] ?? '',
      data: parsedData,
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data,
      'status': status,
    };
  }
}


class AmenitiesResponseModel{
  final String message;
  final Map<String, String> data;
  final int status;

  AmenitiesResponseModel({
    required this.message,
    required this.data,
    required this.status,
});
  factory AmenitiesResponseModel.fromJson(Map<String, dynamic> json){
    final nestedData = json['data'];
    final actualDataAmenities = nestedData is Map ? nestedData['data'] as Map : {};
    final parsedData = actualDataAmenities.map(
        (key, value) => MapEntry(key.toString(), value.toString())
    );

    return AmenitiesResponseModel(
      message: json['message'] ?? '',
      data: parsedData,
      status: json['status']??0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data,
      'status': status,
    };
  }
}