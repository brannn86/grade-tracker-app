import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:grade_app/data/grade_repository.dart';
import 'package:grade_app/models/course.dart';
import 'package:grade_app/models/semester.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Keeps everything on the device as a single JSON blob in shared_preferences
class LocalGradeRepository implements GradeRepository {
  static const _storageKey = 'local_grade_data';

  final List<Semester> _semesters = [];
  final List<Course> _courses = [];
  final _semesterChanges = StreamController<List<Semester>>.broadcast();
  final _courseChanges = StreamController<List<Course>>.broadcast();
  final _random = Random();
  Future<void>? _loading;

  Future<void> _load() => _loading ??= _readFromStorage();

  Future<void> _readFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null) return;

    final data = jsonDecode(raw) as Map<String, dynamic>;
    for (final item in data['semesters'] as List? ?? []) {
      final map = Map<String, dynamic>.from(item as Map);
      _semesters.add(Semester.fromMap(map['id'] as String, map));
    }
    for (final item in data['courses'] as List? ?? []) {
      final map = Map<String, dynamic>.from(item as Map);
      _courses.add(Course.fromMap(map['id'] as String, map));
    }
  }

  Future<void> _save() async {
    _semesters.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode({
        'semesters': [
          for (final s in _semesters) {'id': s.id, ...s.toMap()}
        ],
        'courses': [
          for (final c in _courses) {'id': c.id, ...c.toMap()}
        ],
      }),
    );
    _semesterChanges.add(List.unmodifiable(_semesters));
    _courseChanges.add(List.unmodifiable(_courses));
  }

  String _newId() =>
      '${DateTime.now().microsecondsSinceEpoch}${_random.nextInt(1 << 16)}';

  Future<bool> hasData() async {
    await _load();
    return _semesters.isNotEmpty || _courses.isNotEmpty;
  }

  Future<void> clear() async {
    await _load();
    _semesters.clear();
    _courses.clear();
    await _save();
  }

  @override
  Stream<List<Semester>> watchSemesters() async* {
    await _load();
    yield List.unmodifiable(_semesters);
    yield* _semesterChanges.stream;
  }

  @override
  Stream<List<Course>> watchCourses() async* {
    await _load();
    yield List.unmodifiable(_courses);
    yield* _courseChanges.stream;
  }

  @override
  Future<List<Semester>> getSemesters() async {
    await _load();
    return List.unmodifiable(_semesters);
  }

  @override
  Future<List<Course>> getCourses() async {
    await _load();
    return List.unmodifiable(_courses);
  }

  @override
  Future<Semester> addSemester(String name) async {
    await _load();
    final semester =
        Semester(id: _newId(), name: name, createdAt: DateTime.now());
    _semesters.add(semester);
    await _save();
    return semester;
  }

  @override
  Future<void> updateSemester(Semester semester) async {
    await _load();
    final index = _semesters.indexWhere((s) => s.id == semester.id);
    if (index == -1) return;
    _semesters[index] = semester;
    await _save();
  }

  @override
  Future<void> deleteSemester(String semesterId) async {
    await _load();
    _semesters.removeWhere((s) => s.id == semesterId);
    _courses.removeWhere((c) => c.semesterId == semesterId);
    await _save();
  }

  @override
  Future<void> saveCourse(Course course) async {
    await _load();
    if (course.id.isEmpty) {
      _courses.add(course.copyWith(id: _newId()));
    } else {
      final index = _courses.indexWhere((c) => c.id == course.id);
      if (index == -1) {
        _courses.add(course);
      } else {
        _courses[index] = course;
      }
    }
    await _save();
  }

  @override
  Future<void> deleteCourse(String courseId) async {
    await _load();
    _courses.removeWhere((c) => c.id == courseId);
    await _save();
  }

  @override
  Future<void> importAll(List<Semester> semesters, List<Course> courses) async {
    await _load();
    _semesters.addAll(semesters);
    _courses.addAll(courses);
    await _save();
  }
}
