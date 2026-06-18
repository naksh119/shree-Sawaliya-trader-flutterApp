import 'package:sawaliyatrader/core/customers/models/customer_dto.dart';
import 'package:sawaliyatrader/core/customers/models/json_parse.dart';

class CustomerListResponse {
  const CustomerListResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory CustomerListResponse.fromJson(Map<String, dynamic> json) {
    final data = dataMap(json);

    return CustomerListResponse(
      items: (data['results'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(CustomerDto.fromJson)
          .toList(),
      total: readInt(data, ['total']) ?? 0,
      page: readInt(data, ['page']) ?? 1,
      pageSize: readInt(data, ['page_size']) ?? 20,
    );
  }

  final List<CustomerDto> items;
  final int total;
  final int page;
  final int pageSize;

  bool get hasMore => page * pageSize < total;
}
