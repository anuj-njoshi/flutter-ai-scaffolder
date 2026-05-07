class AppConfig {
  final String name;
  final String description;
  final bool auth;
  final bool darkMode;
  final List<String> selectedFeatures;

  AppConfig({
    required this.name,
    required this.description,
    this.auth = true,
    this.darkMode = true,
    this.selectedFeatures = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "auth": auth,
      "darkMode": darkMode,
      "selectedFeatures": selectedFeatures,
    };
  }
}
