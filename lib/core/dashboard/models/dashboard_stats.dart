import 'package:sawaliyatrader/core/theme/app_colors.dart';

class ChartSegment {
  const ChartSegment({
    required this.label,
    required this.value,
    required this.colorArgb,
  });

  final String label;
  final double value;
  final int colorArgb;

  bool get hasValue => value > 0;

  static int get chartColorArgb => AppColors.gold.toARGB32();
}

class TrendPoint {
  const TrendPoint({
    required this.label,
    required this.value,
  });

  final String label;
  final double value;
}

class DashboardStats {
  const DashboardStats({
    required this.customerTotal,
    required this.customerByStatus,
    required this.centerTotal,
    required this.employeeTotal,
    required this.branchTotal,
    required this.emiByStatus,
    required this.collectionTrend,
    required this.totalCollected,
    required this.pendingEmiCount,
  });

  factory DashboardStats.empty() => const DashboardStats(
        customerTotal: 0,
        customerByStatus: [],
        centerTotal: 0,
        employeeTotal: 0,
        branchTotal: 0,
        emiByStatus: [],
        collectionTrend: [],
        totalCollected: 0,
        pendingEmiCount: 0,
      );

  /// Placeholder dashboard data until live APIs are wired up.
  factory DashboardStats.sample() {
    final chartColor = ChartSegment.chartColorArgb;

    return DashboardStats(
      customerTotal: 248,
      customerByStatus: [
        ChartSegment(label: 'Sourced', value: 42, colorArgb: chartColor),
        ChartSegment(label: 'Applied', value: 35, colorArgb: chartColor),
        ChartSegment(label: 'Under Review', value: 28, colorArgb: chartColor),
        ChartSegment(label: 'Approved', value: 52, colorArgb: chartColor),
        ChartSegment(label: 'Active', value: 78, colorArgb: chartColor),
        ChartSegment(label: 'Rejected', value: 8, colorArgb: chartColor),
        ChartSegment(label: 'Closed', value: 5, colorArgb: chartColor),
      ],
      centerTotal: 36,
      employeeTotal: 24,
      branchTotal: 5,
      emiByStatus: [
        ChartSegment(label: 'Pending', value: 45, colorArgb: chartColor),
        ChartSegment(label: 'Partial', value: 12, colorArgb: chartColor),
        ChartSegment(label: 'Paid', value: 156, colorArgb: chartColor),
        ChartSegment(label: 'Overdue', value: 18, colorArgb: chartColor),
        ChartSegment(label: 'Cancelled', value: 3, colorArgb: chartColor),
      ],
      collectionTrend: const [
        TrendPoint(label: 'Jan 25', value: 1250000),
        TrendPoint(label: 'Feb 25', value: 1480000),
        TrendPoint(label: 'Mar 25', value: 1820000),
        TrendPoint(label: 'Apr 25', value: 1360000),
        TrendPoint(label: 'May 25', value: 2150000),
        TrendPoint(label: 'Jun 25', value: 1920000),
      ],
      totalCollected: 2450000,
      pendingEmiCount: 75,
    );
  }

  final int customerTotal;
  final List<ChartSegment> customerByStatus;
  final int centerTotal;
  final int employeeTotal;
  final int branchTotal;
  final List<ChartSegment> emiByStatus;
  final List<TrendPoint> collectionTrend;
  final double totalCollected;
  final int pendingEmiCount;
}
