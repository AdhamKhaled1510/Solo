import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/app_provider.dart';
import '../../models/focus_session.dart';

import '../../models/focus_session.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, app, _) {
        final user = app.user;
        final sessions = app.sessions;
        final weeklyData = _getWeeklyData(sessions);
        final monthlyData = _getMonthlyData(sessions);

        return Scaffold(
          appBar: AppBar(title: const Text('📊 الإحصائيات')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Weekly focus chart
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('تركيز هذا الأسبوع', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 150,
                          child: weeklyData.every((d) => d == 0)
                            ? Center(child: Text('لا توجد بيانات', style: TextStyle(color: Colors.grey)))
                            : BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  maxY: weeklyData.reduce((a, b) => a > b ? a : b) * 1.3,
                                  barTouchData: BarTouchData(enabled: false),
                                  titlesData: FlTitlesData(
                                    show: true,
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          const days = ['ح', 'ن', 'ث', 'ر', 'خ', 'ج', 'س'];
                                          if (value.toInt() >= 0 && value.toInt() < 7) {
                                            return Text(days[value.toInt()], style: const TextStyle(fontSize: 10));
                                          }
                                          return const Text('');
                                        },
                                      ),
                                    ),
                                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  ),
                                  gridData: FlGridData(show: false),
                                  borderData: FlBorderData(show: false),
                                  barGroups: weeklyData.asMap().entries.map((e) => BarChartGroupData(
                                    x: e.key,
                                    barRods: [BarChartRodData(
                                      toY: e.value.toDouble(),
                                      color: Colors.green,
                                      width: 16,
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                    )],
                                  )).toList(),
                                ),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Monthly focus chart
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('تركيز هذا الشهر', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 150,
                          child: monthlyData.every((d) => d == 0)
                            ? Center(child: Text('لا توجد بيانات', style: TextStyle(color: Colors.grey)))
                            : BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  maxY: monthlyData.reduce((a, b) => a > b ? a : b) * 1.3,
                                  barTouchData: BarTouchData(enabled: false),
                                  titlesData: FlTitlesData(
                                    show: true,
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        interval: 4,
                                        getTitlesWidget: (value, meta) {
                                          if (value.toInt() >= 0 && value.toInt() < monthlyData.length) {
                                            return Text('${value.toInt() + 1}', style: const TextStyle(fontSize: 9));
                                          }
                                          return const Text('');
                                        },
                                      ),
                                    ),
                                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  ),
                                  gridData: FlGridData(show: false),
                                  borderData: FlBorderData(show: false),
                                  barGroups: monthlyData.asMap().entries.map((e) => BarChartGroupData(
                                    x: e.key,
                                    barRods: [BarChartRodData(
                                      toY: e.value.toDouble(),
                                      color: Colors.blue,
                                      width: 8,
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                                    )],
                                  )).toList(),
                                ),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

              // Tag breakdown
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('توزيع النشاطات', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        _buildPieChart(sessions),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Quick stats in a grid
                Row(
                  children: [
                    Expanded(child: _MiniStatCard(label: '⏱ إجمالي', value: _formatMinutes(user.totalFocusMinutes), color: Colors.blue)),
                    const SizedBox(width: 8),
                    Expanded(child: _MiniStatCard(label: '🌳 أشجار', value: '${user.totalTreesPlanted}', color: Colors.green)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _MiniStatCard(label: '🕌 صلوات', value: '${user.totalPrayersOnTime}', color: Colors.brown)),
                    const SizedBox(width: 8),
                    Expanded(child: _MiniStatCard(label: '📋 مهام', value: '${user.completedTasks}', color: Colors.indigo)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _MiniStatCard(label: '🔥 Streak', value: '${user.streakDays} يوم', color: Colors.orange)),
                    const SizedBox(width: 8),
                    Expanded(child: _MiniStatCard(label: '🎯 مهام', value: '${user.completedQuests}', color: Colors.purple)),
                  ],
                ),
                const SizedBox(height: 16),

                // Recent sessions
                Text('آخر الجلسات', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (sessions.isEmpty)
                  Card(child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(child: Text('لا توجد جلسات بعد', style: TextStyle(color: Colors.grey))),
                  ))
                else
                  ...sessions.reversed.take(10).map((s) => Card(
                    margin: const EdgeInsets.only(bottom: 4),
                    child: ListTile(
                      leading: Icon(s.completed ? Icons.check_circle : Icons.cancel, color: s.completed ? Colors.green : Colors.red),
                      title: Text('${s.durationMinutes} دقيقة', style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('${s.startTime.hour}:${s.startTime.minute.toString().padLeft(2, '0')}'),
                      trailing: Text('${s.durationMinutes ~/ 60}h ${s.durationMinutes % 60}m', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ),
                  )),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPieChart(List<FocusSession> sessions) {
    if (sessions.isEmpty) return Center(child: Text('لا توجد بيانات', style: TextStyle(color: Colors.grey)));

    final tagMinutes = <String, int>{};
    for (final s in sessions) {
      final tag = s.tag.isEmpty ? 'other' : s.tag;
      tagMinutes[tag] = (tagMinutes[tag] ?? 0) + s.durationMinutes;
    }
    final total = tagMinutes.values.fold(0, (a, b) => a + b);
    if (total == 0) return Center(child: Text('لا توجد بيانات', style: TextStyle(color: Colors.grey)));

    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.red, Colors.teal, Colors.pink, Colors.cyan, Colors.amber, Colors.grey];
    final colorMap = <String, Color>{};
    var ci = 0;
    for (final k in tagMinutes.keys) {
      colorMap[k] = colors[ci % colors.length];
      ci++;
    }

    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 30,
              sections: tagMinutes.entries.map((e) => PieChartSectionData(
                value: e.value.toDouble(),
                title: '${(e.value / total * 100).round()}%',
                color: colorMap[e.key],
                radius: 40,
                titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
              )).toList(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 6,
          children: tagMinutes.entries.map((e) {
            final tag = FocusSession.getTagById(e.key);
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 10, height: 10, decoration: BoxDecoration(color: colorMap[e.key], shape: BoxShape.circle)),
                const SizedBox(width: 4),
                Text('${tag.emoji} ${tag.name} ${_formatMinutes(e.value)}', style: const TextStyle(fontSize: 11)),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  List<int> _getWeeklyData(List<FocusSession> sessions) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final data = List.filled(7, 0);
    for (final s in sessions) {
      final diff = s.startTime.difference(startOfWeek).inDays;
      if (diff >= 0 && diff < 7) {
        data[diff] += s.durationMinutes;
      }
    }
    return data;
  }

  List<int> _getMonthlyData(List<FocusSession> sessions) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final data = List.filled(daysInMonth, 0);
    for (final s in sessions) {
      if (s.startTime.year == now.year && s.startTime.month == now.month) {
        data[s.startTime.day - 1] += s.durationMinutes;
      }
    }
    return data;
  }

  String _formatMinutes(int mins) {
    final hours = mins ~/ 60;
    final minutes = mins % 60;
    return '${hours}h ${minutes}m';
  }
}

class _MiniStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MiniStatCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
