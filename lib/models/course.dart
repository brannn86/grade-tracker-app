import 'package:grade_app/models/letter_grade.dart';

class Course {
  final String id;
  final String semesterId;
  final String name;
  final double credits;
  // null means the course hasn't been graded yet and is left out of GPA
  final LetterGrade? grade;
  final DateTime updatedAt;

  const Course({
    required this.id,
    required this.semesterId,
    required this.name,
    required this.credits,
    required this.grade,
    required this.updatedAt,
  });

  Course copyWith({String? id}) {
    return Course(
      id: id ?? this.id,
      semesterId: semesterId,
      name: name,
      credits: credits,
      grade: grade,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'semesterId': semesterId,
        'name': name,
        'credits': credits,
        'grade': grade?.label,
        'updatedAt': updatedAt.millisecondsSinceEpoch,
      };

  factory Course.fromMap(String id, Map<String, dynamic> map) {
    return Course(
      id: id,
      semesterId: map['semesterId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      credits: (map['credits'] as num?)?.toDouble() ?? 0,
      grade: LetterGrade.fromLabel(map['grade'] as String?),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
          (map['updatedAt'] as num?)?.toInt() ?? 0),
    );
  }
}
