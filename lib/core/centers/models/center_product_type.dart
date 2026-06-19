enum CenterProductType {
  gold('GOLD', 'Gold'),
  silver('SILVER', 'Silver');

  const CenterProductType(this.value, this.label);

  final String value;
  final String label;

  static CenterProductType? fromValue(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    for (final type in CenterProductType.values) {
      if (type.value == raw) return type;
    }
    return null;
  }

  static List<CenterProductType> get options => CenterProductType.values;

  String get weightFieldKey =>
      this == CenterProductType.gold ? 'gold_weight' : 'silver_weight';
}
