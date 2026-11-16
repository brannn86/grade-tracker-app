import 'package:grade_app/models/course.dart';
import 'package:grade_app/models/semester.dart';

abstract class GradeRepository {
  // Semesters are emitted oldest first
  Stream<List<Semester>> watchSemesters();
  Stream<List<Course>> watchCourses();

  Future<List<Semester>> getSemesters();
  Future<List<Course>> getCourses();

  Future<Semester> addSemester(String name);
  Future<void> updateSemester(Semester semester);
  // Also deletes every course in the semester
  Future<void> deleteSemester(String semesterId);

  // A course with an empty id is created, otherwise it is overwritten
  Future<void> saveCourse(Course course);
  Future<void> deleteCourse(String courseId);

  // Copies semesters and courses in, keeping their ids
  Future<void> importAll(List<Semester> semesters, List<Course> courses);
}
