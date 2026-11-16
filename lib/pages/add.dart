import 'package:flutter/material.dart';
import 'package:grade_app/widgets/course_form.dart';
import 'package:grade_app/widgets/grade_data_builder.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GradeDataBuilder(
          builder: (context, semesters, courses) => CourseForm(
            semesters: semesters,
            onSaved: () => ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Course added"))),
          ),
        ),
      ),
    );
  }
}
