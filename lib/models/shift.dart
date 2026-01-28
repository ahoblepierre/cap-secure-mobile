class Shift {
  Shift({
    required this.id,
    required this.site,
    required this.description,
    required this.start,
    required this.end,
  });

  final String id;
  static const String idKey = "id";

  final String site;
  static const String siteKey = "site";

  final String? description;
  static const String descriptionKey = "description";

  final DateTime start;
  static const String startKey = "start";

  final DateTime end;
  static const String endKey = "end";

  Shift copyWith({
    String? id,
    String? site,
    String? description,
    DateTime? start,
    DateTime? end,
  }) {
    return Shift(
      id: id ?? this.id,
      site: site ?? this.site,
      description: description ?? this.description,
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      id: json["id"]?.toString() ?? '',
      site: json["site"],
      description: json["description"],
      start: DateTime.parse(json["start"]),
      end: DateTime.parse(json["end"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "site": site,
    "description": description,
    "start": start,
    "end": end,
  };

  @override
  String toString() {
    return "$id, $site, $description, $start, $end, ";
  }
}
