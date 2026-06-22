/// Request body for `PATCH /employees/api/{id}/` (partial update).
class EmployeePatchRequest {
  const EmployeePatchRequest({
    this.email,
    this.password,
    this.roleId,
    this.branchId,
    required this.firstName,
    required this.lastName,
    this.fatherName,
    this.dateOfBirth,
    this.placeOfBirth,
    this.gender,
    this.maritalStatus,
    this.nationality,
    this.languagesKnown,
    this.aadhaarCardNo,
    this.panCardNo,
    this.primaryMobileNumber,
    this.secondaryMobileNumber,
    this.presentAddress,
    this.permanentAddress,
    this.heightCm,
    this.weightKg,
    this.bloodGroup,
    this.dateOfAppointment,
    this.dateOfJoining,
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
  });

  final String? email;
  final String? password;
  final int? roleId;
  final int? branchId;
  final String firstName;
  final String lastName;
  final String? fatherName;
  final DateTime? dateOfBirth;
  final String? placeOfBirth;
  final String? gender;
  final String? maritalStatus;
  final String? nationality;
  final String? languagesKnown;
  final String? aadhaarCardNo;
  final String? panCardNo;
  final String? primaryMobileNumber;
  final String? secondaryMobileNumber;
  final String? presentAddress;
  final String? permanentAddress;
  final String? heightCm;
  final String? weightKg;
  final String? bloodGroup;
  final DateTime? dateOfAppointment;
  final DateTime? dateOfJoining;
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

  Map<String, dynamic> toJson() {
    return {
      if (_hasText(email)) 'email': email,
      if (_hasText(password)) 'password': password,
      if (roleId != null) 'role': roleId,
      if (branchId != null) 'branch': branchId,
      'first_name': firstName,
      'last_name': lastName,
      if (_hasText(fatherName)) 'father_name': fatherName,
      if (dateOfBirth != null) 'date_of_birth': _formatDate(dateOfBirth!),
      if (_hasText(placeOfBirth)) 'place_of_birth': placeOfBirth,
      if (_hasText(gender)) 'gender': gender,
      if (_hasText(maritalStatus)) 'marital_status': maritalStatus,
      if (_hasText(nationality)) 'nationality': nationality,
      if (_hasText(languagesKnown)) 'languages_known': languagesKnown,
      if (_hasText(aadhaarCardNo)) 'aadhaar_card_no': aadhaarCardNo,
      if (_hasText(panCardNo)) 'pan_card_no': panCardNo,
      if (_hasText(primaryMobileNumber))
        'primary_mobile_number': primaryMobileNumber,
      if (_hasText(secondaryMobileNumber))
        'secondary_mobile_number': secondaryMobileNumber,
      if (_hasText(presentAddress)) 'present_address': presentAddress,
      if (_hasText(permanentAddress)) 'permanent_address': permanentAddress,
      if (_hasText(heightCm)) 'height_cm': heightCm,
      if (_hasText(weightKg)) 'weight_kg': weightKg,
      if (_hasText(bloodGroup)) 'blood_group': bloodGroup,
      if (dateOfAppointment != null)
        'date_of_appointment': _formatDate(dateOfAppointment!),
      if (dateOfJoining != null) 'date_of_joining': _formatDate(dateOfJoining!),
      if (dateOfConfirmation != null)
        'date_of_confirmation': _formatDate(dateOfConfirmation!),
      if (payableFromDate != null)
        'payable_from_date': _formatDate(payableFromDate!),
      if (_hasText(performanceAppraisal))
        'performance_appraisal': performanceAppraisal,
      'warning_notes': warningNotes ?? '',
      if (_hasText(remarks)) 'remarks': remarks,
      if (_hasText(educationalQualifications))
        'educational_qualifications': educationalQualifications,
      if (_hasText(professionalQualifications))
        'professional_qualifications': professionalQualifications,
      if (membersInFamily != null) 'members_in_family': membersInFamily,
      if (_hasText(emergencyContactName))
        'emergency_contact_name': emergencyContactName,
      if (_hasText(emergencyContactRelation))
        'emergency_contact_relation': emergencyContactRelation,
      if (_hasText(emergencyContactNumber))
        'emergency_contact_number': emergencyContactNumber,
    };
  }

  static bool _hasText(String? value) =>
      value != null && value.trim().isNotEmpty;

  static String _formatDate(DateTime date) =>
      date.toIso8601String().split('T').first;
}
