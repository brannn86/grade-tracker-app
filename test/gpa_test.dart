import 'package:flutter_test/flutter_test.dart';
import 'package:grade_app/models/course.dart';
import 'package:grade_app/models/gpa.dart';
import 'package:grade_app/models/letter_grade.dart';

Course course(double credits, LetterGrade? grade) => Course(
      id: '',
      semesterId: 's1',
      name: 'Course',
      credits: credits,
      grade: grade,
      updatedAt: DateTime(2026),
    );

void main() {
  test('GPA is weighted by credits', () {
    // (4.0 * 3 + 3.0 * 2) / 5 = 3.6
    final gpa = gpaOf([course(3, LetterGrade.a), course(2, LetterGrade.b)]);
    expect(gpa, closeTo(3.6, 1e-9));
  });

  test('Ungraded courses are left out of GPA', () {
    final gpa = gpaOf([course(3, LetterGrade.bPlus), course(4, null)]);
    expect(gpa, closeTo(3.3, 1e-9));
    expect(gradedCredits([course(3, LetterGrade.bPlus), course(4, null)]), 3);
  });

  test('GPA is null when nothing is graded', () {
    expect(gpaOf([]), isNull);
    expect(gpaOf([course(3, null)]), isNull);
    expect(formatGpa(null), '-');
  });

  test('A+ counts as 4.0 and F as 0.0', () {
    expect(LetterGrade.aPlus.points, 4.0);
    expect(LetterGrade.f.points, 0.0);
    expect(LetterGrade.fromLabel('B-'), LetterGrade.bMinus);
    expect(LetterGrade.fromLabel('E'), isNull);
  });

  test('Course survives a round trip through a map', () {
    final original = course(2.5, LetterGrade.cPlus);
    final restored = Course.fromMap('id1', original.toMap());
    expect(restored.credits, 2.5);
    expect(restored.grade, LetterGrade.cPlus);
    expect(restored.semesterId, 's1');
  });
}
