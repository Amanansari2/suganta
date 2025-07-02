class AppState {
  final int id;
  final String name;

  AppState({required this.id, required this.name});

  factory AppState.fromJson(Map<String, dynamic> json) {
    return AppState(
        id: json["id"],
        name: json["name"]);
  }
}
