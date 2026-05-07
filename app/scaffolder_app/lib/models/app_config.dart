class AppConfig {
  String name;
  String description;
  bool auth;
  bool darkMode;

  AppConfig({
    required this.name,
    required this.description,
    this.auth = true,
    this.darkMode = true,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "auth": auth,
      "darkMode": darkMode,
    };
  }
}