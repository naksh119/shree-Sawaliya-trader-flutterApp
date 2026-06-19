import 'package:sawaliyatrader/core/centers/models/center_product_type.dart';

class CenterCreateRequest {
  const CenterCreateRequest({
    required this.name,
    required this.productType,
    required this.loanAmount,
    required this.interestRate,
    required this.tenureMonths,
    required this.emiAmount,
    required this.memberIds,
    this.branch,
    this.weight,
    this.purity,
    this.startDate,
    this.remarks,
  });

  final String name;
  final CenterProductType productType;
  final double loanAmount;
  final double interestRate;
  final int tenureMonths;
  final double emiAmount;
  final List<int> memberIds;
  final String? branch;
  final double? weight;
  final String? purity;
  final DateTime? startDate;
  final String? remarks;

  Map<String, dynamic> toJson() {
    return {
      'center_name': name.trim(),
      'product_type': productType.value,
      'loan_amount': loanAmount.toStringAsFixed(2),
      'interest_rate': interestRate.toStringAsFixed(2),
      'tenure_months': tenureMonths,
      'emi_amount': emiAmount.toStringAsFixed(2),
      'member_ids': memberIds,
      if (branch != null && branch!.isNotEmpty) 'branch': branch,
      if (weight != null) productType.weightFieldKey: weight!.toStringAsFixed(3),
      if (purity != null && purity!.isNotEmpty) 'purity': purity,
      if (startDate != null)
        'start_date': startDate!.toIso8601String().split('T').first,
      if (remarks != null && remarks!.isNotEmpty) 'remarks': remarks,
    };
  }
}
