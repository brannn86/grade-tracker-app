import 'package:flutter/material.dart';
import 'package:grade_app/data/session.dart';
import 'package:grade_app/models/gpa.dart';
import 'package:grade_app/models/semester.dart';
import 'package:grade_app/widgets/grade_data_builder.dart';
import 'package:grade_app/widgets/semester_name_dialog.dart';

class SemestersPage extends StatelessWidget {
  const SemestersPage({super.key});

  Future<void> _add(BuildContext context) async {
    final name = await showSemesterNameDialog(context);
    if (name != null) await Session.repository.addSemester(name);
  }

  Future<void> _rename(BuildContext context, Semester semester) async {
    final name =
        await showSemesterNameDialog(context, initialName: semester.name);
    if (name != null) {
      await Session.repository.updateSemester(semester.copyWith(name: name));
    }
  }

  Future<void> _delete(
      BuildContext context, Semester semester, int courseCount) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete ${semester.name}?"),
        content: Text(courseCount == 0
            ? "This semester has no courses."
            : "This also deletes its $courseCount course(s). "
                "This can't be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await Session.repository.deleteSemester(semester.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Semesters")),
      floatingActionButton: FloatingActionButton(
        tooltip: "New semester",
        onPressed: () => _add(context),
        child: const Icon(Icons.add),
      ),
      body: GradeDataBuilder(
        builder: (context, semesters, courses) {
          if (semesters.isEmpty) {
            return const Center(child: Text("No semesters yet"));
          }
          return ListView(
            children: [
              for (final semester in semesters.reversed)
                Builder(builder: (context) {
                  final semesterCourses =
                      courses.where((c) => c.semesterId == semester.id);
                  return ListTile(
                    title: Text(semester.name),
                    subtitle: Text("${semesterCourses.length} courses · "
                        "GPA ${formatGpa(gpaOf(semesterCourses))}"),
                    onTap: () => _rename(context, semester),
                    trailing: IconButton(
                      tooltip: "Delete",
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () =>
                          _delete(context, semester, semesterCourses.length),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}
