import 'package:sawaliyatrader/core/api/api_client.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/constants/api_config.dart';
import 'package:sawaliyatrader/core/customers/models/json_parse.dart';
import 'package:sawaliyatrader/core/dashboard/models/dashboard_stats.dart';
import 'package:sawaliyatrader/core/permissions/permission_service.dart';
import 'package:sawaliyatrader/core/theme/app_colors.dart';

class DashboardService {
  DashboardService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  static const _customerStatuses = [
    ('SOURCED', 'Sourced'),
    ('APPLIED', 'Applied'),
    ('UNNDER_REVIEW', 'Under Review'),
    ('APPROVED', 'Approved'),
    ('REJECTED', 'Rejected'),
    ('ACTIVE', 'Active'),
    ('CLOSED', 'Closed'),
  ];

  static const _emiStatuses = [
    ('PENDING', 'Pending'),
    ('PARTIAL', 'Partial'),
    ('PAID', 'Paid'),
    ('OVERDUE', 'Overdue'),
    ('CANCELLED', 'Cancelled'),
  ];

  static const _customerColors = [
    0xFF8B7355,
    0xFFD4A62A,
    0xFF0B2A8F,
    0xFF4CAF50,
    0xFFE57373,
    0xFF6D5732,
    0xFFB0A090,
  ];

  static const _emiColors = [
    0xFFD4A62A,
    0xFF0B2A8F,
    0xFF4CAF50,
    0xFFE57373,
    0xFFB0A090,
  ];

  Future<DashboardStats> fetchStats({
    required LoginResponse session,
  }) async {
    final checker = PermissionService(session);

    final branch = session.employee?.branch;
    final baseQuery = <String, dynamic>{
      'page': 1,
      'page_size': 1,
      if (branch != null && branch.isNotEmpty) 'branch': branch,
    };

    var customerTotal = 0;
    final customerByStatus = <ChartSegment>[];

    if (checker.canViewCustomers) {
      customerTotal = await _fetchTotal(ApiConfig.customersPath, baseQuery) ?? 0;

      var colorIndex = 0;
      for (final (status, label) in _customerStatuses) {
        final count = await _fetchTotal(
          ApiConfig.customersPath,
          {...baseQuery, 'status': status},
        );
        if (count != null && count > 0) {
          customerByStatus.add(
            ChartSegment(
              label: label,
              value: count.toDouble(),
              colorArgb: _customerColors[colorIndex % _customerColors.length],
            ),
          );
        }
        colorIndex++;
      }
    }

    var centerTotal = 0;
    if (checker.canViewCenters) {
      centerTotal = await _fetchTotal(ApiConfig.centersPath, baseQuery) ?? 0;
    }

    var employeeTotal = 0;
    if (checker.canViewEmployees) {
      employeeTotal =
          await _fetchTotal(ApiConfig.employeesPath, baseQuery) ?? 0;
    }

    var branchTotal = 0;
    if (checker.canManageBranches) {
      branchTotal = await _fetchTotal(
        ApiConfig.branchesPath,
        const {'page': 1, 'page_size': 1},
      ) ?? 0;
    }

    final emiByStatus = <ChartSegment>[];
    var pendingEmiCount = 0;
    var totalCollected = 0.0;
    final collectionTrend = <TrendPoint>[];

    if (checker.canCollectEmi) {
      var colorIndex = 0;
      for (final (status, label) in _emiStatuses) {
        final count = await _fetchTotal(
          '/operations/api/emis/',
          {...baseQuery, 'status': status},
        );
        if (count != null && count > 0) {
          emiByStatus.add(
            ChartSegment(
              label: label,
              value: count.toDouble(),
              colorArgb: _emiColors[colorIndex % _emiColors.length],
            ),
          );
          if (status == 'PENDING' || status == 'OVERDUE' || status == 'PARTIAL') {
            pendingEmiCount += count;
          }
        }
        colorIndex++;
      }

      final emiItems = await _fetchListItems('/operations/api/emis/', {
        ...baseQuery,
        'page_size': 100,
        'status': 'PAID',
      });
      totalCollected = _sumCollectedAmounts(emiItems);
      collectionTrend.addAll(_buildCollectionTrend(emiItems));
    }

    if (collectionTrend.isEmpty && checker.canCollectEmi) {
      collectionTrend.addAll(_emptyTrend());
    }

    return DashboardStats(
      customerTotal: customerTotal,
      customerByStatus: customerByStatus,
      centerTotal: centerTotal,
      employeeTotal: employeeTotal,
      branchTotal: branchTotal,
      emiByStatus: emiByStatus,
      collectionTrend: collectionTrend,
      totalCollected: totalCollected,
      pendingEmiCount: pendingEmiCount,
    );
  }

  Future<int?> _fetchTotal(
    String path,
    Map<String, dynamic> query,
  ) async {
    try {
      final body = await _apiClient.get(path, queryParameters: query);
      if (body['success'] != true) return null;
      final count = paginationInt(body, ['count', 'total']);
      if (count != null) return count;
      return listMapsFromBody(body).length;
    } catch (_) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> _fetchListItems(
    String path,
    Map<String, dynamic> query,
  ) async {
    try {
      final body = await _apiClient.get(path, queryParameters: query);
      if (body['success'] != true) return [];
      return listMapsFromBody(body);
    } catch (_) {
      return [];
    }
  }

  double _sumCollectedAmounts(List<Map<String, dynamic>> items) {
    var total = 0.0;
    for (final item in items) {
      total += _parseAmount(
        item['amount_paid'] ?? item['paid_amount'] ?? item['amount'],
      );
    }
    return total;
  }

  List<TrendPoint> _buildCollectionTrend(List<Map<String, dynamic>> items) {
    final now = DateTime.now();
    final buckets = <String, double>{};

    for (var i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final key = '${_monthLabel(month.month)} ${month.year % 100}';
      buckets[key] = 0;
    }

    for (final item in items) {
      final paidAt = _parseDate(
        item['paid_at'] ?? item['payment_date'] ?? item['updated_at'],
      );
      if (paidAt == null) continue;

      final key = '${_monthLabel(paidAt.month)} ${paidAt.year % 100}';
      if (!buckets.containsKey(key)) continue;

      buckets[key] = (buckets[key] ?? 0) +
          _parseAmount(
            item['amount_paid'] ?? item['paid_amount'] ?? item['amount'],
          );
    }

    return buckets.entries
        .map((entry) => TrendPoint(label: entry.key, value: entry.value))
        .toList();
  }

  List<TrendPoint> _emptyTrend() {
    final now = DateTime.now();
    return List.generate(6, (index) {
      final month = DateTime(now.year, now.month - (5 - index), 1);
      return TrendPoint(
        label: '${_monthLabel(month.month)} ${month.year % 100}',
        value: 0,
      );
    });
  }

  double _parseAmount(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  String _monthLabel(int month) {
    const labels = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return labels[month - 1];
  }

  static int get goldArgb => AppColors.gold.toARGB32();
}
