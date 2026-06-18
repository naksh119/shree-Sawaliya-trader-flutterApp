import 'package:flutter/foundation.dart';
import 'package:sawaliyatrader/core/customers/models/json_parse.dart';
import 'package:sawaliyatrader/core/employees/models/employee_dto.dart';

class EmployeeListResponse {
  const EmployeeListResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory EmployeeListResponse.fromJson(Map<String, dynamic> json) {
    final itemMaps = listMapsFromBody(json);

    debugPrint(
      '[Employees] parse list itemCount=${itemMaps.length} '
      'bodyKeys=${json.keys.toList()}',
    );

    final items = itemMaps.map(EmployeeDto.fromJson).toList();
    if (items.isNotEmpty) {
      final first = items.first;
      debugPrint(
        '[Employees] first item id=${first.id} '
        'name=${first.displayName} role=${first.role} branch=${first.branch}',
      );
    }

    return EmployeeListResponse(
      items: items,
      total: paginationInt(json, ['count', 'total']) ?? itemMaps.length,
      page: paginationInt(json, ['page']) ?? 1,
      pageSize: paginationInt(json, ['page_size']) ?? 20,
    );
  }

  final List<EmployeeDto> items;
  final int total;
  final int page;
  final int pageSize;

  bool get hasMore => page * pageSize < total;
}
