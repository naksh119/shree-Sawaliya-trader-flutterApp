import 'package:sawaliyatrader/core/centers/models/center_dto.dart';
import 'package:sawaliyatrader/core/customers/models/json_parse.dart';

class CenterListResponse {
  const CenterListResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory CenterListResponse.fromJson(Map<String, dynamic> json) {
    final itemMaps = listMapsFromBody(json);

    return CenterListResponse(
      items: itemMaps.map(CenterDto.fromJson).toList(),
      total: paginationInt(json, ['count', 'total']) ?? itemMaps.length,
      page: paginationInt(json, ['page']) ?? 1,
      pageSize: paginationInt(json, ['page_size']) ?? 20,
    );
  }

  final List<CenterDto> items;
  final int total;
  final int page;
  final int pageSize;

  bool get hasMore => page * pageSize < total;
}
