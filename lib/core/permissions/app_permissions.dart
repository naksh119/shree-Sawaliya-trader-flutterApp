/// Backend permission strings returned in the login `permissions` array.
abstract final class AppPermissions {
  static const all = 'permission.all';
  static const manage = 'permission.manage';

  static const customerView = 'customer.view';
  static const customerCreate = 'customer.create';
  static const customerEdit = 'customer.edit';
  static const customerApprove = 'customer.approve';

  static const centerView = 'center.view';
  static const centerCreate = 'center.create';

  static const emiCollect = 'emi.collect';

  static const employeeView = 'employee.view';

  static const notificationView = 'notification.view';
}
