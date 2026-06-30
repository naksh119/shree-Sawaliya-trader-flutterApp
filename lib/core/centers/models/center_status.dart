enum CenterStatus {
  pending('PENDING', 'Pending EMI'),
  active('ACTIVE', 'Active'),
  closed('CLOSED', 'Closed');

  const CenterStatus(this.value, this.label);

  final String value;
  final String label;

  static CenterStatus? fromValue(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    for (final status in CenterStatus.values) {
      if (status.value == raw) return status;
    }
    return null;
  }

  static List<CenterStatus> get filterOptions => CenterStatus.values;
}
