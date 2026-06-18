import 'package:sawaliyatrader/core/customers/models/json_parse.dart';

class BranchDto {
  const BranchDto({
    required this.id,
    required this.name,
    required this.code,
    required this.city,
    this.location,
    this.paymentQrCode,
    this.isActive = true,
    this.isDeleted = false,
    this.createdAt,
    this.updatedAt,
  });

  factory BranchDto.fromJson(Map<String, dynamic> json) {
    final branchJson = asJsonMap(json['branch']) ?? json;
    return BranchDto(
      id: readInt(branchJson, ['id', 'branch_id']) ?? 0,
      name: readString(branchJson, ['branch_name', 'name']) ?? '',
      code: readString(branchJson, ['branch_code', 'code']) ?? '',
      city: readString(branchJson, ['branch_city', 'city']) ?? '',
      location: readString(branchJson, ['branch_location', 'location', 'address']),
      paymentQrCode: readString(branchJson, ['payment_qr_code', 'qr_code']),
      isActive: readBool(branchJson, ['is_active', 'active']) ?? true,
      isDeleted: readBool(branchJson, ['is_deleted']) ?? false,
      createdAt: readDateTime(branchJson, ['created_at']),
      updatedAt: readDateTime(branchJson, ['updated_at']),
    );
  }

  final int id;
  final String name;
  final String code;
  final String city;
  final String? location;
  final String? paymentQrCode;
  final bool isActive;
  final bool isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get displayCode => code.isNotEmpty ? code : '—';

  String get locationLine {
    final parts = [city, location].whereType<String>().where((v) => v.isNotEmpty);
    return parts.join(' · ');
  }

  String get initials {
    if (code.length >= 2) return code.substring(0, 2).toUpperCase();
    if (code.isNotEmpty) return code.toUpperCase();
    if (name.isNotEmpty) return name.substring(0, 1).toUpperCase();
    return '—';
  }

  bool get hasPaymentQr =>
      paymentQrCode != null && paymentQrCode!.isNotEmpty;
}

class BranchListResponse {
  const BranchListResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory BranchListResponse.fromJson(Map<String, dynamic> json) {
    final itemMaps = listMapsFromBody(json);

    return BranchListResponse(
      items: itemMaps.map(BranchDto.fromJson).toList(),
      total: paginationInt(json, ['count', 'total']) ?? itemMaps.length,
      page: paginationInt(json, ['page']) ?? 1,
      pageSize: paginationInt(json, ['page_size']) ?? 20,
    );
  }

  final List<BranchDto> items;
  final int total;
  final int page;
  final int pageSize;

  bool get hasMore => page * pageSize < total;
}

class BranchCreateRequest {
  const BranchCreateRequest({
    required this.name,
    required this.code,
    required this.city,
    this.location,
    this.isActive = true,
  });

  final String name;
  final String code;
  final String city;
  final String? location;
  final bool isActive;

  Map<String, dynamic> toJson() {
    return {
      'branch_name': name,
      'branch_code': code.toUpperCase(),
      'branch_city': city,
      if (location != null && location!.isNotEmpty) 'branch_location': location,
      'is_active': isActive,
    };
  }
}
