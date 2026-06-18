/// Backend permission strings returned in the login `permissions` array.
enum AppPermission {
  all('permission.all'),
  manage('permission.manage'),
  customerView('customer.view'),
  customerCreate('customer.create'),
  customerEdit('customer.edit'),
  customerApprove('customer.approve'),
  centerView('center.view'),
  centerCreate('center.create'),
  emiCollect('emi.collect'),
  employeeView('employee.view'),
  employeeCreate('employee.create'),
  employeeEdit('employee.edit'),
  reportView('report.view'),
  notificationView('notification.view');

  const AppPermission(this.value);

  final String value;

  static AppPermission? fromValue(String? value) {
    if (value == null || value.isEmpty) return null;
    for (final permission in AppPermission.values) {
      if (permission.value == value) return permission;
    }
    return null;
  }

  static Set<AppPermission> fromValues(Iterable<String> values) {
    return values
        .map(fromValue)
        .whereType<AppPermission>()
        .toSet();
  }
}
