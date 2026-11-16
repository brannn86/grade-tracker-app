import 'package:flutter/material.dart';
import 'package:grade_app/data/session.dart';
import 'package:grade_app/models/course.dart';
import 'package:grade_app/models/semester.dart';

// Listens to the current repository and rebuilds with semesters and courses
class GradeDataBuilder extends StatefulWidget {
  final Widget Function(
          BuildContext context, List<Semester> semesters, List<Course> courses)
      builder;

  const GradeDataBuilder({super.key, required this.builder});

  @override
  State<GradeDataBuilder> createState() => _GradeDataBuilderState();
}

class _GradeDataBuilderState extends State<GradeDataBuilder> {
  late final Stream<List<Semester>> _semesters;
  late final Stream<List<Course>> _courses;

  @override
  void initState() {
    super.initState();
    _semesters = Session.repository.watchSemesters();
    _courses = Session.repository.watchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Semester>>(
      stream: _semesters,
      builder: (context, semesters) {
        return StreamBuilder<List<Course>>(
          stream: _courses,
          builder: (context, courses) {
            if (semesters.hasError || courses.hasError) {
              return const Center(child: Text("Couldn't load your grades"));
            }
            if (!semesters.hasData || !courses.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return widget.builder(context, semesters.data!, courses.data!);
          },
        );
      },
    );
  }
}
