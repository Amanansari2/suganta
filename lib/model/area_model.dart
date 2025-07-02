class Area {
  final String area;

  Area({required this.area});


  factory Area.fromJson(Map<String, dynamic>json){
    return Area(
        area: json["area"].toString().trim(),
    );
  }

}