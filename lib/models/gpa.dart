import 'package:grade_app/models/course.dart';

Iterable<Course> _graded(Iterable<Course> courses) =>
    courses.where((c) => c.grade != null && c.credits > 0);

// Credit-weighted GPA, or null when nothing has been graded yet
double? gpaOf(Iterable<Course> courses) {
  final graded = _graded(courses);
  final credits = gradedCredits(graded);
  if (credits == 0) return null;

  final points = graded.fold<double>(
      0, (sum, course) => sum + course.grade!.points * course.credits);
  return points / credits;
}

double gradedCredits(Iterable<Course> courses) =>
    _graded(courses).fold<double>(0, (sum, course) => sum + course.credits);

String formatGpa(double? gpa) => gpa == null ? '-' : gpa.toStringAsFixed(2);

String formatCredits(double credits) => credits == credits.roundToDouble()
    ? credits.toInt().toString()
    : credits.toString();
