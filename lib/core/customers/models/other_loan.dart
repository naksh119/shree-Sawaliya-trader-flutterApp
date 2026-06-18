import 'package:sawaliyatrader/core/customers/models/json_parse.dart';

class OtherLoan {
  const OtherLoan({
    required this.id,
    this.lenderName,
    this.loanAmount,
    this.emiAmount,
    this.outstandingAmount,
    this.notes,
  });

  factory OtherLoan.fromJson(Map<String, dynamic> json) {
    return OtherLoan(
      id: readInt(json, ['id']) ?? 0,
      lenderName: readString(json, ['lender_name', 'lender']),
      loanAmount: readDouble(json, ['loan_amount', 'amount']),
      emiAmount: readDouble(json, ['emi_amount', 'emi']),
      outstandingAmount:
          readDouble(json, ['outstanding_amount', 'outstanding']),
      notes: readString(json, ['notes', 'remarks']),
    );
  }

  final int id;
  final String? lenderName;
  final double? loanAmount;
  final double? emiAmount;
  final double? outstandingAmount;
  final String? notes;

  Map<String, dynamic> toPayload() {
    return {
      if (lenderName != null) 'lender_name': lenderName,
      if (loanAmount != null) 'loan_amount': loanAmount.toString(),
      if (emiAmount != null) 'emi_amount': emiAmount.toString(),
      if (outstandingAmount != null)
        'outstanding_amount': outstandingAmount.toString(),
      if (notes != null) 'notes': notes,
    };
  }
}
