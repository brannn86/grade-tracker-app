class Semester {
  final String id;
  final String name;
  final DateTime createdAt;

  const Semester({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  Semester copyWith({String? id, String? name}) {
    return Semester(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  factory Semester.fromMap(String id, Map<String, dynamic> map) {
    return Semester(
      id: id,
      name: map['name'] as String? ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
          (map['createdAt'] as num?)?.toInt() ?? 0),
    );
  }
}
