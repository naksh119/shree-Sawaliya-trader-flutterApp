/// Backend notification category codes.
abstract final class NotificationType {
  static const customerSourced = 'CUSTOMER_SOURCED';
  static const customerPendingApproval = 'CUSTOMER_PENDING_APPROVAL';
  static const customerApproved = 'CUSTOMER_APPROVED';
  static const customerRejected = 'CUSTOMER_REJECTED';
  static const centerCreated = 'CENTER_CREATED';
  static const emiDue = 'EMI_DUE';
  static const emiOverdue = 'EMI_OVERDUE';
  static const emiCollected = 'EMI_COLLECTED';
  static const employeeAssigned = 'EMPLOYEE_ASSIGNED';
  static const branchAnnouncement = 'BRANCH_ANNOUNCEMENT';
  static const system = 'SYSTEM';

  static const displayNames = <String, String>{
    customerSourced: 'Customer Sourced',
    customerPendingApproval: 'Pending Approval',
    customerApproved: 'Customer Approved',
    customerRejected: 'Customer Rejected',
    centerCreated: 'Center Created',
    emiDue: 'EMI Due',
    emiOverdue: 'EMI Overdue',
    emiCollected: 'EMI Collected',
    employeeAssigned: 'Employee Assigned',
    branchAnnouncement: 'Branch Announcement',
    system: 'System',
  };

  static String displayName(String typeCode) =>
      displayNames[typeCode] ?? typeCode;
}
