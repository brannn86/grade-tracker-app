import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grade_app/data/grade_repository.dart';
import 'package:grade_app/models/course.dart';
import 'package:grade_app/models/semester.dart';

// Stores data under users/{uid}/semesters and users/{uid}/courses
class FirestoreGradeRepository implements GradeRepository {
  FirestoreGradeRepository(String uid)
      : _user = FirebaseFirestore.instance.collection('users').doc(uid);

  final DocumentReference<Map<String, dynamic>> _user;

  CollectionReference<Map<String, dynamic>> get _semesters =>
      _user.collection('semesters');
  CollectionReference<Map<String, dynamic>> get _courses =>
      _user.collection('courses');

  // Firestore applies writes to its local cache immediately, but the returned
  // future only completes once the server confirms, which never happens while
  // offline. Don't block the UI on it, just log failures.
  void _write(Future<void> write) {
    write.catchError((Object e) => log('Firestore write failed: $e'));
  }

  @override
  Stream<List<Semester>> watchSemesters() => _semesters
      .orderBy('createdAt')
      .snapshots()
      .map((snapshot) => [
            for (final doc in snapshot.docs) Semester.fromMap(doc.id, doc.data())
          ]);

  @override
  Stream<List<Course>> watchCourses() => _courses.snapshots().map((snapshot) =>
      [for (final doc in snapshot.docs) Course.fromMap(doc.id, doc.data())]);

  @override
  Future<List<Semester>> getSemesters() async {
    final snapshot = await _semesters.orderBy('createdAt').get();
    return [
      for (final doc in snapshot.docs) Semester.fromMap(doc.id, doc.data())
    ];
  }

  @override
  Future<List<Course>> getCourses() async {
    final snapshot = await _courses.get();
    return [for (final doc in snapshot.docs) Course.fromMap(doc.id, doc.data())];
  }

  @override
  Future<Semester> addSemester(String name) async {
    final doc = _semesters.doc();
    final semester = Semester(id: doc.id, name: name, createdAt: DateTime.now());
    _write(doc.set(semester.toMap()));
    return semester;
  }

  @override
  Future<void> updateSemester(Semester semester) async {
    _write(_semesters.doc(semester.id).set(semester.toMap()));
  }

  @override
  Future<void> deleteSemester(String semesterId) async {
    final courses =
        await _courses.where('semesterId', isEqualTo: semesterId).get();
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in courses.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(_semesters.doc(semesterId));
    _write(batch.commit());
  }

  @override
  Future<void> saveCourse(Course course) async {
    final doc = course.id.isEmpty ? _courses.doc() : _courses.doc(course.id);
    _write(doc.set(course.toMap()));
  }

  @override
  Future<void> deleteCourse(String courseId) async {
    _write(_courses.doc(courseId).delete());
  }

  @override
  Future<void> importAll(List<Semester> semesters, List<Course> courses) async {
    final batch = FirebaseFirestore.instance.batch();
    for (final semester in semesters) {
      batch.set(_semesters.doc(semester.id), semester.toMap());
    }
    for (final course in courses) {
      batch.set(_courses.doc(course.id), course.toMap());
    }
    // Wait here so local data is only cleared after the upload succeeded
    await batch.commit();
  }
}
