import 'package:sawaliyatrader/core/customers/models/customer_status.dart';
import 'package:sawaliyatrader/core/customers/models/json_parse.dart';

class CustomerDto {
  const CustomerDto({
    required this.id,
    required this.fullName,
    required this.status,
    this.customerCode,
    this.mobile,
    this.branch,
    this.city,
    this.createdAt,
  });

  factory CustomerDto.fromJson(Map<String, dynamic> json) {
    return CustomerDto(
      id: readInt(json, ['id']) ?? 0,
      fullName: readString(json, ['full_name', 'name', 'customer_name']) ??
          'Unnamed Customer',
      customerCode: readString(json, ['customer_code', 'code']),
      mobile: readString(json, ['mobile', 'phone', 'phone_number']),
      branch: readString(json, ['branch', 'branch_name']),
      city: readString(json, ['city']),
      status: CustomerStatus.fromValue(readString(json, ['status'])) ??
          CustomerStatus.sourced,
      createdAt: readDateTime(json, ['created_at']),
    );
  }

  final int id;
  final String fullName;
  final String? customerCode;
  final String? mobile;
  final String? branch;
  final String? city;
  final CustomerStatus status;
  final DateTime? createdAt;

  String get displayCode => customerCode ?? '#$id';

  String get locationLine {
    final parts = [branch, city].whereType<String>().where((v) => v.isNotEmpty);
    return parts.join(' · ');
  }
}
