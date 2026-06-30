enum CustomerStatus {
  sourced('SOURCED', 'Sourced'),
  applied('APPLIED', 'Applied'),
  underReview('UNNDER_REVIEW', 'Under Review'),
  approved('APPROVED', 'Approved'),
  rejected('REJECTED', 'Rejected'),
  active('ACTIVE', 'Active'),
  closed('CLOSED', 'Closed');

  const CustomerStatus(this.value, this.label);

  final String value;
  final String label;

  static CustomerStatus? fromValue(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    for (final status in CustomerStatus.values) {
      if (status.value == raw) return status;
    }
    return null;
  }

  static List<CustomerStatus> get filterOptions => CustomerStatus.values;

  bool get canApproveOrReject =>
      this == CustomerStatus.applied || this == CustomerStatus.underReview;
}
