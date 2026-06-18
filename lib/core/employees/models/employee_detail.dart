import 'package:sawaliyatrader/core/customers/models/json_parse.dart';
import 'package:sawaliyatrader/core/employees/models/employee_dto.dart';

class EmployeeDetail extends EmployeeDto {
  const EmployeeDetail({
    required super.id,
    required super.role,
    required super.branch,
    super.employeeId,
    super.employeeCode,
    super.firstName,
    super.lastName,
    super.fullName,
    super.email,
    super.mobile,
    super.roleId,
    super.isActive,
    super.dateOfJoining,
    super.createdAt,
    this.updatedAt,
    this.fatherName,
    this.dateOfBirth,
    this.placeOfBirth,
    this.gender,
    this.maritalStatus,
    this.nationality,
    this.languagesKnown,
    this.employeePhoto,
    this.aadhaarCardNo,
    this.panCardNo,
    this.secondaryMobile,
    this.addressLine1,
    this.permanentAddress,
    this.heightCm,
    this.weightKg,
    this.bloodGroup,
    this.dateOfAppointment,
    this.dateOfConfirmation,
    this.payableFromDate,
    this.performanceAppraisal,
    this.warningNotes,
    this.remarks,
    this.educationalQualifications,
    this.professionalQualifications,
    this.membersInFamily,
    this.emergencyContactName,
    this.emergencyContactRelation,
    this.emergencyContactNumber,
    this.isDeleted = false,
    this.roleName,
    this.roleDescription,
    this.branchCode,
    this.branchCity,
    this.branchLocation,
    this.permissions = const [],
    this.rolePermissions = const [],
  });

  factory EmployeeDetail.fromJson(Map<String, dynamic> json) {
    final flat = EmployeeDto.flattenUserRecord(json);
    final base = EmployeeDto.fromJson(json);
    final roleMap = asJsonMap(flat['role']);
    final branchMap = asJsonMap(flat['branch']);

    return EmployeeDetail(
      id: base.id,
      employeeId: base.employeeId,
      employeeCode: base.employeeCode,
      firstName: base.firstName,
      lastName: base.lastName,
      fullName: base.fullName,
      email: base.email,
      mobile: base.mobile,
      role: base.role,
      roleId: base.roleId,
      branch: base.branch,
      isActive: base.isActive,
      dateOfJoining: base.dateOfJoining,
      createdAt: base.createdAt,
      updatedAt: readDateTime(flat, ['updated_at']),
      fatherName: readString(flat, ['father_name']),
      dateOfBirth: readDateTime(flat, ['date_of_birth', 'dob']),
      placeOfBirth: readString(flat, ['place_of_birth']),
      gender: readString(flat, ['gender']),
      maritalStatus: readString(flat, ['marital_status']),
      nationality: readString(flat, ['nationality']),
      languagesKnown: readString(flat, ['languages_known']),
      employeePhoto: readString(flat, ['employee_photo', 'photo']),
      aadhaarCardNo: readString(flat, ['aadhaar_card_no', 'aadhaar']),
      panCardNo: readString(flat, ['pan_card_no', 'pan']),
      secondaryMobile: readString(flat, [
        'secondary_mobile_number',
        'secondary_mobile',
      ]),
      addressLine1: readString(flat, [
        'present_address',
        'address_line1',
        'address',
      ]),
      permanentAddress: readString(flat, ['permanent_address']),
      heightCm: readString(flat, ['height_cm']),
      weightKg: readString(flat, ['weight_kg']),
      bloodGroup: readString(flat, ['blood_group']),
      dateOfAppointment: readDateTime(flat, ['date_of_appointment']),
      dateOfConfirmation: readDateTime(flat, ['date_of_confirmation']),
      payableFromDate: readDateTime(flat, ['payable_from_date']),
      performanceAppraisal: readString(flat, ['performance_appraisal']),
      warningNotes: readString(flat, ['warning_notes']),
      remarks: readString(flat, ['remarks']),
      educationalQualifications: readString(flat, [
        'educational_qualifications',
      ]),
      professionalQualifications: readString(flat, [
        'professional_qualifications',
      ]),
      membersInFamily: readInt(flat, ['members_in_family']),
      emergencyContactName: readString(flat, ['emergency_contact_name']),
      emergencyContactRelation: readString(flat, [
        'emergency_contact_relation',
      ]),
      emergencyContactNumber: readString(flat, ['emergency_contact_number']),
      isDeleted: readBool(flat, ['is_deleted']) ?? false,
      roleName: roleMap != null
          ? readString(roleMap, ['role_name', 'name'])
          : null,
      roleDescription: roleMap != null
          ? readString(roleMap, ['working_description', 'description'])
          : null,
      branchCode: branchMap != null
          ? readString(branchMap, ['branch_code', 'code'])
          : null,
      branchCity: branchMap != null
          ? readString(branchMap, ['branch_city', 'city'])
          : null,
      branchLocation: branchMap != null
          ? readString(branchMap, ['branch_location', 'location', 'address'])
          : null,
      permissions: _readPermissionLabels(json),
      rolePermissions: roleMap != null
          ? _readPermissionLabels(roleMap)
          : const [],
    );
  }

  static List<String> _readPermissionLabels(Map<String, dynamic> json) {
    final raw = json['permissions'];
    if (raw is! List) return const [];

    return raw
        .map((item) {
          if (item is String) return item.trim();
          final map = asJsonMap(item);
          if (map != null) {
            return readString(map, [
                  'code',
                  'permission_code',
                  'name',
                  'permission_name',
                ]) ??
                '';
          }
          return item.toString().trim();
        })
        .where((label) => label.isNotEmpty)
        .toList();
  }

  final DateTime? updatedAt;
  final String? fatherName;
  final DateTime? dateOfBirth;
  final String? placeOfBirth;
  final String? gender;
  final String? maritalStatus;
  final String? nationality;
  final String? languagesKnown;
  final String? employeePhoto;
  final String? aadhaarCardNo;
  final String? panCardNo;
  final String? secondaryMobile;
  final String? addressLine1;
  final String? permanentAddress;
  final String? heightCm;
  final String? weightKg;
  final String? bloodGroup;
  final DateTime? dateOfAppointment;
  final DateTime? dateOfConfirmation;
  final DateTime? payableFromDate;
  final String? performanceAppraisal;
  final String? warningNotes;
  final String? remarks;
  final String? educationalQualifications;
  final String? professionalQualifications;
  final int? membersInFamily;
  final String? emergencyContactName;
  final String? emergencyContactRelation;
  final String? emergencyContactNumber;
  final bool isDeleted;
  final String? roleName;
  final String? roleDescription;
  final String? branchCode;
  final String? branchCity;
  final String? branchLocation;
  final List<String> permissions;
  final List<String> rolePermissions;
}
