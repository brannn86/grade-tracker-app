enum LetterGrade {
  aPlus('A+', 4.0),
  a('A', 4.0),
  aMinus('A-', 3.7),
  bPlus('B+', 3.3),
  b('B', 3.0),
  bMinus('B-', 2.7),
  cPlus('C+', 2.3),
  c('C', 2.0),
  d('D', 1.0),
  f('F', 0.0);

  const LetterGrade(this.label, this.points);

  final String label;
  final double points;

  static LetterGrade? fromLabel(String? label) {
    for (final grade in values) {
      if (grade.label == label) return grade;
    }
    return null;
  }
}
