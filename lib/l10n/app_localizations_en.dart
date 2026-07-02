// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SSM Nexus';

  @override
  String get splashTitle => 'SHREE SAWALIYA MULTITRADE';

  @override
  String get home => 'Home';

  @override
  String get hello => 'hello';

  @override
  String get customers => 'Customers';

  @override
  String get customer => 'Customer';

  @override
  String get newCustomer => 'New Customer';

  @override
  String get centers => 'Centers';

  @override
  String get center => 'Center';

  @override
  String get newCenter => 'New Center';

  @override
  String get employees => 'Employees';

  @override
  String get employee => 'Employee';

  @override
  String get newEmployee => 'New Employee';

  @override
  String get editEmployeePatch => 'Edit Employee';

  @override
  String get branches => 'Branches';

  @override
  String get branch => 'Branch';

  @override
  String get newBranch => 'New Branch';

  @override
  String get editBranch => 'Edit Branch';

  @override
  String get reports => 'Reports';

  @override
  String get more => 'More';

  @override
  String get profile => 'Profile';

  @override
  String get notifications => 'Notifications';

  @override
  String get logout => 'Log out';

  @override
  String get logOutQuestion => 'Log out?';

  @override
  String get logOutConfirmMessage =>
      'You will need to sign in again to access your account.';

  @override
  String get signedIn => 'Signed in';

  @override
  String get role => 'Role';

  @override
  String get overview => 'Overview';

  @override
  String get analytics => 'Analytics';

  @override
  String get analyticsUnavailable =>
      'Analytics are not available for your role.';

  @override
  String get accessDenied => 'Access Denied';

  @override
  String get accessDeniedMessage =>
      'You do not have permission to open this screen.';

  @override
  String accessDeniedRequested(String route) {
    return 'Requested: $route';
  }

  @override
  String get accessDeniedHint =>
      'Your role only includes access to assigned modules. Contact an administrator if you believe this is a mistake.';

  @override
  String get backToDashboard => 'Back to Dashboard';

  @override
  String get switchToLightMode => 'Switch to light mode';

  @override
  String get switchToDarkMode => 'Switch to dark mode';

  @override
  String get selectLanguage => 'Select language';

  @override
  String get languageEnglish => 'EN';

  @override
  String get languageHindi => 'HI';

  @override
  String get emiCollection => 'EMI Collection';

  @override
  String get emiCollectionDescription =>
      'Record and track installment payments.';

  @override
  String get reportsDescription => 'Operational reports and analytics.';

  @override
  String get moduleFutureRelease =>
      'This module will be built in a future release.';

  @override
  String get invalidBranchId => 'Invalid branch id.';

  @override
  String get invalidEmployeeId => 'Invalid employee id.';

  @override
  String get invalidCustomerId => 'Invalid customer id.';

  @override
  String get invalidCenterId => 'Invalid center id.';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInSubtitle => 'Sign in to SSM Nexus';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get password => 'Password';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get login => 'Login';

  @override
  String get signingIn => 'Signing in...';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get enterValidEmail => 'Enter a valid email address';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get somethingWentWrong => 'Something went wrong. Please try again.';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get save => 'Save';

  @override
  String get remove => 'Remove';

  @override
  String get all => 'All';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get required => 'Required';

  @override
  String get success => 'Success';

  @override
  String get error => 'Error';

  @override
  String get sessionUnavailable => 'Session unavailable. Please sign in again.';

  @override
  String get noSessionFound => 'No session found. Please sign in again.';

  @override
  String get account => 'Account';

  @override
  String get userId => 'User ID';

  @override
  String get superuser => 'Superuser';

  @override
  String get accessToken => 'Access token';

  @override
  String get employeeId => 'Employee ID';

  @override
  String get employeeCode => 'Employee code';

  @override
  String get linkedEmployee => 'Linked employee';

  @override
  String get noneSuperuserAccount => 'None (superuser account)';

  @override
  String permissionsCount(int count) {
    return 'Permissions ($count)';
  }

  @override
  String get noGranularPermissions => 'No granular permissions assigned.';

  @override
  String get administrator => 'Administrator';

  @override
  String userNumber(int id) {
    return 'User #$id';
  }

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get notificationsNoAccess =>
      'Your role does not have notification access. Contact your administrator.';

  @override
  String get notificationsInboxPending =>
      'Notification inbox will appear here once the backend API is connected.';

  @override
  String get noNotificationsYet => 'No notifications yet.';

  @override
  String get notificationsApiPending =>
      'API not available yet. Role-based filtering is ready for when notifications go live.';

  @override
  String get searchCustomersHint => 'Search by name, mobile, or code';

  @override
  String get searchEmployeesHint => 'Search by name, code, or email';

  @override
  String get searchBranchesHint => 'Search by name, code, or city';

  @override
  String get searchCentersHint => 'Search by name or code';

  @override
  String get searchApprovedCustomersHint => 'Search approved customers';

  @override
  String get noCustomersFound => 'No customers found.';

  @override
  String get customerNotFound => 'Customer not found.';

  @override
  String get noCentersFound => 'No centers found.';

  @override
  String get centerNotFound => 'Center not found.';

  @override
  String branchesCount(int count) {
    return '$count branches';
  }

  @override
  String noBranchesFound(String status) {
    return 'No$status branches found.';
  }

  @override
  String noBranchesFoundForSearch(String status, String query) {
    return 'No$status branches found for \"$query\".';
  }

  @override
  String noEmployeesFound(String status, String role, String branch) {
    return 'No$status$role$branch employees found.';
  }

  @override
  String get allBranches => 'All branches';

  @override
  String get noOverviewMetrics =>
      'No overview metrics available for your role.';

  @override
  String get pendingEmi => 'Pending EMI';

  @override
  String get collected => 'Collected';

  @override
  String get customersByStatus => 'Customers by Status';

  @override
  String get customersByStatusSubtitle => 'Application pipeline breakdown';

  @override
  String get noCustomerDataYet => 'No customer data yet';

  @override
  String get emiStatus => 'EMI Status';

  @override
  String get emiStatusSubtitle => 'Installment collection overview';

  @override
  String get noEmiDataYet => 'No EMI data yet';

  @override
  String get emiCollectionTrend => 'EMI Collection Trend';

  @override
  String get emiCollectionTrendSubtitle =>
      'Monthly collections (last 6 months)';

  @override
  String get noCollectionHistoryYet => 'No collection history yet';

  @override
  String get applicationOverview => 'Application Overview';

  @override
  String get applicationOverviewSubtitle => 'Counts across all modules';

  @override
  String get noModuleDataAvailable => 'No module data available';

  @override
  String get code => 'Code';

  @override
  String get mobile => 'Mobile';

  @override
  String get email => 'Email';

  @override
  String get branchLabel => 'Branch';

  @override
  String get sourcedBy => 'Sourced by';

  @override
  String get created => 'Created';

  @override
  String get personalDetails => 'Personal Details';

  @override
  String get aadhaar => 'Aadhaar';

  @override
  String get aadhaarNumber => 'Aadhaar number';

  @override
  String get pan => 'PAN';

  @override
  String get dateOfBirth => 'Date of birth';

  @override
  String get gender => 'Gender';

  @override
  String get selectGender => 'Select gender';

  @override
  String get occupation => 'Occupation';

  @override
  String get monthlyIncome => 'Monthly income';

  @override
  String get monthlyIncomeWithSymbol => 'Monthly income (₹)';

  @override
  String get address => 'Address';

  @override
  String get addressLine1 => 'Address line 1';

  @override
  String get addressLine2 => 'Address line 2';

  @override
  String get city => 'City';

  @override
  String get state => 'State';

  @override
  String get pincode => 'Pincode';

  @override
  String get photos => 'Photos';

  @override
  String get customerImage => 'Customer image';

  @override
  String get housePhoto => 'House photo';

  @override
  String get familyMembers => 'Family Members';

  @override
  String get noFamilyMembers => 'No family members added.';

  @override
  String get maternalHouse => 'Maternal House';

  @override
  String get noMaternalHouseDetails => 'No maternal house details.';

  @override
  String get otherLoans => 'Other Loans';

  @override
  String get noOtherLoans => 'No other loans recorded.';

  @override
  String get loan => 'Loan';

  @override
  String amountWithValue(String value) {
    return 'Amount: $value';
  }

  @override
  String outstandingWithValue(String value) {
    return 'Outstanding: $value';
  }

  @override
  String get guarantors => 'Guarantors';

  @override
  String get noGuarantors => 'No guarantors added.';

  @override
  String get documents => 'Documents';

  @override
  String get noDocuments => 'No documents uploaded.';

  @override
  String get markApplied => 'Mark Applied';

  @override
  String get sendForReview => 'Send for Review';

  @override
  String get reject => 'Reject';

  @override
  String get approve => 'Approve';

  @override
  String get saving => 'Saving…';

  @override
  String statusUpdatedTo(String status) {
    return 'Status updated to $status';
  }

  @override
  String deleteEntityQuestion(String name) {
    return 'Delete $name?';
  }

  @override
  String get deleteCannotUndo =>
      'This action cannot be undone. The delete API will be connected soon.';

  @override
  String editEntityComingSoon(String name) {
    return 'Edit $name — API coming soon';
  }

  @override
  String deleteEntityComingSoon(String name) {
    return 'Delete $name — API coming soon';
  }

  @override
  String get customerStatusSourced => 'Sourced';

  @override
  String get customerStatusApplied => 'Applied';

  @override
  String get customerStatusUnderReview => 'Under Review';

  @override
  String get customerStatusApproved => 'Approved';

  @override
  String get customerStatusRejected => 'Rejected';

  @override
  String get customerStatusActive => 'Active';

  @override
  String get customerStatusClosed => 'Closed';

  @override
  String get centerStatusPendingEmi => 'Pending EMI';

  @override
  String get centerStatusActive => 'Active';

  @override
  String get centerStatusClosed => 'Closed';

  @override
  String get wizardStepCustomer => 'Customer';

  @override
  String get wizardStepFamily => 'Family';

  @override
  String get wizardStepMaternalHouse => 'Maternal House';

  @override
  String get wizardStepOtherLoans => 'Other Loans';

  @override
  String get wizardStepGuarantor => 'Guarantor';

  @override
  String get wizardStepDocuments => 'Documents';

  @override
  String get uploadCustomerImage => 'Upload a customer image.';

  @override
  String get fullName => 'Full name';

  @override
  String get uploadHousePhoto => 'Upload a photo of the customer house.';

  @override
  String get addFamilyMember => 'Add a family member.';

  @override
  String get name => 'Name';

  @override
  String get relationship => 'Relationship';

  @override
  String get age => 'Age';

  @override
  String get maternalHouseContactHint => 'Maternal house contact and address.';

  @override
  String get contactName => 'Contact name';

  @override
  String get contactMobile => 'Contact mobile';

  @override
  String get recordExistingLoans => 'Record any existing loans.';

  @override
  String get lenderName => 'Lender name';

  @override
  String get loanAmount => 'Loan amount';

  @override
  String get loanAmountWithSymbol => 'Loan amount (₹)';

  @override
  String get emiAmount => 'EMI amount';

  @override
  String get emiAmountWithSymbol => 'EMI amount (₹)';

  @override
  String get outstandingAmount => 'Outstanding amount';

  @override
  String get outstandingWithSymbol => 'Outstanding (₹)';

  @override
  String get addGuarantor => 'Add a guarantor.';

  @override
  String get documentTypeAadhaar => 'Aadhaar';

  @override
  String get documentTypePan => 'PAN';

  @override
  String get documentTypePhoto => 'Photo';

  @override
  String get documentTypeOther => 'Other';

  @override
  String get customerImageRequired => 'Customer image is required';

  @override
  String get housePhotoRequired => 'House photo is required';

  @override
  String get dateOfBirthRequired => 'Date of birth is required';

  @override
  String get chooseDocument => 'Please choose a document';

  @override
  String get branchCreateIntro =>
      'Add a branch location for staff assignment and payment QR setup.';

  @override
  String get branchDetails => 'Branch details';

  @override
  String get branchName => 'Branch name';

  @override
  String get branchCode => 'Branch code';

  @override
  String get location => 'Location';

  @override
  String get paymentQrCode => 'Payment QR code';

  @override
  String get createBranch => 'Create branch';

  @override
  String branchCreated(String name) {
    return 'Branch $name created.';
  }

  @override
  String get centerCreateIntro =>
      'Group approved customers with gold or silver product and loan terms.';

  @override
  String get centerDetails => 'Center details';

  @override
  String get centerName => 'Center name';

  @override
  String get centerNameHint => 'e.g. Ratlam Group A';

  @override
  String get productType => 'Product type';

  @override
  String get productTypeGold => 'Gold';

  @override
  String get productTypeSilver => 'Silver';

  @override
  String get weight => 'Weight';

  @override
  String weightGrams(String product) {
    return '$product weight (grams)';
  }

  @override
  String get weightHint => 'e.g. 25.500';

  @override
  String get purity => 'Purity';

  @override
  String get purityGoldHint => 'e.g. 22K';

  @override
  String get puritySilverHint => 'e.g. 999';

  @override
  String get loanTerms => 'Loan terms';

  @override
  String get loanAmountSymbol => 'Loan amount (₹)';

  @override
  String get loanAmountHint => 'e.g. 500000';

  @override
  String get invalidAmount => 'Invalid amount';

  @override
  String get interestRate => 'Interest rate (%)';

  @override
  String get interestRateHint => 'e.g. 12';

  @override
  String get invalidRate => 'Invalid rate';

  @override
  String get tenureMonths => 'Tenure (months)';

  @override
  String get tenureHint => 'e.g. 12';

  @override
  String get invalidTenure => 'Invalid tenure';

  @override
  String get emiAmountSymbol => 'EMI amount (₹)';

  @override
  String get emiAmountHint => 'e.g. 45000';

  @override
  String get invalidEmi => 'Invalid EMI';

  @override
  String get startDate => 'Start date';

  @override
  String get selectDate => 'Select date';

  @override
  String get centerRemarksHint => 'Any notes for this center';

  @override
  String get selectApprovedCustomers =>
      'Select approved customers to include in this center.';

  @override
  String selectedCount(int count) {
    return '$count selected';
  }

  @override
  String get noApprovedCustomers => 'No approved customers found.';

  @override
  String get selectApprovedCustomerError =>
      'Select at least one approved customer.';

  @override
  String centerCreated(String name) {
    return 'Center $name created.';
  }

  @override
  String get wizardStepCenterLoan => 'Center & loan';

  @override
  String get wizardStepMembers => 'Members';

  @override
  String get loanAndProduct => 'Loan & product';

  @override
  String get product => 'Product';

  @override
  String get emiSchedule => 'EMI schedule';

  @override
  String membersCount(int count) {
    return 'Members ($count)';
  }

  @override
  String get generateEmiSchedule => 'Generate EMI schedule';

  @override
  String get addMember => 'Add member';

  @override
  String get removeMemberQuestion => 'Remove member?';

  @override
  String get memberAdded => 'Member added.';

  @override
  String get memberRemoved => 'Member removed.';

  @override
  String emiScheduleGenerated(String name) {
    return 'EMI schedule generated for $name.';
  }

  @override
  String get employeeStepPersonal => 'Employee & Personal';

  @override
  String get employeeStepAssessment => 'Assessment';

  @override
  String get employeeStepIdentity => 'Identity & Login';

  @override
  String get employeeStepProfile => 'Profile';

  @override
  String get employeeStepEmploymentHistory => 'Employment History';

  @override
  String get employmentDetails => 'Employment details';

  @override
  String get noRolesAvailable =>
      'No roles available. Check your connection and try again.';

  @override
  String get noBranchesForAssignment => 'No branches available for assignment.';

  @override
  String get employeeCodeRequired => 'Employee code is required';

  @override
  String get employeeCodeFormat =>
      'Use letters, numbers, hyphen, or underscore';

  @override
  String get firstNameRequired => 'First name is required';

  @override
  String get lastNameRequired => 'Last name is required';

  @override
  String get fatherName => 'Father name';

  @override
  String get placeOfBirth => 'Place of birth';

  @override
  String get maritalStatus => 'Marital status';

  @override
  String get nationality => 'Nationality';

  @override
  String get languagesKnown => 'Languages known';

  @override
  String get membersInFamily => 'Members in family';

  @override
  String get assignmentAndAssessment => 'Assignment & assessment';

  @override
  String get dateOfAppointment => 'Date of appointment';

  @override
  String get dateOfJoining => 'Date of joining';

  @override
  String get dateOfConfirmation => 'Date of confirmation';

  @override
  String get payableFromDate => 'Payable from date';

  @override
  String get performanceAppraisal => 'Performance appraisal';

  @override
  String get warningNotes => 'Warning notes';

  @override
  String get identityAndContact => 'Identity & contact';

  @override
  String get primaryMobile => 'Primary mobile';

  @override
  String get secondaryMobile => 'Secondary mobile';

  @override
  String get mobileTenDigits => 'Mobile number must be exactly 10 digits';

  @override
  String get loginCredentials => 'Login credentials';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordMinLength => 'Password must be at least 8 characters';

  @override
  String get passwordUppercase =>
      'Password must contain at least one uppercase letter';

  @override
  String get confirmPasswordRequired => 'Confirm password is required';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get presentAddress => 'Present address';

  @override
  String get permanentAddressSame => 'Permanent address same as present';

  @override
  String get permanentAddress => 'Permanent address';

  @override
  String get healthAndQualifications => 'Health & qualifications';

  @override
  String get heightCm => 'Height (cm)';

  @override
  String get heightMin => 'Height must be at least 30 cm';

  @override
  String get weightKg => 'Weight (kg)';

  @override
  String get bloodGroup => 'Blood group';

  @override
  String get educationalQualifications => 'Educational qualifications';

  @override
  String get professionalQualifications => 'Professional qualifications';

  @override
  String get remarks => 'Remarks';

  @override
  String get emergencyContact => 'Emergency contact';

  @override
  String get relation => 'Relation';

  @override
  String get contactNumber => 'Contact number';

  @override
  String get employmentHistoryOptional =>
      'Add previous employment records (optional).';

  @override
  String get previous => 'Previous';

  @override
  String get addRecord => 'Add record';

  @override
  String get savedRecords => 'Saved records';

  @override
  String ctcWithValue(String value) {
    return 'CTC: $value';
  }

  @override
  String employeeSaved(String name) {
    return 'Employee $name saved.';
  }

  @override
  String get employeeRegistered => 'registered';

  @override
  String employeeUpdated(String name) {
    return 'Employee $name updated.';
  }

  @override
  String get employeeNotFound => 'Employee not found.';

  @override
  String employeeDeleted(String name) {
    return 'Employee $name deleted.';
  }

  @override
  String get roleAndBranch => 'Role & branch';

  @override
  String get employmentDatesAssessment => 'Employment dates & assessment';

  @override
  String get passwordOptionalPatch => 'Leave blank to keep current password';

  @override
  String get chooseNewPhotoHint =>
      'Choose a new image to replace the current photo.';

  @override
  String get uploadProfilePhoto => 'Upload a profile photo (optional).';

  @override
  String get pleaseSelectRole => 'Please select a role.';

  @override
  String get pleaseSelectBranch => 'Please select a branch.';

  @override
  String get fatherNameRequired => 'Father name is required';

  @override
  String get placeOfBirthRequired => 'Place of birth is required';

  @override
  String get dateOfAppointmentRequired => 'Date of appointment is required';

  @override
  String get dateOfJoiningRequired => 'Date of joining is required';

  @override
  String get presentAddressRequired => 'Present address is required';

  @override
  String get permanentAddressRequired => 'Permanent address is required';

  @override
  String get contactNameRequired => 'Contact name is required';

  @override
  String get relationRequired => 'Relation is required';

  @override
  String get serviceToAfterFrom => 'Service to must be after service from';

  @override
  String get profileId => 'Profile ID';

  @override
  String get status => 'Status';

  @override
  String get deleted => 'Deleted';

  @override
  String get personal => 'Personal';

  @override
  String get identity => 'Identity';

  @override
  String get contact => 'Contact';

  @override
  String get uploadPhotoOptional => 'Upload a photo (optional).';

  @override
  String currentImageCaption(String label) {
    return 'Current $label';
  }

  @override
  String get imageOnFile => 'Image on file';

  @override
  String get photoSelected => 'Photo selected';

  @override
  String get tapPreviewFullSize => 'Tap preview to view full size';

  @override
  String get changePhoto => 'Change photo';

  @override
  String get choosePhoto => 'Choose photo';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get imagePreview => 'Image preview';

  @override
  String get close => 'Close';

  @override
  String get next => 'Next';

  @override
  String get finish => 'Finish';

  @override
  String get create => 'Create';

  @override
  String get loading => 'Loading...';

  @override
  String stepProgress(int current, int total, String label) {
    return 'Step $current of $total: $label';
  }

  @override
  String get branchNameHint => 'e.g. Head Office';

  @override
  String get branchCodeHint => 'e.g. HO or JAIPUR';

  @override
  String get branchCodeHintShort => 'e.g. JAI';

  @override
  String get cityHint => 'e.g. Ratlam';

  @override
  String get branchNameRequired => 'Branch name is required';

  @override
  String get branchCodeRequired => 'Branch code is required';

  @override
  String get cityRequired => 'City is required';

  @override
  String get addressHint => 'Street address or landmark';

  @override
  String get branchQrUploadHint =>
      'Upload the branch payment QR image (optional).';

  @override
  String get activeBranch => 'Active branch';

  @override
  String get branchVisibleUsable => 'Branch is visible and usable';

  @override
  String get branchIsInactive => 'Branch is inactive';

  @override
  String branchUpdated(String name) {
    return 'Branch $name updated.';
  }

  @override
  String get branchNotFound => 'Branch not found.';

  @override
  String get record => 'Record';

  @override
  String get updated => 'Updated';

  @override
  String get noPaymentQrUploaded => 'No payment QR code uploaded yet.';

  @override
  String get scanToPayBranch => 'Scan to pay at this branch.';

  @override
  String get paymentQrConfigured => 'Payment QR configured';

  @override
  String get qrUploaded => 'QR uploaded';

  @override
  String get branchDeleteConfirmMessage =>
      'This will permanently remove the branch. This action cannot be undone.';

  @override
  String branchDeleted(String name) {
    return 'Branch $name deleted.';
  }

  @override
  String get physical => 'Physical';

  @override
  String get roleCode => 'Role code';

  @override
  String get roleId => 'Role ID';

  @override
  String get roleDescription => 'Role description';

  @override
  String get branchCity => 'Branch city';

  @override
  String get branchLocation => 'Branch location';

  @override
  String get permissionsSection => 'Permissions';

  @override
  String get userPermissions => 'User permissions';

  @override
  String get rolePermissions => 'Role permissions';

  @override
  String get employeePhoto => 'Employee photo';

  @override
  String get firstName => 'First name';

  @override
  String get lastName => 'Last name';

  @override
  String get employeePatchIntro =>
      'Update employee details. Only changed fields are sent to the server.';

  @override
  String employeeCodeReadOnly(String code) {
    return 'Employee code: $code (read-only)';
  }

  @override
  String get employeeDeleteConfirmMessage =>
      'This will permanently remove the employee. This action cannot be undone.';

  @override
  String get previousEmployment => 'Previous employment';

  @override
  String get organizationName => 'Organization name';

  @override
  String get designation => 'Designation';

  @override
  String get serviceFrom => 'Service from';

  @override
  String get serviceTo => 'Service to';

  @override
  String get annualCtc => 'Annual CTC';

  @override
  String removeCenterMemberQuestion(String name) {
    return 'Remove $name from this center?';
  }

  @override
  String get emiGenerated => 'Generated';

  @override
  String get emiNotGenerated => 'Not generated';

  @override
  String get noMembersLinked => 'No members linked yet.';

  @override
  String get leader => 'Leader';

  @override
  String get noEligibleCustomers => 'No eligible customers found.';

  @override
  String get uploadKycDocument => 'Upload a KYC document.';

  @override
  String get documentType => 'Document type';

  @override
  String get chooseFile => 'Choose file';

  @override
  String get selectedPreview => 'Selected preview';

  @override
  String get documentPreview => 'Document preview';

  @override
  String get emiStatusPartial => 'Partial';

  @override
  String get emiStatusPaid => 'Paid';

  @override
  String get emiStatusOverdue => 'Overdue';

  @override
  String get emiStatusCancelled => 'Cancelled';

  @override
  String get employeeCodeHint => 'e.g. JAIPUR-EMP001';

  @override
  String get annualCtcHint => 'e.g. 180000.00';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get maritalSingle => 'Single';

  @override
  String get maritalMarried => 'Married';

  @override
  String get employeePhotoRequired => 'Employee photo is required';

  @override
  String get dateOfConfirmationRequired => 'Date of confirmation is required';

  @override
  String get payableFromDateRequired => 'Payable from date is required';

  @override
  String get locationRequired => 'Location is required';

  @override
  String get paymentQrRequired => 'Payment QR code is required';

  @override
  String get startDateRequired => 'Start date is required';

  @override
  String get invalidNumber => 'Enter a valid number';

  @override
  String fieldRequired(String field) {
    return '$field is required';
  }

  @override
  String get fullNameMaxLength => 'Full name must be 200 characters or fewer';

  @override
  String get mobileRequired => 'Mobile number is required';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get aadhaarRequired => 'Aadhaar number is required';

  @override
  String get aadhaarTwelveDigits => 'Aadhaar number must be exactly 12 digits';

  @override
  String get panRequired => 'PAN is required';

  @override
  String get panFormat => 'PAN must be in format ABCDE1234F';

  @override
  String get pincodeRequired => 'Pincode is required';

  @override
  String get pincodeSixDigits => 'Pincode must be exactly 6 digits';

  @override
  String fieldValidNumber(String field) {
    return '$field must be a valid number';
  }

  @override
  String fieldCannotBeNegative(String field) {
    return '$field cannot be negative';
  }

  @override
  String get genderRequired => 'Gender is required';

  @override
  String get selectValidGender => 'Select a valid gender';

  @override
  String get maritalStatusRequired => 'Marital status is required';

  @override
  String get selectValidMaritalStatus => 'Select a valid marital status';

  @override
  String get ageRequired => 'Age is required';

  @override
  String get ageWholeNumber => 'Age must be a whole number';

  @override
  String get ageRange => 'Age must be between 0 and 150';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get nameMaxLength => 'Name must be 200 characters or fewer';

  @override
  String fieldLettersOnly(String field) {
    return '$field must contain only letters';
  }
}
