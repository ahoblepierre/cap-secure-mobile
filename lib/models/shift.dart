class Shift {
  final String id;
  final String site;
  final DateTime start;
  final DateTime end;
  final String description;

  Shift({
    required this.id,
    required this.site,
    required this.start,
    required this.end,
    required this.description,
  });

  @override
  String toString() {
    return 'Shift(id: $id, site: $site, start: $start, end: $end, description: $description)';
  }
}
