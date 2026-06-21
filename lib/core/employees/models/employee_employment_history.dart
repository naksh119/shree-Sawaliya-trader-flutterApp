import 'package:sawaliyatrader/core/customers/models/json_parse.dart';

class EmployeeEmploymentHistory {
  const EmployeeEmploymentHistory({
    required this.id,
    required this.employeeId,
    required this.organizationName,
    this.designation,
    this.serviceFrom,
    this.serviceTo,
    this.annualCtc,
    this.createdAt,
    this.updatedAt,
  });

  factory EmployeeEmploymentHistory.fromJson(Map<String, dynamic> json) {
    return EmployeeEmploymentHistory(
      id: readInt(json, ['id']) ?? 0,
      employeeId: readInt(json, ['employee']) ?? 0,
      organizationName: readString(json, ['organization_name']) ?? '',
      designation: readString(json, ['designation']),
      serviceFrom: readDateTime(json, ['service_from']),
      serviceTo: readDateTime(json, ['service_to']),
      annualCtc: readString(json, ['annual_ctc']),
      createdAt: readDateTime(json, ['created_at']),
      updatedAt: readDateTime(json, ['updated_at']),
    );
  }

  final int id;
  final int employeeId;
  final String organizationName;
  final String? designation;
  final DateTime? serviceFrom;
  final DateTime? serviceTo;
  final String? annualCtc;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toPayload() {
    return {
      'organization_name': organizationName,
      if (designation != null && designation!.trim().isNotEmpty)
        'designation': designation,
      if (serviceFrom != null) 'service_from': _formatDate(serviceFrom!),
      if (serviceTo != null) 'service_to': _formatDate(serviceTo!),
      if (annualCtc != null && annualCtc!.trim().isNotEmpty)
        'annual_ctc': annualCtc,
    };
  }

  static String _formatDate(DateTime date) =>
      date.toIso8601String().split('T').first;
}
