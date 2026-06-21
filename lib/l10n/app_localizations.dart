import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Sawaliya Trader'**
  String get appTitle;

  /// No description provided for @splashTitle.
  ///
  /// In en, this message translates to:
  /// **'SHREE SAWALIYA MULTITRADE'**
  String get splashTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'hello'**
  String get hello;

  /// No description provided for @customers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @newCustomer.
  ///
  /// In en, this message translates to:
  /// **'New Customer'**
  String get newCustomer;

  /// No description provided for @centers.
  ///
  /// In en, this message translates to:
  /// **'Centers'**
  String get centers;

  /// No description provided for @center.
  ///
  /// In en, this message translates to:
  /// **'Center'**
  String get center;

  /// No description provided for @newCenter.
  ///
  /// In en, this message translates to:
  /// **'New Center'**
  String get newCenter;

  /// No description provided for @employees.
  ///
  /// In en, this message translates to:
  /// **'Employees'**
  String get employees;

  /// No description provided for @employee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get employee;

  /// No description provided for @newEmployee.
  ///
  /// In en, this message translates to:
  /// **'New Employee'**
  String get newEmployee;

  /// No description provided for @editEmployeePut.
  ///
  /// In en, this message translates to:
  /// **'Edit Employee (PUT)'**
  String get editEmployeePut;

  /// No description provided for @branches.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get branches;

  /// No description provided for @branch.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get branch;

  /// No description provided for @newBranch.
  ///
  /// In en, this message translates to:
  /// **'New Branch'**
  String get newBranch;

  /// No description provided for @editBranch.
  ///
  /// In en, this message translates to:
  /// **'Edit Branch'**
  String get editBranch;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @logOutQuestion.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logOutQuestion;

  /// No description provided for @logOutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'You will need to sign in again to access your account.'**
  String get logOutConfirmMessage;

  /// No description provided for @signedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as'**
  String get signedInAs;

  /// No description provided for @signedIn.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get signedIn;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @analyticsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Analytics are not available for your role.'**
  String get analyticsUnavailable;

  /// No description provided for @accessDenied.
  ///
  /// In en, this message translates to:
  /// **'Access Denied'**
  String get accessDenied;

  /// No description provided for @accessDeniedMessage.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to open this screen.'**
  String get accessDeniedMessage;

  /// No description provided for @accessDeniedRequested.
  ///
  /// In en, this message translates to:
  /// **'Requested: {route}'**
  String accessDeniedRequested(String route);

  /// No description provided for @accessDeniedHint.
  ///
  /// In en, this message translates to:
  /// **'Your role only includes access to assigned modules. Contact an administrator if you believe this is a mistake.'**
  String get accessDeniedHint;

  /// No description provided for @backToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Back to Dashboard'**
  String get backToDashboard;

  /// No description provided for @switchToLightMode.
  ///
  /// In en, this message translates to:
  /// **'Switch to light mode'**
  String get switchToLightMode;

  /// No description provided for @switchToDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Switch to dark mode'**
  String get switchToDarkMode;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'EN'**
  String get languageEnglish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'HI'**
  String get languageHindi;

  /// No description provided for @emiCollection.
  ///
  /// In en, this message translates to:
  /// **'EMI Collection'**
  String get emiCollection;

  /// No description provided for @emiCollectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Record and track installment payments.'**
  String get emiCollectionDescription;

  /// No description provided for @reportsDescription.
  ///
  /// In en, this message translates to:
  /// **'Operational reports and analytics.'**
  String get reportsDescription;

  /// No description provided for @moduleFutureRelease.
  ///
  /// In en, this message translates to:
  /// **'This module will be built in a future release.'**
  String get moduleFutureRelease;

  /// No description provided for @invalidBranchId.
  ///
  /// In en, this message translates to:
  /// **'Invalid branch id.'**
  String get invalidBranchId;

  /// No description provided for @invalidEmployeeId.
  ///
  /// In en, this message translates to:
  /// **'Invalid employee id.'**
  String get invalidEmployeeId;

  /// No description provided for @invalidCustomerId.
  ///
  /// In en, this message translates to:
  /// **'Invalid customer id.'**
  String get invalidCustomerId;

  /// No description provided for @invalidCenterId.
  ///
  /// In en, this message translates to:
  /// **'Invalid center id.'**
  String get invalidCenterId;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to Shree Sawaliya Multitrade'**
  String get signInSubtitle;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get signingIn;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get enterValidEmail;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @filterByStatus.
  ///
  /// In en, this message translates to:
  /// **'Filter by status'**
  String get filterByStatus;

  /// No description provided for @sessionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Session unavailable. Please sign in again.'**
  String get sessionUnavailable;

  /// No description provided for @noSessionFound.
  ///
  /// In en, this message translates to:
  /// **'No session found. Please sign in again.'**
  String get noSessionFound;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @userId.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get userId;

  /// No description provided for @superuser.
  ///
  /// In en, this message translates to:
  /// **'Superuser'**
  String get superuser;

  /// No description provided for @accessToken.
  ///
  /// In en, this message translates to:
  /// **'Access token'**
  String get accessToken;

  /// No description provided for @employeeId.
  ///
  /// In en, this message translates to:
  /// **'Employee ID'**
  String get employeeId;

  /// No description provided for @employeeCode.
  ///
  /// In en, this message translates to:
  /// **'Employee code'**
  String get employeeCode;

  /// No description provided for @linkedEmployee.
  ///
  /// In en, this message translates to:
  /// **'Linked employee'**
  String get linkedEmployee;

  /// No description provided for @noneSuperuserAccount.
  ///
  /// In en, this message translates to:
  /// **'None (superuser account)'**
  String get noneSuperuserAccount;

  /// No description provided for @permissionsCount.
  ///
  /// In en, this message translates to:
  /// **'Permissions ({count})'**
  String permissionsCount(int count);

  /// No description provided for @noGranularPermissions.
  ///
  /// In en, this message translates to:
  /// **'No granular permissions assigned.'**
  String get noGranularPermissions;

  /// No description provided for @administrator.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get administrator;

  /// No description provided for @userNumber.
  ///
  /// In en, this message translates to:
  /// **'User #{id}'**
  String userNumber(int id);

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @notificationsNoAccess.
  ///
  /// In en, this message translates to:
  /// **'Your role does not have notification access. Contact your administrator.'**
  String get notificationsNoAccess;

  /// No description provided for @notificationsInboxPending.
  ///
  /// In en, this message translates to:
  /// **'Notification inbox will appear here once the backend API is connected.'**
  String get notificationsInboxPending;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet.'**
  String get noNotificationsYet;

  /// No description provided for @notificationsApiPending.
  ///
  /// In en, this message translates to:
  /// **'API not available yet. Role-based filtering is ready for when notifications go live.'**
  String get notificationsApiPending;

  /// No description provided for @searchCustomersHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, mobile, or code'**
  String get searchCustomersHint;

  /// No description provided for @searchEmployeesHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, code, or email'**
  String get searchEmployeesHint;

  /// No description provided for @searchBranchesHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, code, or city'**
  String get searchBranchesHint;

  /// No description provided for @searchCentersHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name or code'**
  String get searchCentersHint;

  /// No description provided for @searchApprovedCustomersHint.
  ///
  /// In en, this message translates to:
  /// **'Search approved customers'**
  String get searchApprovedCustomersHint;

  /// No description provided for @noCustomersFound.
  ///
  /// In en, this message translates to:
  /// **'No customers found.'**
  String get noCustomersFound;

  /// No description provided for @customerNotFound.
  ///
  /// In en, this message translates to:
  /// **'Customer not found.'**
  String get customerNotFound;

  /// No description provided for @noCentersFound.
  ///
  /// In en, this message translates to:
  /// **'No centers found.'**
  String get noCentersFound;

  /// No description provided for @centerNotFound.
  ///
  /// In en, this message translates to:
  /// **'Center not found.'**
  String get centerNotFound;

  /// No description provided for @branchesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} branches'**
  String branchesCount(int count);

  /// No description provided for @noBranchesFound.
  ///
  /// In en, this message translates to:
  /// **'No{status} branches found.'**
  String noBranchesFound(String status);

  /// No description provided for @noBranchesFoundForSearch.
  ///
  /// In en, this message translates to:
  /// **'No{status} branches found for \"{query}\".'**
  String noBranchesFoundForSearch(String status, String query);

  /// No description provided for @noEmployeesFound.
  ///
  /// In en, this message translates to:
  /// **'No{status}{role}{branch} employees found.'**
  String noEmployeesFound(String status, String role, String branch);

  /// No description provided for @allBranches.
  ///
  /// In en, this message translates to:
  /// **'All branches'**
  String get allBranches;

  /// No description provided for @statusSuffixActive.
  ///
  /// In en, this message translates to:
  /// **' active'**
  String get statusSuffixActive;

  /// No description provided for @statusSuffixInactive.
  ///
  /// In en, this message translates to:
  /// **' inactive'**
  String get statusSuffixInactive;

  /// No description provided for @noOverviewMetrics.
  ///
  /// In en, this message translates to:
  /// **'No overview metrics available for your role.'**
  String get noOverviewMetrics;

  /// No description provided for @pendingEmi.
  ///
  /// In en, this message translates to:
  /// **'Pending EMI'**
  String get pendingEmi;

  /// No description provided for @collected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get collected;

  /// No description provided for @customersByStatus.
  ///
  /// In en, this message translates to:
  /// **'Customers by Status'**
  String get customersByStatus;

  /// No description provided for @customersByStatusSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Application pipeline breakdown'**
  String get customersByStatusSubtitle;

  /// No description provided for @noCustomerDataYet.
  ///
  /// In en, this message translates to:
  /// **'No customer data yet'**
  String get noCustomerDataYet;

  /// No description provided for @emiStatus.
  ///
  /// In en, this message translates to:
  /// **'EMI Status'**
  String get emiStatus;

  /// No description provided for @emiStatusSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Installment collection overview'**
  String get emiStatusSubtitle;

  /// No description provided for @noEmiDataYet.
  ///
  /// In en, this message translates to:
  /// **'No EMI data yet'**
  String get noEmiDataYet;

  /// No description provided for @emiCollectionTrend.
  ///
  /// In en, this message translates to:
  /// **'EMI Collection Trend'**
  String get emiCollectionTrend;

  /// No description provided for @emiCollectionTrendSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly collections (last 6 months)'**
  String get emiCollectionTrendSubtitle;

  /// No description provided for @noCollectionHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No collection history yet'**
  String get noCollectionHistoryYet;

  /// No description provided for @applicationOverview.
  ///
  /// In en, this message translates to:
  /// **'Application Overview'**
  String get applicationOverview;

  /// No description provided for @applicationOverviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Counts across all modules'**
  String get applicationOverviewSubtitle;

  /// No description provided for @noModuleDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No module data available'**
  String get noModuleDataAvailable;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// No description provided for @mobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobile;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @branchLabel.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get branchLabel;

  /// No description provided for @sourcedBy.
  ///
  /// In en, this message translates to:
  /// **'Sourced by'**
  String get sourcedBy;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get personalDetails;

  /// No description provided for @aadhaar.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar'**
  String get aadhaar;

  /// No description provided for @aadhaarNumber.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar number'**
  String get aadhaarNumber;

  /// No description provided for @pan.
  ///
  /// In en, this message translates to:
  /// **'PAN'**
  String get pan;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateOfBirth;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @occupation.
  ///
  /// In en, this message translates to:
  /// **'Occupation'**
  String get occupation;

  /// No description provided for @monthlyIncome.
  ///
  /// In en, this message translates to:
  /// **'Monthly income'**
  String get monthlyIncome;

  /// No description provided for @monthlyIncomeWithSymbol.
  ///
  /// In en, this message translates to:
  /// **'Monthly income (₹)'**
  String get monthlyIncomeWithSymbol;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @addressLine1.
  ///
  /// In en, this message translates to:
  /// **'Address line 1'**
  String get addressLine1;

  /// No description provided for @addressLine2.
  ///
  /// In en, this message translates to:
  /// **'Address line 2'**
  String get addressLine2;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @pincode.
  ///
  /// In en, this message translates to:
  /// **'Pincode'**
  String get pincode;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photos;

  /// No description provided for @customerImage.
  ///
  /// In en, this message translates to:
  /// **'Customer image'**
  String get customerImage;

  /// No description provided for @housePhoto.
  ///
  /// In en, this message translates to:
  /// **'House photo'**
  String get housePhoto;

  /// No description provided for @familyMembers.
  ///
  /// In en, this message translates to:
  /// **'Family Members'**
  String get familyMembers;

  /// No description provided for @noFamilyMembers.
  ///
  /// In en, this message translates to:
  /// **'No family members added.'**
  String get noFamilyMembers;

  /// No description provided for @maternalHouse.
  ///
  /// In en, this message translates to:
  /// **'Maternal House'**
  String get maternalHouse;

  /// No description provided for @noMaternalHouseDetails.
  ///
  /// In en, this message translates to:
  /// **'No maternal house details.'**
  String get noMaternalHouseDetails;

  /// No description provided for @otherLoans.
  ///
  /// In en, this message translates to:
  /// **'Other Loans'**
  String get otherLoans;

  /// No description provided for @noOtherLoans.
  ///
  /// In en, this message translates to:
  /// **'No other loans recorded.'**
  String get noOtherLoans;

  /// No description provided for @loan.
  ///
  /// In en, this message translates to:
  /// **'Loan'**
  String get loan;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @amountWithValue.
  ///
  /// In en, this message translates to:
  /// **'Amount: {value}'**
  String amountWithValue(String value);

  /// No description provided for @outstanding.
  ///
  /// In en, this message translates to:
  /// **'Outstanding'**
  String get outstanding;

  /// No description provided for @outstandingWithValue.
  ///
  /// In en, this message translates to:
  /// **'Outstanding: {value}'**
  String outstandingWithValue(String value);

  /// No description provided for @guarantors.
  ///
  /// In en, this message translates to:
  /// **'Guarantors'**
  String get guarantors;

  /// No description provided for @noGuarantors.
  ///
  /// In en, this message translates to:
  /// **'No guarantors added.'**
  String get noGuarantors;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @noDocuments.
  ///
  /// In en, this message translates to:
  /// **'No documents uploaded.'**
  String get noDocuments;

  /// No description provided for @markApplied.
  ///
  /// In en, this message translates to:
  /// **'Mark Applied'**
  String get markApplied;

  /// No description provided for @sendForReview.
  ///
  /// In en, this message translates to:
  /// **'Send for Review'**
  String get sendForReview;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get saving;

  /// No description provided for @statusUpdatedTo.
  ///
  /// In en, this message translates to:
  /// **'Status updated to {status}'**
  String statusUpdatedTo(String status);

  /// No description provided for @deleteEntityQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String deleteEntityQuestion(String name);

  /// No description provided for @deleteCannotUndo.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. The delete API will be connected soon.'**
  String get deleteCannotUndo;

  /// No description provided for @editEntityComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Edit {name} — API coming soon'**
  String editEntityComingSoon(String name);

  /// No description provided for @deleteEntityComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Delete {name} — API coming soon'**
  String deleteEntityComingSoon(String name);

  /// No description provided for @customerStatusSourced.
  ///
  /// In en, this message translates to:
  /// **'Sourced'**
  String get customerStatusSourced;

  /// No description provided for @customerStatusApplied.
  ///
  /// In en, this message translates to:
  /// **'Applied'**
  String get customerStatusApplied;

  /// No description provided for @customerStatusUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get customerStatusUnderReview;

  /// No description provided for @customerStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get customerStatusApproved;

  /// No description provided for @customerStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get customerStatusRejected;

  /// No description provided for @customerStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get customerStatusActive;

  /// No description provided for @customerStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get customerStatusClosed;

  /// No description provided for @centerStatusPendingEmi.
  ///
  /// In en, this message translates to:
  /// **'Pending EMI'**
  String get centerStatusPendingEmi;

  /// No description provided for @centerStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get centerStatusActive;

  /// No description provided for @centerStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get centerStatusClosed;

  /// No description provided for @wizardStepCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get wizardStepCustomer;

  /// No description provided for @wizardStepFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get wizardStepFamily;

  /// No description provided for @wizardStepMaternalHouse.
  ///
  /// In en, this message translates to:
  /// **'Maternal House'**
  String get wizardStepMaternalHouse;

  /// No description provided for @wizardStepOtherLoans.
  ///
  /// In en, this message translates to:
  /// **'Other Loans'**
  String get wizardStepOtherLoans;

  /// No description provided for @wizardStepGuarantor.
  ///
  /// In en, this message translates to:
  /// **'Guarantor'**
  String get wizardStepGuarantor;

  /// No description provided for @wizardStepDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get wizardStepDocuments;

  /// No description provided for @uploadCustomerImage.
  ///
  /// In en, this message translates to:
  /// **'Upload a customer image.'**
  String get uploadCustomerImage;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @uploadHousePhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload a photo of the customer house.'**
  String get uploadHousePhoto;

  /// No description provided for @addFamilyMember.
  ///
  /// In en, this message translates to:
  /// **'Add a family member.'**
  String get addFamilyMember;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @relationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get relationship;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @maternalHouseContactHint.
  ///
  /// In en, this message translates to:
  /// **'Maternal house contact and address.'**
  String get maternalHouseContactHint;

  /// No description provided for @contactName.
  ///
  /// In en, this message translates to:
  /// **'Contact name'**
  String get contactName;

  /// No description provided for @contactMobile.
  ///
  /// In en, this message translates to:
  /// **'Contact mobile'**
  String get contactMobile;

  /// No description provided for @recordExistingLoans.
  ///
  /// In en, this message translates to:
  /// **'Record any existing loans.'**
  String get recordExistingLoans;

  /// No description provided for @lenderName.
  ///
  /// In en, this message translates to:
  /// **'Lender name'**
  String get lenderName;

  /// No description provided for @loanAmount.
  ///
  /// In en, this message translates to:
  /// **'Loan amount'**
  String get loanAmount;

  /// No description provided for @loanAmountWithSymbol.
  ///
  /// In en, this message translates to:
  /// **'Loan amount (₹)'**
  String get loanAmountWithSymbol;

  /// No description provided for @emiAmount.
  ///
  /// In en, this message translates to:
  /// **'EMI amount'**
  String get emiAmount;

  /// No description provided for @emiAmountWithSymbol.
  ///
  /// In en, this message translates to:
  /// **'EMI amount (₹)'**
  String get emiAmountWithSymbol;

  /// No description provided for @outstandingAmount.
  ///
  /// In en, this message translates to:
  /// **'Outstanding amount'**
  String get outstandingAmount;

  /// No description provided for @outstandingWithSymbol.
  ///
  /// In en, this message translates to:
  /// **'Outstanding (₹)'**
  String get outstandingWithSymbol;

  /// No description provided for @addGuarantor.
  ///
  /// In en, this message translates to:
  /// **'Add a guarantor.'**
  String get addGuarantor;

  /// No description provided for @documentTypeAadhaar.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar'**
  String get documentTypeAadhaar;

  /// No description provided for @documentTypePan.
  ///
  /// In en, this message translates to:
  /// **'PAN'**
  String get documentTypePan;

  /// No description provided for @documentTypePhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get documentTypePhoto;

  /// No description provided for @documentTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get documentTypeOther;

  /// No description provided for @customerImageRequired.
  ///
  /// In en, this message translates to:
  /// **'Customer image is required'**
  String get customerImageRequired;

  /// No description provided for @housePhotoRequired.
  ///
  /// In en, this message translates to:
  /// **'House photo is required'**
  String get housePhotoRequired;

  /// No description provided for @dateOfBirthRequired.
  ///
  /// In en, this message translates to:
  /// **'Date of birth is required'**
  String get dateOfBirthRequired;

  /// No description provided for @chooseDocument.
  ///
  /// In en, this message translates to:
  /// **'Please choose a document'**
  String get chooseDocument;

  /// No description provided for @branchCreateIntro.
  ///
  /// In en, this message translates to:
  /// **'Add a branch location for staff assignment and payment QR setup.'**
  String get branchCreateIntro;

  /// No description provided for @branchDetails.
  ///
  /// In en, this message translates to:
  /// **'Branch details'**
  String get branchDetails;

  /// No description provided for @branchName.
  ///
  /// In en, this message translates to:
  /// **'Branch name'**
  String get branchName;

  /// No description provided for @branchCode.
  ///
  /// In en, this message translates to:
  /// **'Branch code'**
  String get branchCode;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @paymentQrCode.
  ///
  /// In en, this message translates to:
  /// **'Payment QR code'**
  String get paymentQrCode;

  /// No description provided for @createBranch.
  ///
  /// In en, this message translates to:
  /// **'Create branch'**
  String get createBranch;

  /// No description provided for @branchCreated.
  ///
  /// In en, this message translates to:
  /// **'Branch {name} created.'**
  String branchCreated(String name);

  /// No description provided for @centerCreateIntro.
  ///
  /// In en, this message translates to:
  /// **'Group approved customers with gold or silver product and loan terms.'**
  String get centerCreateIntro;

  /// No description provided for @centerDetails.
  ///
  /// In en, this message translates to:
  /// **'Center details'**
  String get centerDetails;

  /// No description provided for @centerName.
  ///
  /// In en, this message translates to:
  /// **'Center name'**
  String get centerName;

  /// No description provided for @centerNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Ratlam Group A'**
  String get centerNameHint;

  /// No description provided for @productType.
  ///
  /// In en, this message translates to:
  /// **'Product type'**
  String get productType;

  /// No description provided for @productTypeGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get productTypeGold;

  /// No description provided for @productTypeSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get productTypeSilver;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @weightGrams.
  ///
  /// In en, this message translates to:
  /// **'{product} weight (grams)'**
  String weightGrams(String product);

  /// No description provided for @weightHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 25.500'**
  String get weightHint;

  /// No description provided for @purity.
  ///
  /// In en, this message translates to:
  /// **'Purity'**
  String get purity;

  /// No description provided for @purityGoldHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 22K'**
  String get purityGoldHint;

  /// No description provided for @puritySilverHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 999'**
  String get puritySilverHint;

  /// No description provided for @loanTerms.
  ///
  /// In en, this message translates to:
  /// **'Loan terms'**
  String get loanTerms;

  /// No description provided for @loanAmountSymbol.
  ///
  /// In en, this message translates to:
  /// **'Loan amount (₹)'**
  String get loanAmountSymbol;

  /// No description provided for @loanAmountHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 500000'**
  String get loanAmountHint;

  /// No description provided for @invalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Invalid amount'**
  String get invalidAmount;

  /// No description provided for @interestRate.
  ///
  /// In en, this message translates to:
  /// **'Interest rate (%)'**
  String get interestRate;

  /// No description provided for @interestRateHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 12'**
  String get interestRateHint;

  /// No description provided for @invalidRate.
  ///
  /// In en, this message translates to:
  /// **'Invalid rate'**
  String get invalidRate;

  /// No description provided for @tenureMonths.
  ///
  /// In en, this message translates to:
  /// **'Tenure (months)'**
  String get tenureMonths;

  /// No description provided for @tenureHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 12'**
  String get tenureHint;

  /// No description provided for @invalidTenure.
  ///
  /// In en, this message translates to:
  /// **'Invalid tenure'**
  String get invalidTenure;

  /// No description provided for @emiAmountSymbol.
  ///
  /// In en, this message translates to:
  /// **'EMI amount (₹)'**
  String get emiAmountSymbol;

  /// No description provided for @emiAmountHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 45000'**
  String get emiAmountHint;

  /// No description provided for @invalidEmi.
  ///
  /// In en, this message translates to:
  /// **'Invalid EMI'**
  String get invalidEmi;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get startDate;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @remarksOptional.
  ///
  /// In en, this message translates to:
  /// **'Remarks (optional)'**
  String get remarksOptional;

  /// No description provided for @centerRemarksHint.
  ///
  /// In en, this message translates to:
  /// **'Any notes for this center'**
  String get centerRemarksHint;

  /// No description provided for @selectApprovedCustomers.
  ///
  /// In en, this message translates to:
  /// **'Select approved customers to include in this center.'**
  String get selectApprovedCustomers;

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedCount(int count);

  /// No description provided for @noApprovedCustomers.
  ///
  /// In en, this message translates to:
  /// **'No approved customers found.'**
  String get noApprovedCustomers;

  /// No description provided for @selectApprovedCustomerError.
  ///
  /// In en, this message translates to:
  /// **'Select at least one approved customer.'**
  String get selectApprovedCustomerError;

  /// No description provided for @centerCreated.
  ///
  /// In en, this message translates to:
  /// **'Center {name} created.'**
  String centerCreated(String name);

  /// No description provided for @wizardStepCenterLoan.
  ///
  /// In en, this message translates to:
  /// **'Center & loan'**
  String get wizardStepCenterLoan;

  /// No description provided for @wizardStepMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get wizardStepMembers;

  /// No description provided for @loanAndProduct.
  ///
  /// In en, this message translates to:
  /// **'Loan & product'**
  String get loanAndProduct;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @emiSchedule.
  ///
  /// In en, this message translates to:
  /// **'EMI schedule'**
  String get emiSchedule;

  /// No description provided for @membersCount.
  ///
  /// In en, this message translates to:
  /// **'Members ({count})'**
  String membersCount(int count);

  /// No description provided for @generateEmiSchedule.
  ///
  /// In en, this message translates to:
  /// **'Generate EMI schedule'**
  String get generateEmiSchedule;

  /// No description provided for @addMember.
  ///
  /// In en, this message translates to:
  /// **'Add member'**
  String get addMember;

  /// No description provided for @removeMemberQuestion.
  ///
  /// In en, this message translates to:
  /// **'Remove member?'**
  String get removeMemberQuestion;

  /// No description provided for @memberAdded.
  ///
  /// In en, this message translates to:
  /// **'Member added.'**
  String get memberAdded;

  /// No description provided for @memberRemoved.
  ///
  /// In en, this message translates to:
  /// **'Member removed.'**
  String get memberRemoved;

  /// No description provided for @emiScheduleGenerated.
  ///
  /// In en, this message translates to:
  /// **'EMI schedule generated for {name}.'**
  String emiScheduleGenerated(String name);

  /// No description provided for @employeeStepPersonal.
  ///
  /// In en, this message translates to:
  /// **'Employee & Personal'**
  String get employeeStepPersonal;

  /// No description provided for @employeeStepAssessment.
  ///
  /// In en, this message translates to:
  /// **'Assessment'**
  String get employeeStepAssessment;

  /// No description provided for @employeeStepIdentity.
  ///
  /// In en, this message translates to:
  /// **'Identity & Login'**
  String get employeeStepIdentity;

  /// No description provided for @employeeStepProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get employeeStepProfile;

  /// No description provided for @employeeStepEmploymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Employment History'**
  String get employeeStepEmploymentHistory;

  /// No description provided for @employmentDetails.
  ///
  /// In en, this message translates to:
  /// **'Employment details'**
  String get employmentDetails;

  /// No description provided for @noRolesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No roles available. Check your connection and try again.'**
  String get noRolesAvailable;

  /// No description provided for @noBranchesForAssignment.
  ///
  /// In en, this message translates to:
  /// **'No branches available for assignment.'**
  String get noBranchesForAssignment;

  /// No description provided for @employeeCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Employee code is required'**
  String get employeeCodeRequired;

  /// No description provided for @employeeCodeFormat.
  ///
  /// In en, this message translates to:
  /// **'Use letters, numbers, hyphen, or underscore'**
  String get employeeCodeFormat;

  /// No description provided for @firstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get firstNameRequired;

  /// No description provided for @lastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get lastNameRequired;

  /// No description provided for @fatherName.
  ///
  /// In en, this message translates to:
  /// **'Father name'**
  String get fatherName;

  /// No description provided for @placeOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Place of birth'**
  String get placeOfBirth;

  /// No description provided for @maritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Marital status'**
  String get maritalStatus;

  /// No description provided for @nationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get nationality;

  /// No description provided for @languagesKnown.
  ///
  /// In en, this message translates to:
  /// **'Languages known'**
  String get languagesKnown;

  /// No description provided for @membersInFamily.
  ///
  /// In en, this message translates to:
  /// **'Members in family'**
  String get membersInFamily;

  /// No description provided for @assignmentAndAssessment.
  ///
  /// In en, this message translates to:
  /// **'Assignment & assessment'**
  String get assignmentAndAssessment;

  /// No description provided for @dateOfAppointment.
  ///
  /// In en, this message translates to:
  /// **'Date of appointment'**
  String get dateOfAppointment;

  /// No description provided for @dateOfJoining.
  ///
  /// In en, this message translates to:
  /// **'Date of joining'**
  String get dateOfJoining;

  /// No description provided for @dateOfConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Date of confirmation'**
  String get dateOfConfirmation;

  /// No description provided for @payableFromDate.
  ///
  /// In en, this message translates to:
  /// **'Payable from date'**
  String get payableFromDate;

  /// No description provided for @performanceAppraisal.
  ///
  /// In en, this message translates to:
  /// **'Performance appraisal'**
  String get performanceAppraisal;

  /// No description provided for @warningNotes.
  ///
  /// In en, this message translates to:
  /// **'Warning notes'**
  String get warningNotes;

  /// No description provided for @identityAndContact.
  ///
  /// In en, this message translates to:
  /// **'Identity & contact'**
  String get identityAndContact;

  /// No description provided for @primaryMobile.
  ///
  /// In en, this message translates to:
  /// **'Primary mobile'**
  String get primaryMobile;

  /// No description provided for @secondaryMobile.
  ///
  /// In en, this message translates to:
  /// **'Secondary mobile'**
  String get secondaryMobile;

  /// No description provided for @mobileTenDigits.
  ///
  /// In en, this message translates to:
  /// **'Mobile number must be exactly 10 digits'**
  String get mobileTenDigits;

  /// No description provided for @loginCredentials.
  ///
  /// In en, this message translates to:
  /// **'Login credentials'**
  String get loginCredentials;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMinLength;

  /// No description provided for @passwordUppercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter'**
  String get passwordUppercase;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm password is required'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @presentAddress.
  ///
  /// In en, this message translates to:
  /// **'Present address'**
  String get presentAddress;

  /// No description provided for @permanentAddressSame.
  ///
  /// In en, this message translates to:
  /// **'Permanent address same as present'**
  String get permanentAddressSame;

  /// No description provided for @permanentAddress.
  ///
  /// In en, this message translates to:
  /// **'Permanent address'**
  String get permanentAddress;

  /// No description provided for @healthAndQualifications.
  ///
  /// In en, this message translates to:
  /// **'Health & qualifications'**
  String get healthAndQualifications;

  /// No description provided for @heightCm.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get heightCm;

  /// No description provided for @heightMin.
  ///
  /// In en, this message translates to:
  /// **'Height must be at least 30 cm'**
  String get heightMin;

  /// No description provided for @weightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightKg;

  /// No description provided for @bloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Blood group'**
  String get bloodGroup;

  /// No description provided for @educationalQualifications.
  ///
  /// In en, this message translates to:
  /// **'Educational qualifications'**
  String get educationalQualifications;

  /// No description provided for @professionalQualifications.
  ///
  /// In en, this message translates to:
  /// **'Professional qualifications'**
  String get professionalQualifications;

  /// No description provided for @remarks.
  ///
  /// In en, this message translates to:
  /// **'Remarks'**
  String get remarks;

  /// No description provided for @emergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency contact'**
  String get emergencyContact;

  /// No description provided for @relation.
  ///
  /// In en, this message translates to:
  /// **'Relation'**
  String get relation;

  /// No description provided for @contactNumber.
  ///
  /// In en, this message translates to:
  /// **'Contact number'**
  String get contactNumber;

  /// No description provided for @employmentHistoryOptional.
  ///
  /// In en, this message translates to:
  /// **'Add previous employment records (optional).'**
  String get employmentHistoryOptional;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @addRecord.
  ///
  /// In en, this message translates to:
  /// **'Add record'**
  String get addRecord;

  /// No description provided for @savedRecords.
  ///
  /// In en, this message translates to:
  /// **'Saved records'**
  String get savedRecords;

  /// No description provided for @ctcWithValue.
  ///
  /// In en, this message translates to:
  /// **'CTC: {value}'**
  String ctcWithValue(String value);

  /// No description provided for @employeeSaved.
  ///
  /// In en, this message translates to:
  /// **'Employee {name} saved.'**
  String employeeSaved(String name);

  /// No description provided for @employeeRegistered.
  ///
  /// In en, this message translates to:
  /// **'registered'**
  String get employeeRegistered;

  /// No description provided for @employeeUpdated.
  ///
  /// In en, this message translates to:
  /// **'Employee {name} updated.'**
  String employeeUpdated(String name);

  /// No description provided for @employeeNotFound.
  ///
  /// In en, this message translates to:
  /// **'Employee not found.'**
  String get employeeNotFound;

  /// No description provided for @employeeDeleted.
  ///
  /// In en, this message translates to:
  /// **'Employee {name} deleted.'**
  String employeeDeleted(String name);

  /// No description provided for @deleteEmployeeQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete employee?'**
  String get deleteEmployeeQuestion;

  /// No description provided for @saveChangesPut.
  ///
  /// In en, this message translates to:
  /// **'Save changes (PUT)'**
  String get saveChangesPut;

  /// No description provided for @roleAndBranch.
  ///
  /// In en, this message translates to:
  /// **'Role & branch'**
  String get roleAndBranch;

  /// No description provided for @employmentDatesAssessment.
  ///
  /// In en, this message translates to:
  /// **'Employment dates & assessment'**
  String get employmentDatesAssessment;

  /// No description provided for @passwordRequiredPut.
  ///
  /// In en, this message translates to:
  /// **'Required for full PUT update'**
  String get passwordRequiredPut;

  /// No description provided for @chooseNewPhotoHint.
  ///
  /// In en, this message translates to:
  /// **'Choose a new image to replace the current photo.'**
  String get chooseNewPhotoHint;

  /// No description provided for @uploadProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload a profile photo (optional).'**
  String get uploadProfilePhoto;

  /// No description provided for @pleaseSelectRole.
  ///
  /// In en, this message translates to:
  /// **'Please select a role.'**
  String get pleaseSelectRole;

  /// No description provided for @pleaseSelectBranch.
  ///
  /// In en, this message translates to:
  /// **'Please select a branch.'**
  String get pleaseSelectBranch;

  /// No description provided for @fatherNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Father name is required'**
  String get fatherNameRequired;

  /// No description provided for @placeOfBirthRequired.
  ///
  /// In en, this message translates to:
  /// **'Place of birth is required'**
  String get placeOfBirthRequired;

  /// No description provided for @dateOfAppointmentRequired.
  ///
  /// In en, this message translates to:
  /// **'Date of appointment is required'**
  String get dateOfAppointmentRequired;

  /// No description provided for @dateOfJoiningRequired.
  ///
  /// In en, this message translates to:
  /// **'Date of joining is required'**
  String get dateOfJoiningRequired;

  /// No description provided for @presentAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Present address is required'**
  String get presentAddressRequired;

  /// No description provided for @permanentAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Permanent address is required'**
  String get permanentAddressRequired;

  /// No description provided for @contactNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Contact name is required'**
  String get contactNameRequired;

  /// No description provided for @relationRequired.
  ///
  /// In en, this message translates to:
  /// **'Relation is required'**
  String get relationRequired;

  /// No description provided for @organizationNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Organization name is required'**
  String get organizationNameRequired;

  /// No description provided for @serviceFromRequired.
  ///
  /// In en, this message translates to:
  /// **'Service from date is required'**
  String get serviceFromRequired;

  /// No description provided for @serviceToRequired.
  ///
  /// In en, this message translates to:
  /// **'Service to date is required'**
  String get serviceToRequired;

  /// No description provided for @serviceToAfterFrom.
  ///
  /// In en, this message translates to:
  /// **'Service to must be after service from'**
  String get serviceToAfterFrom;

  /// No description provided for @enterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get enterValidAmount;

  /// No description provided for @profileId.
  ///
  /// In en, this message translates to:
  /// **'Profile ID'**
  String get profileId;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get deleted;

  /// No description provided for @personal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get personal;

  /// No description provided for @identity.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get identity;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @uploadPhotoOptional.
  ///
  /// In en, this message translates to:
  /// **'Upload a photo (optional).'**
  String get uploadPhotoOptional;

  /// No description provided for @currentImageCaption.
  ///
  /// In en, this message translates to:
  /// **'Current {label}'**
  String currentImageCaption(String label);

  /// No description provided for @imageOnFile.
  ///
  /// In en, this message translates to:
  /// **'Image on file'**
  String get imageOnFile;

  /// No description provided for @photoSelected.
  ///
  /// In en, this message translates to:
  /// **'Photo selected'**
  String get photoSelected;

  /// No description provided for @tapPreviewFullSize.
  ///
  /// In en, this message translates to:
  /// **'Tap preview to view full size'**
  String get tapPreviewFullSize;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get changePhoto;

  /// No description provided for @choosePhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose photo'**
  String get choosePhoto;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// No description provided for @imagePreview.
  ///
  /// In en, this message translates to:
  /// **'Image preview'**
  String get imagePreview;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @stepProgress.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}: {label}'**
  String stepProgress(int current, int total, String label);

  /// No description provided for @branchNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Head Office'**
  String get branchNameHint;

  /// No description provided for @branchCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. HO or JAIPUR'**
  String get branchCodeHint;

  /// No description provided for @branchCodeHintShort.
  ///
  /// In en, this message translates to:
  /// **'e.g. JAI'**
  String get branchCodeHintShort;

  /// No description provided for @cityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Ratlam'**
  String get cityHint;

  /// No description provided for @branchNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Branch name is required'**
  String get branchNameRequired;

  /// No description provided for @branchCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Branch code is required'**
  String get branchCodeRequired;

  /// No description provided for @cityRequired.
  ///
  /// In en, this message translates to:
  /// **'City is required'**
  String get cityRequired;

  /// No description provided for @addressHint.
  ///
  /// In en, this message translates to:
  /// **'Street address or landmark'**
  String get addressHint;

  /// No description provided for @branchQrUploadHint.
  ///
  /// In en, this message translates to:
  /// **'Upload the branch payment QR image (optional).'**
  String get branchQrUploadHint;

  /// No description provided for @branchPutIntro.
  ///
  /// In en, this message translates to:
  /// **'Full update uses PUT (all fields) via Save changes on the edit screen.'**
  String get branchPutIntro;

  /// No description provided for @activeBranch.
  ///
  /// In en, this message translates to:
  /// **'Active branch'**
  String get activeBranch;

  /// No description provided for @branchVisibleUsable.
  ///
  /// In en, this message translates to:
  /// **'Branch is visible and usable'**
  String get branchVisibleUsable;

  /// No description provided for @branchIsInactive.
  ///
  /// In en, this message translates to:
  /// **'Branch is inactive'**
  String get branchIsInactive;

  /// No description provided for @branchUpdated.
  ///
  /// In en, this message translates to:
  /// **'Branch {name} updated.'**
  String branchUpdated(String name);

  /// No description provided for @branchNotFound.
  ///
  /// In en, this message translates to:
  /// **'Branch not found.'**
  String get branchNotFound;

  /// No description provided for @branchNotFoundDeleted.
  ///
  /// In en, this message translates to:
  /// **'Branch not found. It may have been deleted — refresh the list.'**
  String get branchNotFoundDeleted;

  /// No description provided for @record.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get record;

  /// No description provided for @updated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updated;

  /// No description provided for @noPaymentQrUploaded.
  ///
  /// In en, this message translates to:
  /// **'No payment QR code uploaded yet.'**
  String get noPaymentQrUploaded;

  /// No description provided for @scanToPayBranch.
  ///
  /// In en, this message translates to:
  /// **'Scan to pay at this branch.'**
  String get scanToPayBranch;

  /// No description provided for @paymentQrConfigured.
  ///
  /// In en, this message translates to:
  /// **'Payment QR configured'**
  String get paymentQrConfigured;

  /// No description provided for @qrUploaded.
  ///
  /// In en, this message translates to:
  /// **'QR uploaded'**
  String get qrUploaded;

  /// No description provided for @branchDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove the branch. This action cannot be undone.'**
  String get branchDeleteConfirmMessage;

  /// No description provided for @branchDeleted.
  ///
  /// In en, this message translates to:
  /// **'Branch {name} deleted.'**
  String branchDeleted(String name);

  /// No description provided for @quickUpdatePatch.
  ///
  /// In en, this message translates to:
  /// **'Quick update (PATCH)'**
  String get quickUpdatePatch;

  /// No description provided for @patchBranchDescription.
  ///
  /// In en, this message translates to:
  /// **'PATCH /branches/api/\'{id}\'/ — partial update; only changed fields are sent.'**
  String patchBranchDescription(Object id);

  /// No description provided for @markInactive.
  ///
  /// In en, this message translates to:
  /// **'Mark inactive'**
  String get markInactive;

  /// No description provided for @markActive.
  ///
  /// In en, this message translates to:
  /// **'Mark active'**
  String get markActive;

  /// No description provided for @physical.
  ///
  /// In en, this message translates to:
  /// **'Physical'**
  String get physical;

  /// No description provided for @roleCode.
  ///
  /// In en, this message translates to:
  /// **'Role code'**
  String get roleCode;

  /// No description provided for @roleId.
  ///
  /// In en, this message translates to:
  /// **'Role ID'**
  String get roleId;

  /// No description provided for @roleDescription.
  ///
  /// In en, this message translates to:
  /// **'Role description'**
  String get roleDescription;

  /// No description provided for @branchCity.
  ///
  /// In en, this message translates to:
  /// **'Branch city'**
  String get branchCity;

  /// No description provided for @branchLocation.
  ///
  /// In en, this message translates to:
  /// **'Branch location'**
  String get branchLocation;

  /// No description provided for @permissionsSection.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get permissionsSection;

  /// No description provided for @userPermissions.
  ///
  /// In en, this message translates to:
  /// **'User permissions'**
  String get userPermissions;

  /// No description provided for @rolePermissions.
  ///
  /// In en, this message translates to:
  /// **'Role permissions'**
  String get rolePermissions;

  /// No description provided for @employeePhoto.
  ///
  /// In en, this message translates to:
  /// **'Employee photo'**
  String get employeePhoto;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @employeePutIntro.
  ///
  /// In en, this message translates to:
  /// **'Full update uses PUT with all employee fields.'**
  String get employeePutIntro;

  /// No description provided for @employeeCodeReadOnly.
  ///
  /// In en, this message translates to:
  /// **'Employee code: {code} (read-only)'**
  String employeeCodeReadOnly(String code);

  /// No description provided for @employeeDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove the employee. This action cannot be undone.'**
  String get employeeDeleteConfirmMessage;

  /// No description provided for @previousEmployment.
  ///
  /// In en, this message translates to:
  /// **'Previous employment'**
  String get previousEmployment;

  /// No description provided for @organizationName.
  ///
  /// In en, this message translates to:
  /// **'Organization name'**
  String get organizationName;

  /// No description provided for @designation.
  ///
  /// In en, this message translates to:
  /// **'Designation'**
  String get designation;

  /// No description provided for @serviceFrom.
  ///
  /// In en, this message translates to:
  /// **'Service from'**
  String get serviceFrom;

  /// No description provided for @serviceTo.
  ///
  /// In en, this message translates to:
  /// **'Service to'**
  String get serviceTo;

  /// No description provided for @annualCtc.
  ///
  /// In en, this message translates to:
  /// **'Annual CTC'**
  String get annualCtc;

  /// No description provided for @removeCenterMemberQuestion.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from this center?'**
  String removeCenterMemberQuestion(String name);

  /// No description provided for @emiGenerated.
  ///
  /// In en, this message translates to:
  /// **'Generated'**
  String get emiGenerated;

  /// No description provided for @emiNotGenerated.
  ///
  /// In en, this message translates to:
  /// **'Not generated'**
  String get emiNotGenerated;

  /// No description provided for @noMembersLinked.
  ///
  /// In en, this message translates to:
  /// **'No members linked yet.'**
  String get noMembersLinked;

  /// No description provided for @leader.
  ///
  /// In en, this message translates to:
  /// **'Leader'**
  String get leader;

  /// No description provided for @noEligibleCustomers.
  ///
  /// In en, this message translates to:
  /// **'No eligible customers found.'**
  String get noEligibleCustomers;

  /// No description provided for @uploadKycDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload a KYC document.'**
  String get uploadKycDocument;

  /// No description provided for @documentType.
  ///
  /// In en, this message translates to:
  /// **'Document type'**
  String get documentType;

  /// No description provided for @chooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose file'**
  String get chooseFile;

  /// No description provided for @selectedPreview.
  ///
  /// In en, this message translates to:
  /// **'Selected preview'**
  String get selectedPreview;

  /// No description provided for @documentPreview.
  ///
  /// In en, this message translates to:
  /// **'Document preview'**
  String get documentPreview;

  /// No description provided for @emiStatusPartial.
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get emiStatusPartial;

  /// No description provided for @emiStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get emiStatusPaid;

  /// No description provided for @emiStatusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get emiStatusOverdue;

  /// No description provided for @emiStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get emiStatusCancelled;

  /// No description provided for @nationalityIndian.
  ///
  /// In en, this message translates to:
  /// **'Indian'**
  String get nationalityIndian;

  /// No description provided for @productGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get productGold;

  /// No description provided for @productSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get productSilver;

  /// No description provided for @employeeCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. JAIPUR-EMP001'**
  String get employeeCodeHint;

  /// No description provided for @annualCtcHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 180000.00'**
  String get annualCtcHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
