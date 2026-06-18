import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sawaliyatrader/core/dashboard/models/dashboard_stats.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/screens/dashboard/widgets/dashboard_chart_card.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';

class CustomerStatusPieChart extends StatelessWidget {
  const CustomerStatusPieChart({
    required this.segments,
    super.key,
  });

  final List<ChartSegment> segments;

  @override
  Widget build(BuildContext context) {
    final total = segments.fold<double>(0, (sum, item) => sum + item.value);

    return DashboardChartCard(
      title: 'Customers by Status',
      subtitle: 'Application pipeline breakdown',
      child: segments.isEmpty || total == 0
          ? const _ChartEmptyState(message: 'No customer data yet')
          : Column(
              children: [
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 42,
                      sections: segments
                          .map(
                            (segment) => PieChartSectionData(
                              value: segment.value,
                              title: '${((segment.value / total) * 100).round()}%',
                              color: Color(segment.colorArgb),
                              radius: 56,
                              titleStyle: AppTextStyles.label(context).copyWith(
                                fontSize: 11,
                                color: Colors.white,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _ChartLegend(segments: segments),
              ],
            ),
    );
  }
}

class EmiStatusBarChart extends StatelessWidget {
  const EmiStatusBarChart({
    required this.segments,
    super.key,
  });

  final List<ChartSegment> segments;

  @override
  Widget build(BuildContext context) {
    final maxY = segments.fold<double>(
      0,
      (max, item) => item.value > max ? item.value : max,
    );

    return DashboardChartCard(
      title: 'EMI Status',
      subtitle: 'Installment collection overview',
      child: segments.isEmpty
          ? const _ChartEmptyState(message: 'No EMI data yet')
          : SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  maxY: maxY <= 0 ? 10 : maxY * 1.2,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxY <= 0 ? 2 : (maxY / 4).ceilToDouble(),
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: AppColors.progressTrack,
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(),
                    rightTitles: const AxisTitles(),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: AppTextStyles.subtitle(context).copyWith(fontSize: 10),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= segments.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              segments[index].label,
                              style: AppTextStyles.subtitle(context).copyWith(fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(
                    segments.length,
                    (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: segments[index].value,
                          color: Color(segments[index].colorArgb),
                          width: 22,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class CollectionTrendChart extends StatelessWidget {
  const CollectionTrendChart({
    required this.points,
    super.key,
  });

  final List<TrendPoint> points;

  @override
  Widget build(BuildContext context) {
    final maxY = points.fold<double>(
      0,
      (max, item) => item.value > max ? item.value : max,
    );

    return DashboardChartCard(
      title: 'EMI Collection Trend',
      subtitle: 'Monthly collections (last 6 months)',
      child: points.isEmpty
          ? const _ChartEmptyState(message: 'No collection history yet')
          : SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: maxY <= 0 ? 1000 : maxY * 1.15,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: AppColors.progressTrack,
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(),
                    rightTitles: const AxisTitles(),
                    leftTitles: const AxisTitles(),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= points.length) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            points[index].label,
                            style: AppTextStyles.subtitle(context).copyWith(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        points.length,
                        (index) => FlSpot(
                          index.toDouble(),
                          points[index].value,
                        ),
                      ),
                      isCurved: true,
                      color: context.appColors.gold,
                      barWidth: 3,
                      dotData: FlDotData(
                        getDotPainter: (spot, percent, bar, index) =>
                            FlDotCirclePainter(
                          radius: 4,
                          color: context.appColors.gold,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: context.appColors.gold.withValues(alpha: 0.18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class ModuleOverviewChart extends StatelessWidget {
  const ModuleOverviewChart({
    required this.stats,
    required this.showCustomers,
    required this.showCenters,
    required this.showEmployees,
    required this.showBranches,
    super.key,
  });

  final DashboardStats stats;
  final bool showCustomers;
  final bool showCenters;
  final bool showEmployees;
  final bool showBranches;

  @override
  Widget build(BuildContext context) {
    final segments = <ChartSegment>[];

    if (showCustomers) {
      segments.add(ChartSegment(
        label: 'Customers',
        value: stats.customerTotal.toDouble(),
        colorArgb: AppColors.navy.toARGB32(),
      ));
    }
    if (showCenters) {
      segments.add(ChartSegment(
        label: 'Centers',
        value: stats.centerTotal.toDouble(),
        colorArgb: context.appColors.gold.toARGB32(),
      ));
    }
    if (showEmployees) {
      segments.add(ChartSegment(
        label: 'Employees',
        value: stats.employeeTotal.toDouble(),
        colorArgb: context.appColors.textPrimary.toARGB32(),
      ));
    }
    if (showBranches) {
      segments.add(ChartSegment(
        label: 'Branches',
        value: stats.branchTotal.toDouble(),
        colorArgb: const Color(0xFF8B7355).toARGB32(),
      ));
    }

    final maxY = segments.fold<double>(
      0,
      (max, item) => item.value > max ? item.value : max,
    );

    return DashboardChartCard(
      title: 'Application Overview',
      subtitle: 'Counts across all modules',
      child: segments.isEmpty
          ? const _ChartEmptyState(message: 'No module data available')
          : Column(
              children: [
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      maxY: maxY <= 0 ? 10 : maxY * 1.2,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: AppColors.progressTrack,
                          strokeWidth: 1,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(),
                        rightTitles: const AxisTitles(),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 32,
                            getTitlesWidget: (value, meta) => Text(
                              value.toInt().toString(),
                              style:
                                  AppTextStyles.subtitle(context).copyWith(fontSize: 10),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 32,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index < 0 || index >= segments.length) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  segments[index].label,
                                  style: AppTextStyles.subtitle(context)
                                      .copyWith(fontSize: 10),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      barGroups: List.generate(
                        segments.length,
                        (index) => BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: segments[index].value,
                              color: Color(segments[index].colorArgb),
                              width: 28,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _ChartLegend extends StatelessWidget {
  const _ChartLegend({required this.segments});

  final List<ChartSegment> segments;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: segments
          .map(
            (segment) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Color(segment.colorArgb),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${segment.label} (${segment.value.toInt()})',
                  style: AppTextStyles.subtitle(context).copyWith(fontSize: 12),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}

class _ChartEmptyState extends StatelessWidget {
  const _ChartEmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.insert_chart_outlined,
              size: 36,
              color: context.appColors.shinyGold.withValues(alpha: 0.45),
            ),
            const SizedBox(height: 8),
            Text(message, style: AppTextStyles.subtitle(context)),
          ],
        ),
      ),
    );
  }
}
