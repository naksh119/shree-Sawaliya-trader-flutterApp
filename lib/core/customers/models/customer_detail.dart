import 'package:sawaliyatrader/core/customers/models/customer_document.dart';
import 'package:sawaliyatrader/core/customers/models/customer_dto.dart';
import 'package:sawaliyatrader/core/customers/models/customer_status.dart';
import 'package:sawaliyatrader/core/customers/models/family_member.dart';
import 'package:sawaliyatrader/core/customers/models/guarantor.dart';
import 'package:sawaliyatrader/core/customers/models/json_parse.dart';
import 'package:sawaliyatrader/core/customers/models/maternal_house.dart';
import 'package:sawaliyatrader/core/customers/models/other_loan.dart';

class CustomerDetail extends CustomerDto {
  const CustomerDetail({
    required super.id,
    required super.fullName,
    required super.status,
    super.customerCode,
    super.mobile,
    super.branch,
    super.city,
    super.createdAt,
    this.email,
    this.aadhaarNumber,
    this.panNumber,
    this.dateOfBirth,
    this.gender,
    this.addressLine1,
    this.addressLine2,
    this.state,
    this.pincode,
    this.occupation,
    this.monthlyIncome,
    this.sourcedBy,
    this.updatedAt,
    this.familyMembers = const [],
    this.guarantors = const [],
    this.maternalHouse,
    this.otherLoans = const [],
    this.documents = const [],
  });

  factory CustomerDetail.fromJson(Map<String, dynamic> json) {
    final base = CustomerDto.fromJson(json);

    List<T> parseList<T>(
      String key,
      T Function(Map<String, dynamic>) mapper,
    ) {
      final raw = json[key];
      if (raw is! List) return const [];
      return raw.whereType<Map<String, dynamic>>().map(mapper).toList();
    }

    final maternalRaw = json['maternal_house'];
    MaternalHouse? maternalHouse;
    if (maternalRaw is Map<String, dynamic>) {
      maternalHouse = MaternalHouse.fromJson(maternalRaw);
    }

    return CustomerDetail(
      id: base.id,
      fullName: base.fullName,
      customerCode: base.customerCode,
      mobile: base.mobile,
      branch: base.branch,
      city: base.city,
      status: base.status,
      createdAt: base.createdAt,
      email: readString(json, ['email']),
      aadhaarNumber: readString(json, ['aadhaar_number', 'aadhaar']),
      panNumber: readString(json, ['pan_number', 'pan']),
      dateOfBirth: readDateTime(json, ['date_of_birth', 'dob']),
      gender: readString(json, ['gender']),
      addressLine1: readString(json, ['address_line1', 'address']),
      addressLine2: readString(json, ['address_line2']),
      state: readString(json, ['state']),
      pincode: readString(json, ['pincode', 'postal_code']),
      occupation: readString(json, ['occupation']),
      monthlyIncome: readDouble(json, ['monthly_income', 'income']),
      sourcedBy: readString(json, ['sourced_by', 'sourced_by_name']),
      updatedAt: readDateTime(json, ['updated_at']),
      familyMembers: parseList('family_members', FamilyMember.fromJson),
      guarantors: parseList('guarantors', Guarantor.fromJson),
      maternalHouse: maternalHouse,
      otherLoans: parseList('other_loans', OtherLoan.fromJson),
      documents: parseList('documents', CustomerDocument.fromJson),
    );
  }

  final String? email;
  final String? aadhaarNumber;
  final String? panNumber;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? addressLine1;
  final String? addressLine2;
  final String? state;
  final String? pincode;
  final String? occupation;
  final double? monthlyIncome;
  final String? sourcedBy;
  final DateTime? updatedAt;
  final List<FamilyMember> familyMembers;
  final List<Guarantor> guarantors;
  final MaternalHouse? maternalHouse;
  final List<OtherLoan> otherLoans;
  final List<CustomerDocument> documents;

  String get fullAddress {
    final parts = [
      addressLine1,
      addressLine2,
      city,
      state,
      pincode,
    ].whereType<String>().where((v) => v.isNotEmpty);
    return parts.join(', ');
  }

  Map<String, dynamic> toCreatePayload() {
    return {
      'full_name': fullName,
      if (mobile != null) 'mobile': mobile,
      if (email != null) 'email': email,
      if (aadhaarNumber != null) 'aadhaar_number': aadhaarNumber,
      if (panNumber != null) 'pan_number': panNumber,
      if (dateOfBirth != null)
        'date_of_birth': dateOfBirth!.toIso8601String().split('T').first,
      if (gender != null) 'gender': gender,
      if (addressLine1 != null) 'address_line1': addressLine1,
      if (addressLine2 != null) 'address_line2': addressLine2,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (pincode != null) 'pincode': pincode,
      if (branch != null) 'branch': branch,
      if (occupation != null) 'occupation': occupation,
      if (monthlyIncome != null) 'monthly_income': monthlyIncome.toString(),
    };
  }

  CustomerDetail copyWith({
    CustomerStatus? status,
    List<FamilyMember>? familyMembers,
    List<Guarantor>? guarantors,
    MaternalHouse? maternalHouse,
    List<OtherLoan>? otherLoans,
    List<CustomerDocument>? documents,
  }) {
    return CustomerDetail(
      id: id,
      fullName: fullName,
      customerCode: customerCode,
      mobile: mobile,
      branch: branch,
      city: city,
      status: status ?? this.status,
      createdAt: createdAt,
      email: email,
      aadhaarNumber: aadhaarNumber,
      panNumber: panNumber,
      dateOfBirth: dateOfBirth,
      gender: gender,
      addressLine1: addressLine1,
      addressLine2: addressLine2,
      state: state,
      pincode: pincode,
      occupation: occupation,
      monthlyIncome: monthlyIncome,
      sourcedBy: sourcedBy,
      updatedAt: updatedAt,
      familyMembers: familyMembers ?? this.familyMembers,
      guarantors: guarantors ?? this.guarantors,
      maternalHouse: maternalHouse ?? this.maternalHouse,
      otherLoans: otherLoans ?? this.otherLoans,
      documents: documents ?? this.documents,
    );
  }
}
