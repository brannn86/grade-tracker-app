import 'package:flutter_test/flutter_test.dart';
import 'package:grade_app/data/local_grade_repository.dart';
import 'package:grade_app/models/course.dart';
import 'package:grade_app/models/letter_grade.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Course newCourse(String semesterId, String name) => Course(
        id: '',
        semesterId: semesterId,
        name: name,
        credits: 3,
        grade: LetterGrade.a,
        updatedAt: DateTime.now(),
      );

  test('Data persists across repository instances', () async {
    final repository = LocalGradeRepository();
    final semester = await repository.addSemester('Semester 1');
    await repository.saveCourse(newCourse(semester.id, 'Calculus'));

    final reopened = LocalGradeRepository();
    expect((await reopened.getSemesters()).single.name, 'Semester 1');
    final saved = (await reopened.getCourses()).single;
    expect(saved.name, 'Calculus');
    expect(saved.id, isNotEmpty);
  });

  test('Deleting a semester deletes its courses only', () async {
    final repository = LocalGradeRepository();
    final first = await repository.addSemester('Semester 1');
    final second = await repository.addSemester('Semester 2');
    await repository.saveCourse(newCourse(first.id, 'Calculus'));
    await repository.saveCourse(newCourse(second.id, 'Physics'));

    await repository.deleteSemester(first.id);

    expect((await repository.getSemesters()).single.id, second.id);
    expect((await repository.getCourses()).single.name, 'Physics');
  });

  test('Saving an existing course updates it in place', () async {
    final repository = LocalGradeRepository();
    final semester = await repository.addSemester('Semester 1');
    await repository.saveCourse(newCourse(semester.id, 'Calculus'));
    final saved = (await repository.getCourses()).single;

    await repository.saveCourse(Course(
      id: saved.id,
      semesterId: semester.id,
      name: 'Calculus I',
      credits: 4,
      grade: LetterGrade.bPlus,
      updatedAt: DateTime.now(),
    ));

    final updated = (await repository.getCourses()).single;
    expect(updated.name, 'Calculus I');
    expect(updated.grade, LetterGrade.bPlus);
  });

  test('watchCourses emits current data and later changes', () async {
    final repository = LocalGradeRepository();
    final semester = await repository.addSemester('Semester 1');

    final emissions = repository.watchCourses().take(2).toList();
    await Future<void>.delayed(Duration.zero);
    await repository.saveCourse(newCourse(semester.id, 'Calculus'));

    final result = await emissions;
    expect(result[0], isEmpty);
    expect(result[1].single.name, 'Calculus');
  });

  test('clear removes everything', () async {
    final repository = LocalGradeRepository();
    await repository.addSemester('Semester 1');
    expect(await repository.hasData(), isTrue);
    await repository.clear();
    expect(await repository.hasData(), isFalse);
  });
}
