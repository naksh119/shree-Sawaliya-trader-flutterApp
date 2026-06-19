import 'package:sawaliyatrader/core/centers/models/center_product_type.dart';
import 'package:sawaliyatrader/core/centers/models/center_status.dart';
import 'package:sawaliyatrader/core/customers/models/json_parse.dart';

class CenterDto {
  const CenterDto({
    required this.id,
    required this.name,
    required this.status,
    this.code,
    this.branch,
    this.productType,
    this.loanAmount,
    this.emiAmount,
    this.tenureMonths,
    this.memberCount = 0,
    this.emiGenerated = false,
    this.startDate,
    this.createdAt,
  });

  factory CenterDto.fromJson(Map<String, dynamic> json) {
    final centerJson = asJsonMap(json['center']) ?? json;
    final members = mapsFromList(centerJson['members']);

    return CenterDto(
      id: readInt(centerJson, ['id', 'center_id']) ?? 0,
      name: readString(centerJson, ['center_name', 'name']) ?? 'Unnamed Center',
      code: readString(centerJson, ['center_code', 'code']),
      branch: readString(centerJson, ['branch', 'branch_name']),
      productType: CenterProductType.fromValue(
        readString(centerJson, ['product_type', 'product']),
      ),
      loanAmount: readDouble(centerJson, [
        'loan_amount',
        'principal_amount',
        'amount',
      ]),
      emiAmount: readDouble(centerJson, ['emi_amount', 'emi']),
      tenureMonths: readInt(centerJson, ['tenure_months', 'tenure']),
      memberCount: readInt(centerJson, [
            'member_count',
            'members_count',
            'total_members',
          ]) ??
          (members.isNotEmpty ? members.length : 0),
      status: CenterStatus.fromValue(readString(centerJson, ['status'])) ??
          CenterStatus.pending,
      emiGenerated:
          readBool(centerJson, ['emi_generated', 'has_emi_schedule']) ?? false,
      startDate: readDateTime(centerJson, ['start_date', 'loan_start_date']),
      createdAt: readDateTime(centerJson, ['created_at']),
    );
  }

  final int id;
  final String name;
  final String? code;
  final String? branch;
  final CenterProductType? productType;
  final double? loanAmount;
  final double? emiAmount;
  final int? tenureMonths;
  final int memberCount;
  final CenterStatus status;
  final bool emiGenerated;
  final DateTime? startDate;
  final DateTime? createdAt;

  String get displayCode => code ?? '#$id';

  String get subtitleLine {
    final parts = <String>[
      if (productType != null) productType!.label,
      if (branch != null && branch!.isNotEmpty) branch!,
      if (memberCount > 0) '$memberCount members',
    ];
    return parts.join(' · ');
  }

  String get initials {
    if (code != null && code!.length >= 2) {
      return code!.substring(0, 2).toUpperCase();
    }
    if (name.isNotEmpty) return name.substring(0, 1).toUpperCase();
    return 'C';
  }
}
