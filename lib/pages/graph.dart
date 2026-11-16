import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:grade_app/models/course.dart';
import 'package:grade_app/models/gpa.dart';
import 'package:grade_app/models/letter_grade.dart';
import 'package:grade_app/models/semester.dart';
import 'package:grade_app/widgets/grade_data_builder.dart';

class GraphPage extends StatelessWidget {
  const GraphPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GradeDataBuilder(
          builder: (context, semesters, courses) {
            if (gpaOf(courses) == null) {
              return const Center(
                  child: Text("Add a graded course to see your charts"));
            }
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _ChartCard(
                  title: "GPA per semester",
                  child: _GpaTrendChart(semesters: semesters, courses: courses),
                ),
                _ChartCard(
                  title: "Grade distribution",
                  child: _GradeDistributionChart(courses: courses),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _ChartCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            SizedBox(height: 220, child: child),
          ],
        ),
      ),
    );
  }
}

class _GpaTrendChart extends StatelessWidget {
  final List<Semester> semesters;
  final List<Course> courses;

  const _GpaTrendChart({required this.semesters, required this.courses});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final graded = semesters
        .where((s) => gpaOf(courses.where((c) => c.semesterId == s.id)) != null)
        .toList();

    final semesterSpots = <FlSpot>[];
    final cumulativeSpots = <FlSpot>[];
    final soFar = <Course>[];
    for (var i = 0; i < graded.length; i++) {
      final semesterCourses =
          courses.where((c) => c.semesterId == graded[i].id).toList();
      soFar.addAll(semesterCourses);
      semesterSpots.add(FlSpot(i.toDouble(), gpaOf(semesterCourses)!));
      cumulativeSpots.add(FlSpot(i.toDouble(), gpaOf(soFar)!));
    }

    return Column(
      children: [
        Expanded(
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: 4,
              minX: 0,
              maxX: max(graded.length - 1, 1).toDouble(),
              gridData: const FlGridData(horizontalInterval: 1),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true, interval: 1, reservedSize: 28),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (value != index || index >= graded.length) {
                        return const SizedBox.shrink();
                      }
                      final name = graded[index].name;
                      return SideTitleWidget(
                        meta: meta,
                        child: Text(
                          name.length > 8 ? '${name.substring(0, 8)}…' : name,
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: semesterSpots,
                  color: colors.primary,
                  barWidth: 3,
                ),
                LineChartBarData(
                  spots: cumulativeSpots,
                  color: colors.tertiary,
                  barWidth: 2,
                  dashArray: [6, 4],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Legend(color: colors.primary, label: "Semester GPA"),
            const SizedBox(width: 16),
            _Legend(color: colors.tertiary, label: "Cumulative GPA"),
          ],
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 3, color: color),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _GradeDistributionChart extends StatelessWidget {
  final List<Course> courses;

  const _GradeDistributionChart({required this.courses});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final counts = {
      for (final grade in LetterGrade.values)
        grade: courses.where((c) => c.grade == grade).length,
    };
    final maxCount = counts.values.reduce(max);

    return BarChart(
      BarChartData(
        maxY: maxCount + 1,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          leftTitles: const AxisTitles(
            sideTitles:
                SideTitles(showTitles: true, interval: 1, reservedSize: 28),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => SideTitleWidget(
                meta: meta,
                child: Text(LetterGrade.values[value.toInt()].label,
                    style: const TextStyle(fontSize: 11)),
              ),
            ),
          ),
        ),
        barGroups: [
          for (final grade in LetterGrade.values)
            BarChartGroupData(
              x: grade.index,
              barRods: [
                BarChartRodData(
                  toY: counts[grade]!.toDouble(),
                  color: color,
                  width: 14,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
