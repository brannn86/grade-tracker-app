import 'package:flutter/material.dart';
import 'package:grade_app/data/session.dart';
import 'package:grade_app/models/course.dart';
import 'package:grade_app/models/gpa.dart';
import 'package:grade_app/models/letter_grade.dart';
import 'package:grade_app/models/semester.dart';
import 'package:grade_app/widgets/semester_name_dialog.dart';

// Add or edit a course. Pass [course] to edit an existing one.
class CourseForm extends StatefulWidget {
  final Course? course;
  final List<Semester> semesters;
  final VoidCallback onSaved;

  const CourseForm({
    super.key,
    this.course,
    required this.semesters,
    required this.onSaved,
  });

  @override
  State<CourseForm> createState() => _CourseFormState();
}

class _CourseFormState extends State<CourseForm> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.course?.name);
  late final _creditsController = TextEditingController(
      text: widget.course == null ? null : formatCredits(widget.course!.credits));
  String? _semesterId;
  LetterGrade? _grade;

  @override
  void initState() {
    super.initState();
    _semesterId = widget.course?.semesterId ??
        (widget.semesters.isEmpty ? null : widget.semesters.last.id);
    _grade = widget.course?.grade;
  }

  @override
  void didUpdateWidget(CourseForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Fall back to the latest semester if the selected one was deleted
    if (!widget.semesters.any((s) => s.id == _semesterId)) {
      _semesterId = widget.semesters.isEmpty ? null : widget.semesters.last.id;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  Future<void> _addSemester() async {
    final name = await showSemesterNameDialog(context);
    if (name == null) return;
    final semester = await Session.repository.addSemester(name);
    setState(() => _semesterId = semester.id);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    await Session.repository.saveCourse(Course(
      id: widget.course?.id ?? '',
      semesterId: _semesterId!,
      name: _nameController.text.trim(),
      credits: double.parse(_creditsController.text.trim()),
      grade: _grade,
      updatedAt: DateTime.now(),
    ));

    if (widget.course == null) {
      _nameController.clear();
      _creditsController.clear();
      setState(() => _grade = null);
    }
    widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    final semesterExists = widget.semesters.any((s) => s.id == _semesterId);

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: semesterExists ? _semesterId : null,
                  // Rebuild the field when the selected semester changes
                  key: ValueKey(_semesterId),
                  decoration: const InputDecoration(labelText: "Semester"),
                  items: [
                    for (final semester in widget.semesters.reversed)
                      DropdownMenuItem(
                          value: semester.id, child: Text(semester.name)),
                  ],
                  onChanged: (id) => setState(() => _semesterId = id),
                  validator: (id) =>
                      id == null ? "Add a semester first" : null,
                ),
              ),
              IconButton(
                tooltip: "New semester",
                icon: const Icon(Icons.add),
                onPressed: _addSemester,
              ),
            ],
          ),
          TextFormField(
            controller: _nameController,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(labelText: "Course name"),
            validator: (value) => (value == null || value.trim().isEmpty)
                ? "Enter the course name"
                : null,
          ),
          TextFormField(
            controller: _creditsController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: "Credits"),
            validator: (value) {
              final credits = double.tryParse(value?.trim() ?? '');
              if (credits == null || credits <= 0) {
                return "Enter a number greater than 0";
              }
              return null;
            },
          ),
          DropdownButtonFormField<LetterGrade?>(
            initialValue: _grade,
            key: ValueKey(_grade),
            decoration: const InputDecoration(labelText: "Final grade"),
            items: [
              const DropdownMenuItem(value: null, child: Text("Not graded yet")),
              for (final grade in LetterGrade.values)
                DropdownMenuItem(
                  value: grade,
                  child: Text(
                      "${grade.label}  (${grade.points.toStringAsFixed(1)})"),
                ),
            ],
            onChanged: (grade) => setState(() => _grade = grade),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 40),
                backgroundColor: Colors.deepOrange),
            onPressed: _save,
            child: Text(widget.course == null ? "Add course" : "Save changes"),
          ),
        ],
      ),
    );
  }
}
