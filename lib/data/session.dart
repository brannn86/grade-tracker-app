import 'package:firebase_auth/firebase_auth.dart';
import 'package:grade_app/data/firestore_grade_repository.dart';
import 'package:grade_app/data/grade_repository.dart';
import 'package:grade_app/data/local_grade_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Tracks whether the app is running signed in (synced) or in local-only mode
class Session {
  static const _localModeKey = 'local_mode_chosen';

  static final LocalGradeRepository local = LocalGradeRepository();
  static GradeRepository? _repository;

  static GradeRepository get repository {
    final repository = _repository;
    if (repository == null) {
      throw StateError('Session not started');
    }
    return repository;
  }

  static bool get isLocal => _repository is LocalGradeRepository;

  static Future<bool> isLocalModeChosen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_localModeKey) ?? false;
  }

  static Future<void> startLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_localModeKey, true);
    _repository = local;
  }

  static Future<void> startCloud(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localModeKey);
    _repository = FirestoreGradeRepository(user.uid);
  }

  // Local data is kept on the device, so choosing local mode again restores it
  static Future<void> end() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localModeKey);
    _repository = null;
  }
}
