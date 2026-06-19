import 'package:sawaliyatrader/core/centers/models/center_dto.dart';
import 'package:sawaliyatrader/core/centers/models/center_member.dart';
import 'package:sawaliyatrader/core/centers/models/center_product_type.dart';
import 'package:sawaliyatrader/core/centers/models/center_status.dart';
import 'package:sawaliyatrader/core/customers/models/json_parse.dart';

class CenterDetail {
  const CenterDetail({
    required this.id,
    required this.name,
    required this.status,
    this.code,
    this.branch,
    this.productType,
    this.loanAmount,
    this.emiAmount,
    this.interestRate,
    this.tenureMonths,
    this.weight,
    this.purity,
    this.remarks,
    this.emiGenerated = false,
    this.startDate,
    this.createdAt,
    this.members = const [],
  });

  factory CenterDetail.fromJson(Map<String, dynamic> json) {
    final centerJson = asJsonMap(json['center']) ?? json;
    final productType = CenterProductType.fromValue(
      readString(centerJson, ['product_type', 'product']),
    );

    return CenterDetail(
      id: readInt(centerJson, ['id', 'center_id']) ?? 0,
      name: readString(centerJson, ['center_name', 'name']) ?? 'Unnamed Center',
      code: readString(centerJson, ['center_code', 'code']),
      branch: readString(centerJson, ['branch', 'branch_name']),
      productType: productType,
      loanAmount: readDouble(centerJson, [
        'loan_amount',
        'principal_amount',
        'amount',
      ]),
      emiAmount: readDouble(centerJson, ['emi_amount', 'emi']),
      interestRate: readDouble(centerJson, [
        'interest_rate',
        'interest_rate_percent',
        'rate_of_interest',
      ]),
      tenureMonths: readInt(centerJson, ['tenure_months', 'tenure']),
      weight: readDouble(centerJson, [
        if (productType == CenterProductType.silver) ...[
          'silver_weight',
          'product_weight',
          'weight',
        ] else ...[
          'gold_weight',
          'product_weight',
          'weight',
        ],
      ]),
      purity: readString(centerJson, ['purity', 'gold_purity', 'silver_purity']),
      remarks: readString(centerJson, ['remarks', 'notes']),
      status: CenterStatus.fromValue(readString(centerJson, ['status'])) ??
          CenterStatus.pending,
      emiGenerated:
          readBool(centerJson, ['emi_generated', 'has_emi_schedule']) ?? false,
      startDate: readDateTime(centerJson, ['start_date', 'loan_start_date']),
      createdAt: readDateTime(centerJson, ['created_at']),
      members: mapsFromList(centerJson['members'])
          .map(CenterMember.fromJson)
          .toList(),
    );
  }

  final int id;
  final String name;
  final String? code;
  final String? branch;
  final CenterProductType? productType;
  final double? loanAmount;
  final double? emiAmount;
  final double? interestRate;
  final int? tenureMonths;
  final double? weight;
  final String? purity;
  final String? remarks;
  final CenterStatus status;
  final bool emiGenerated;
  final DateTime? startDate;
  final DateTime? createdAt;
  final List<CenterMember> members;

  String get displayCode => code ?? '#$id';

  int get memberCount => members.length;

  CenterDto toDto() {
    return CenterDto(
      id: id,
      name: name,
      code: code,
      branch: branch,
      productType: productType,
      loanAmount: loanAmount,
      emiAmount: emiAmount,
      tenureMonths: tenureMonths,
      memberCount: memberCount,
      status: status,
      emiGenerated: emiGenerated,
      startDate: startDate,
      createdAt: createdAt,
    );
  }
}
