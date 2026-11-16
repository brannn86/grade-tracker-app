import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grade_app/data/session.dart';
import 'package:grade_app/models/course.dart';
import 'package:grade_app/models/gpa.dart';
import 'package:grade_app/models/semester.dart';
import 'package:grade_app/widgets/grade_data_builder.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GradeDataBuilder(
          builder: (context, semesters, courses) =>
              _HomeContent(semesters: semesters, courses: courses),
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final List<Semester> semesters;
  final List<Course> courses;

  const _HomeContent({required this.semesters, required this.courses});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final semesterNames = {for (final s in semesters) s.id: s.name};
    final current = semesters.isEmpty ? null : semesters.last;
    final currentCourses =
        courses.where((c) => c.semesterId == current?.id).toList();
    final recent = [...courses]
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _ModeLabel(),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text("Cumulative GPA", style: textTheme.titleMedium),
                Text(formatGpa(gpaOf(courses)), style: textTheme.displayMedium),
                Text(
                    "${formatCredits(gradedCredits(courses))} credits graded · "
                    "${courses.length} courses"),
              ],
            ),
          ),
        ),
        if (current != null)
          Card(
            child: ListTile(
              title: Text(current.name),
              subtitle: Text(
                  "${formatCredits(gradedCredits(currentCourses))} credits graded"
                  " · ${currentCourses.length} courses"),
              trailing: Text(formatGpa(gpaOf(currentCourses)),
                  style: textTheme.headlineSmall),
            ),
          ),
        const SizedBox(height: 16),
        if (courses.isEmpty)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "No courses yet. Tap Add to record your first grade.",
              textAlign: TextAlign.center,
            ),
          )
        else ...[
          Text("Recently updated", style: textTheme.titleMedium),
          for (final course in recent.take(5))
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(course.name),
              subtitle: Text(semesterNames[course.semesterId] ?? ''),
              trailing: Text(course.grade?.label ?? "-",
                  style: textTheme.titleLarge),
            ),
        ],
      ],
    );
  }
}

class _ModeLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final text = Session.isLocal
        ? "Saved on this device only"
        : "Synced · ${FirebaseAuth.instance.currentUser?.email ?? ''}";
    return Row(
      children: [
        Icon(Session.isLocal ? Icons.phone_android : Icons.cloud_done_outlined,
            size: 18),
        const SizedBox(width: 6),
        Expanded(child: Text(text, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}
