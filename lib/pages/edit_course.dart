import 'package:flutter/material.dart';
import 'package:grade_app/models/course.dart';
import 'package:grade_app/widgets/course_form.dart';
import 'package:grade_app/widgets/grade_data_builder.dart';

class EditCoursePage extends StatelessWidget {
  final Course course;

  const EditCoursePage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit course")),
      body: GradeDataBuilder(
        builder: (context, semesters, courses) => CourseForm(
          course: course,
          semesters: semesters,
          onSaved: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
