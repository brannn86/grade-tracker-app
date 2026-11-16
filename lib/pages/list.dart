import 'package:flutter/material.dart';
import 'package:grade_app/data/session.dart';
import 'package:grade_app/models/course.dart';
import 'package:grade_app/models/gpa.dart';
import 'package:grade_app/pages/edit_course.dart';
import 'package:grade_app/widgets/grade_data_builder.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  void _delete(BuildContext context, Course course) {
    Session.repository.deleteCourse(course.id);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text("Deleted ${course.name}"),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () => Session.repository.saveCourse(course),
        ),
      ));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: GradeDataBuilder(
          builder: (context, semesters, courses) {
            if (courses.isEmpty) {
              return const Center(child: Text("No courses yet"));
            }
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                // Newest semester first
                for (final semester in semesters.reversed) ...() {
                  final semesterCourses = courses
                      .where((c) => c.semesterId == semester.id)
                      .toList()
                    ..sort((a, b) => a.name.compareTo(b.name));
                  return [
                    ListTile(
                      title: Text(semester.name, style: textTheme.titleMedium),
                      subtitle: Text(
                          "${formatCredits(gradedCredits(semesterCourses))} "
                          "credits graded"),
                      trailing: Text("GPA ${formatGpa(gpaOf(semesterCourses))}",
                          style: textTheme.titleMedium),
                    ),
                    if (semesterCourses.isEmpty)
                      const ListTile(dense: true, title: Text("No courses")),
                    for (final course in semesterCourses)
                      Dismissible(
                        key: ValueKey(course.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => _delete(context, course),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 32),
                          title: Text(course.name),
                          subtitle:
                              Text("${formatCredits(course.credits)} credits"),
                          trailing: Text(course.grade?.label ?? "-",
                              style: textTheme.titleLarge),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => EditCoursePage(course: course)),
                          ),
                        ),
                      ),
                    const Divider(),
                  ];
                }(),
              ],
            );
          },
        ),
      ),
    );
  }
}
