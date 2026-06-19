import 'package:sawaliyatrader/core/customers/models/json_parse.dart';

class CenterMember {
  const CenterMember({
    required this.id,
    required this.customerId,
    required this.customerName,
    this.customerCode,
    this.mobile,
    this.isLeader = false,
    this.joinedAt,
  });

  factory CenterMember.fromJson(Map<String, dynamic> json) {
    final customerJson = asJsonMap(json['customer']) ?? json;

    return CenterMember(
      id: readInt(json, ['id', 'member_id']) ?? 0,
      customerId: readInt(json, ['customer_id']) ??
          readInt(customerJson, ['id', 'customer_id']) ??
          0,
      customerName: readString(customerJson, [
            'full_name',
            'name',
            'customer_name',
          ]) ??
          'Member',
      customerCode: readString(customerJson, ['customer_code', 'code']),
      mobile: readString(customerJson, ['mobile', 'phone', 'phone_number']),
      isLeader: readBool(json, ['is_leader', 'leader']) ?? false,
      joinedAt: readDateTime(json, ['joined_at', 'created_at']),
    );
  }

  final int id;
  final int customerId;
  final String customerName;
  final String? customerCode;
  final String? mobile;
  final bool isLeader;
  final DateTime? joinedAt;

  String get displayCode => customerCode ?? '#$customerId';
}
