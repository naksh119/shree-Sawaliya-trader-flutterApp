// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'SSM Nexus';

  @override
  String get splashTitle => 'श्री सावलिया मल्टीट्रेड';

  @override
  String get home => 'होम';

  @override
  String get hello => 'नमस्ते';

  @override
  String get customers => 'ग्राहक';

  @override
  String get customer => 'ग्राहक';

  @override
  String get newCustomer => 'नया ग्राहक';

  @override
  String get centers => 'केंद्र';

  @override
  String get center => 'केंद्र';

  @override
  String get newCenter => 'नया केंद्र';

  @override
  String get employees => 'कर्मचारी';

  @override
  String get employee => 'कर्मचारी';

  @override
  String get newEmployee => 'नया कर्मचारी';

  @override
  String get editEmployeePatch => 'कर्मचारी संपादित करें';

  @override
  String get branches => 'शाखाएँ';

  @override
  String get branch => 'शाखा';

  @override
  String get newBranch => 'नई शाखा';

  @override
  String get editBranch => 'शाखा संपादित करें';

  @override
  String get reports => 'रिपोर्ट';

  @override
  String get more => 'अधिक';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get notifications => 'सूचनाएँ';

  @override
  String get logout => 'लॉग आउट';

  @override
  String get logOutQuestion => 'लॉग आउट करें?';

  @override
  String get logOutConfirmMessage =>
      'अपने खाते तक पहुँच के लिए आपको फिर से साइन इन करना होगा।';

  @override
  String get signedInAs => 'इस रूप में साइन इन';

  @override
  String get signedIn => 'साइन इन';

  @override
  String get role => 'भूमिका';

  @override
  String get overview => 'अवलोकन';

  @override
  String get analytics => 'विश्लेषण';

  @override
  String get analyticsUnavailable =>
      'आपकी भूमिका के लिए विश्लेषण उपलब्ध नहीं है।';

  @override
  String get accessDenied => 'पहुँच अस्वीकृत';

  @override
  String get accessDeniedMessage =>
      'आपके पास इस स्क्रीन को खोलने की अनुमति नहीं है।';

  @override
  String accessDeniedRequested(String route) {
    return 'अनुरोधित: $route';
  }

  @override
  String get accessDeniedHint =>
      'आपकी भूमिका में केवल निर्दिष्ट मॉड्यूल की पहुँच शामिल है। यदि आपको लगता है कि यह गलती है, तो प्रशासक से संपर्क करें।';

  @override
  String get backToDashboard => 'डैशबोर्ड पर वापस';

  @override
  String get switchToLightMode => 'लाइट मोड पर स्विच करें';

  @override
  String get switchToDarkMode => 'डार्क मोड पर स्विच करें';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get languageEnglish => 'EN';

  @override
  String get languageHindi => 'HI';

  @override
  String get emiCollection => 'EMI संग्रह';

  @override
  String get emiCollectionDescription => 'किस्त भुगतान दर्ज और ट्रैक करें।';

  @override
  String get reportsDescription => 'परिचालन रिपोर्ट और विश्लेषण।';

  @override
  String get moduleFutureRelease =>
      'यह मॉड्यूल भविष्य के संस्करण में बनाया जाएगा।';

  @override
  String get invalidBranchId => 'अमान्य शाखा ID।';

  @override
  String get invalidEmployeeId => 'अमान्य कर्मचारी ID।';

  @override
  String get invalidCustomerId => 'अमान्य ग्राहक ID।';

  @override
  String get invalidCenterId => 'अमान्य केंद्र ID।';

  @override
  String get welcomeBack => 'वापसी पर स्वागत है';

  @override
  String get signInSubtitle => 'SSM Nexus में साइन इन करें';

  @override
  String get emailAddress => 'ईमेल पता';

  @override
  String get enterYourEmail => 'अपना ईमेल दर्ज करें';

  @override
  String get password => 'पासवर्ड';

  @override
  String get enterYourPassword => 'अपना पासवर्ड दर्ज करें';

  @override
  String get login => 'लॉगिन';

  @override
  String get signingIn => 'साइन इन हो रहा है...';

  @override
  String get pleaseEnterEmail => 'कृपया अपना ईमेल दर्ज करें';

  @override
  String get enterValidEmail => 'मान्य ईमेल पता दर्ज करें';

  @override
  String get pleaseEnterPassword => 'कृपया अपना पासवर्ड दर्ज करें';

  @override
  String get somethingWentWrong => 'कुछ गलत हो गया। कृपया पुनः प्रयास करें।';

  @override
  String get retry => 'पुनः प्रयास';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get delete => 'हटाएँ';

  @override
  String get edit => 'संपादित करें';

  @override
  String get save => 'सहेजें';

  @override
  String get remove => 'हटाएँ';

  @override
  String get all => 'सभी';

  @override
  String get active => 'सक्रिय';

  @override
  String get inactive => 'निष्क्रिय';

  @override
  String get yes => 'हाँ';

  @override
  String get no => 'नहीं';

  @override
  String get required => 'आवश्यक';

  @override
  String get success => 'सफल';

  @override
  String get error => 'त्रुटि';

  @override
  String get filterByStatus => 'स्थिति के अनुसार फ़िल्टर';

  @override
  String get sessionUnavailable =>
      'सत्र उपलब्ध नहीं। कृपया फिर से साइन इन करें।';

  @override
  String get noSessionFound => 'कोई सत्र नहीं मिला। कृपया फिर से साइन इन करें।';

  @override
  String get account => 'खाता';

  @override
  String get userId => 'उपयोगकर्ता ID';

  @override
  String get superuser => 'सुपरयूज़र';

  @override
  String get accessToken => 'एक्सेस टोकन';

  @override
  String get employeeId => 'कर्मचारी ID';

  @override
  String get employeeCode => 'कर्मचारी कोड';

  @override
  String get linkedEmployee => 'लिंक किया गया कर्मचारी';

  @override
  String get noneSuperuserAccount => 'कोई नहीं (सुपरयूज़र खाता)';

  @override
  String permissionsCount(int count) {
    return 'अनुमतियाँ ($count)';
  }

  @override
  String get noGranularPermissions => 'कोई विस्तृत अनुमति निर्दिष्ट नहीं।';

  @override
  String get administrator => 'प्रशासक';

  @override
  String userNumber(int id) {
    return 'उपयोगकर्ता #$id';
  }

  @override
  String get markAllRead => 'सभी पढ़ा हुआ चिह्नित करें';

  @override
  String get notificationsNoAccess =>
      'आपकी भूमिका में सूचना पहुँच नहीं है। अपने प्रशासक से संपर्क करें।';

  @override
  String get notificationsInboxPending =>
      'बैकएंड API कनेक्ट होने पर सूचना इनबॉक्स यहाँ दिखेगा।';

  @override
  String get noNotificationsYet => 'अभी कोई सूचना नहीं।';

  @override
  String get notificationsApiPending =>
      'API अभी उपलब्ध नहीं। सूचनाएँ लाइव होने पर भूमिका-आधारित फ़िल्टरिंग तैयार है।';

  @override
  String get searchCustomersHint => 'नाम, मोबाइल या कोड से खोजें';

  @override
  String get searchEmployeesHint => 'नाम, कोड या ईमेल से खोजें';

  @override
  String get searchBranchesHint => 'नाम, कोड या शहर से खोजें';

  @override
  String get searchCentersHint => 'नाम या कोड से खोजें';

  @override
  String get searchApprovedCustomersHint => 'स्वीकृत ग्राहकों को खोजें';

  @override
  String get noCustomersFound => 'कोई ग्राहक नहीं मिला।';

  @override
  String get customerNotFound => 'ग्राहक नहीं मिला।';

  @override
  String get noCentersFound => 'कोई केंद्र नहीं मिला।';

  @override
  String get centerNotFound => 'केंद्र नहीं मिला।';

  @override
  String branchesCount(int count) {
    return '$count शाखाएँ';
  }

  @override
  String noBranchesFound(String status) {
    return 'कोई$status शाखा नहीं मिली।';
  }

  @override
  String noBranchesFoundForSearch(String status, String query) {
    return '\"$query\" के लिए कोई$status शाखा नहीं मिली।';
  }

  @override
  String noEmployeesFound(String status, String role, String branch) {
    return 'कोई$status$role$branch कर्मचारी नहीं मिला।';
  }

  @override
  String get allBranches => 'सभी शाखाएँ';

  @override
  String get statusSuffixActive => ' सक्रिय';

  @override
  String get statusSuffixInactive => ' निष्क्रिय';

  @override
  String get noOverviewMetrics =>
      'आपकी भूमिका के लिए कोई अवलोकन मेट्रिक उपलब्ध नहीं।';

  @override
  String get pendingEmi => 'लंबित EMI';

  @override
  String get collected => 'एकत्रित';

  @override
  String get customersByStatus => 'स्थिति के अनुसार ग्राहक';

  @override
  String get customersByStatusSubtitle => 'आवेदन पाइपलाइन विवरण';

  @override
  String get noCustomerDataYet => 'अभी कोई ग्राहक डेटा नहीं';

  @override
  String get emiStatus => 'EMI स्थिति';

  @override
  String get emiStatusSubtitle => 'किस्त संग्रह अवलोकन';

  @override
  String get noEmiDataYet => 'अभी कोई EMI डेटा नहीं';

  @override
  String get emiCollectionTrend => 'EMI संग्रह प्रवृत्ति';

  @override
  String get emiCollectionTrendSubtitle => 'मासिक संग्रह (पिछले 6 महीने)';

  @override
  String get noCollectionHistoryYet => 'अभी कोई संग्रह इतिहास नहीं';

  @override
  String get applicationOverview => 'आवेदन अवलोकन';

  @override
  String get applicationOverviewSubtitle => 'सभी मॉड्यूल में गणना';

  @override
  String get noModuleDataAvailable => 'कोई मॉड्यूल डेटा उपलब्ध नहीं';

  @override
  String get code => 'कोड';

  @override
  String get mobile => 'मोबाइल';

  @override
  String get email => 'ईमेल';

  @override
  String get branchLabel => 'शाखा';

  @override
  String get sourcedBy => 'स्रोत';

  @override
  String get created => 'बनाया गया';

  @override
  String get personalDetails => 'व्यक्तिगत विवरण';

  @override
  String get aadhaar => 'आधार';

  @override
  String get aadhaarNumber => 'आधार नंबर';

  @override
  String get pan => 'PAN';

  @override
  String get dateOfBirth => 'जन्म तिथि';

  @override
  String get gender => 'लिंग';

  @override
  String get selectGender => 'लिंग चुनें';

  @override
  String get occupation => 'व्यवसाय';

  @override
  String get monthlyIncome => 'मासिक आय';

  @override
  String get monthlyIncomeWithSymbol => 'मासिक आय (₹)';

  @override
  String get address => 'पता';

  @override
  String get addressLine1 => 'पता पंक्ति 1';

  @override
  String get addressLine2 => 'पता पंक्ति 2';

  @override
  String get city => 'शहर';

  @override
  String get state => 'राज्य';

  @override
  String get pincode => 'पिनकोड';

  @override
  String get photos => 'फ़ोटो';

  @override
  String get customerImage => 'ग्राहक छवि';

  @override
  String get housePhoto => 'घर की फ़ोटो';

  @override
  String get familyMembers => 'परिवार के सदस्य';

  @override
  String get noFamilyMembers => 'कोई परिवार सदस्य नहीं जोड़ा गया।';

  @override
  String get maternalHouse => 'मातृ गृह';

  @override
  String get noMaternalHouseDetails => 'कोई मातृ गृह विवरण नहीं।';

  @override
  String get otherLoans => 'अन्य ऋण';

  @override
  String get noOtherLoans => 'कोई अन्य ऋण दर्ज नहीं।';

  @override
  String get loan => 'ऋण';

  @override
  String get amount => 'राशि';

  @override
  String amountWithValue(String value) {
    return 'राशि: $value';
  }

  @override
  String get outstanding => 'बकाया';

  @override
  String outstandingWithValue(String value) {
    return 'बकाया: $value';
  }

  @override
  String get guarantors => 'जमानतदार';

  @override
  String get noGuarantors => 'कोई जमानतदार नहीं जोड़ा गया।';

  @override
  String get documents => 'दस्तावेज़';

  @override
  String get noDocuments => 'कोई दस्तावेज़ अपलोड नहीं।';

  @override
  String get markApplied => 'आवेदित चिह्नित करें';

  @override
  String get sendForReview => 'समीक्षा के लिए भेजें';

  @override
  String get reject => 'अस्वीकार';

  @override
  String get approve => 'स्वीकृत';

  @override
  String get saving => 'सहेजा जा रहा है…';

  @override
  String statusUpdatedTo(String status) {
    return 'स्थिति $status में अपडेट';
  }

  @override
  String deleteEntityQuestion(String name) {
    return '$name हटाएँ?';
  }

  @override
  String get deleteCannotUndo =>
      'यह क्रिया पूर्ववत नहीं की जा सकती। हटाने का API जल्द जुड़ेगा।';

  @override
  String editEntityComingSoon(String name) {
    return '$name संपादित करें — API जल्द आएगा';
  }

  @override
  String deleteEntityComingSoon(String name) {
    return '$name हटाएँ — API जल्द आएगा';
  }

  @override
  String get customerStatusSourced => 'स्रोतित';

  @override
  String get customerStatusApplied => 'आवेदित';

  @override
  String get customerStatusUnderReview => 'समीक्षाधीन';

  @override
  String get customerStatusApproved => 'स्वीकृत';

  @override
  String get customerStatusRejected => 'अस्वीकृत';

  @override
  String get customerStatusActive => 'सक्रिय';

  @override
  String get customerStatusClosed => 'बंद';

  @override
  String get centerStatusPendingEmi => 'लंबित EMI';

  @override
  String get centerStatusActive => 'सक्रिय';

  @override
  String get centerStatusClosed => 'बंद';

  @override
  String get wizardStepCustomer => 'ग्राहक';

  @override
  String get wizardStepFamily => 'परिवार';

  @override
  String get wizardStepMaternalHouse => 'मातृ गृह';

  @override
  String get wizardStepOtherLoans => 'अन्य ऋण';

  @override
  String get wizardStepGuarantor => 'जमानतदार';

  @override
  String get wizardStepDocuments => 'दस्तावेज़';

  @override
  String get uploadCustomerImage => 'ग्राहक छवि अपलोड करें।';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get uploadHousePhoto => 'ग्राहक के घर की फ़ोटो अपलोड करें।';

  @override
  String get addFamilyMember => 'परिवार का सदस्य जोड़ें।';

  @override
  String get name => 'नाम';

  @override
  String get relationship => 'संबंध';

  @override
  String get age => 'आयु';

  @override
  String get maternalHouseContactHint => 'मातृ गृह संपर्क और पता।';

  @override
  String get contactName => 'संपर्क नाम';

  @override
  String get contactMobile => 'संपर्क मोबाइल';

  @override
  String get recordExistingLoans => 'मौजूदा ऋण दर्ज करें।';

  @override
  String get lenderName => 'ऋणदाता का नाम';

  @override
  String get loanAmount => 'ऋण राशि';

  @override
  String get loanAmountWithSymbol => 'ऋण राशि (₹)';

  @override
  String get emiAmount => 'EMI राशि';

  @override
  String get emiAmountWithSymbol => 'EMI राशि (₹)';

  @override
  String get outstandingAmount => 'बकाया राशि';

  @override
  String get outstandingWithSymbol => 'बकाया (₹)';

  @override
  String get addGuarantor => 'जमानतदार जोड़ें।';

  @override
  String get documentTypeAadhaar => 'आधार';

  @override
  String get documentTypePan => 'PAN';

  @override
  String get documentTypePhoto => 'फ़ोटो';

  @override
  String get documentTypeOther => 'अन्य';

  @override
  String get customerImageRequired => 'ग्राहक छवि आवश्यक है';

  @override
  String get housePhotoRequired => 'घर की फ़ोटो आवश्यक है';

  @override
  String get dateOfBirthRequired => 'जन्म तिथि आवश्यक है';

  @override
  String get chooseDocument => 'कृपया एक दस्तावेज़ चुनें';

  @override
  String get branchCreateIntro =>
      'कर्मचारी असाइनमेंट और भुगतान QR सेटअप के लिए शाखा स्थान जोड़ें।';

  @override
  String get branchDetails => 'शाखा विवरण';

  @override
  String get branchName => 'शाखा का नाम';

  @override
  String get branchCode => 'शाखा कोड';

  @override
  String get location => 'स्थान';

  @override
  String get paymentQrCode => 'भुगतान QR कोड';

  @override
  String get createBranch => 'शाखा बनाएँ';

  @override
  String branchCreated(String name) {
    return 'शाखा $name बनाई गई।';
  }

  @override
  String get centerCreateIntro =>
      'स्वीकृत ग्राहकों को सोने या चाँदी उत्पाद और ऋण शर्तों के साथ समूहित करें।';

  @override
  String get centerDetails => 'केंद्र विवरण';

  @override
  String get centerName => 'केंद्र का नाम';

  @override
  String get centerNameHint => 'उदा. रतलाम समूह A';

  @override
  String get productType => 'उत्पाद प्रकार';

  @override
  String get productTypeGold => 'सोना';

  @override
  String get productTypeSilver => 'चाँदी';

  @override
  String get weight => 'वज़न';

  @override
  String weightGrams(String product) {
    return '$product वजन (ग्राम)';
  }

  @override
  String get weightHint => 'उदा. 25.500';

  @override
  String get purity => 'शुद्धता';

  @override
  String get purityGoldHint => 'उदा. 22K';

  @override
  String get puritySilverHint => 'उदा. 999';

  @override
  String get loanTerms => 'ऋण शर्तें';

  @override
  String get loanAmountSymbol => 'ऋण राशि (₹)';

  @override
  String get loanAmountHint => 'उदा. 500000';

  @override
  String get invalidAmount => 'अमान्य राशि';

  @override
  String get interestRate => 'ब्याज दर (%)';

  @override
  String get interestRateHint => 'उदा. 12';

  @override
  String get invalidRate => 'अमान्य दर';

  @override
  String get tenureMonths => 'अवधि (महीने)';

  @override
  String get tenureHint => 'उदा. 12';

  @override
  String get invalidTenure => 'अमान्य अवधि';

  @override
  String get emiAmountSymbol => 'EMI राशि (₹)';

  @override
  String get emiAmountHint => 'उदा. 45000';

  @override
  String get invalidEmi => 'अमान्य EMI';

  @override
  String get startDate => 'प्रारंभ तिथि';

  @override
  String get selectDate => 'तिथि चुनें';

  @override
  String get remarksOptional => 'टिप्पणी (वैकल्पिक)';

  @override
  String get centerRemarksHint => 'इस केंद्र के लिए कोई नोट';

  @override
  String get selectApprovedCustomers =>
      'इस केंद्र में शामिल करने के लिए स्वीकृत ग्राहक चुनें।';

  @override
  String selectedCount(int count) {
    return '$count चयनित';
  }

  @override
  String get noApprovedCustomers => 'कोई स्वीकृत ग्राहक नहीं मिला।';

  @override
  String get selectApprovedCustomerError => 'कम से कम एक स्वीकृत ग्राहक चुनें।';

  @override
  String centerCreated(String name) {
    return 'केंद्र $name बनाया गया।';
  }

  @override
  String get wizardStepCenterLoan => 'केंद्र और ऋण';

  @override
  String get wizardStepMembers => 'सदस्य';

  @override
  String get loanAndProduct => 'ऋण और उत्पाद';

  @override
  String get product => 'उत्पाद';

  @override
  String get emiSchedule => 'EMI अनुसूची';

  @override
  String membersCount(int count) {
    return 'सदस्य ($count)';
  }

  @override
  String get generateEmiSchedule => 'EMI अनुसूची बनाएँ';

  @override
  String get addMember => 'सदस्य जोड़ें';

  @override
  String get removeMemberQuestion => 'सदस्य हटाएँ?';

  @override
  String get memberAdded => 'सदस्य जोड़ा गया।';

  @override
  String get memberRemoved => 'सदस्य हटाया गया।';

  @override
  String emiScheduleGenerated(String name) {
    return '$name के लिए EMI अनुसूची बनाई गई।';
  }

  @override
  String get employeeStepPersonal => 'कर्मचारी और व्यक्तिगत';

  @override
  String get employeeStepAssessment => 'मूल्यांकन';

  @override
  String get employeeStepIdentity => 'पहचान और लॉगिन';

  @override
  String get employeeStepProfile => 'प्रोफ़ाइल';

  @override
  String get employeeStepEmploymentHistory => 'रोजगार इतिहास';

  @override
  String get employmentDetails => 'रोजगार विवरण';

  @override
  String get noRolesAvailable =>
      'कोई भूमिका उपलब्ध नहीं। अपना कनेक्शन जाँचें और पुनः प्रयास करें।';

  @override
  String get noBranchesForAssignment =>
      'असाइनमेंट के लिए कोई शाखा उपलब्ध नहीं।';

  @override
  String get employeeCodeRequired => 'कर्मचारी कोड आवश्यक है';

  @override
  String get employeeCodeFormat =>
      'अक्षर, संख्या, हाइफ़न या अंडरस्कोर उपयोग करें';

  @override
  String get firstNameRequired => 'पहला नाम आवश्यक है';

  @override
  String get lastNameRequired => 'अंतिम नाम आवश्यक है';

  @override
  String get fatherName => 'पिता का नाम';

  @override
  String get placeOfBirth => 'जन्म स्थान';

  @override
  String get maritalStatus => 'वैवाहिक स्थिति';

  @override
  String get nationality => 'राष्ट्रीयता';

  @override
  String get languagesKnown => 'ज्ञात भाषाएँ';

  @override
  String get membersInFamily => 'परिवार में सदस्य';

  @override
  String get assignmentAndAssessment => 'असाइनमेंट और मूल्यांकन';

  @override
  String get dateOfAppointment => 'नियुक्ति तिथि';

  @override
  String get dateOfJoining => 'जॉइनिंग तिथि';

  @override
  String get dateOfConfirmation => 'पुष्टि तिथि';

  @override
  String get payableFromDate => 'भुगतान योग्य तिथि';

  @override
  String get performanceAppraisal => 'प्रदर्शन मूल्यांकन';

  @override
  String get warningNotes => 'चेतावनी नोट';

  @override
  String get identityAndContact => 'पहचान और संपर्क';

  @override
  String get primaryMobile => 'प्राथमिक मोबाइल';

  @override
  String get secondaryMobile => 'द्वितीयक मोबाइल';

  @override
  String get mobileTenDigits => 'मोबाइल नंबर ठीक 10 अंकों का होना चाहिए';

  @override
  String get loginCredentials => 'लॉगिन क्रेडेंशियल';

  @override
  String get confirmPassword => 'पासवर्ड की पुष्टि';

  @override
  String get passwordRequired => 'पासवर्ड आवश्यक है';

  @override
  String get passwordMinLength => 'पासवर्ड कम से कम 8 अक्षर का होना चाहिए';

  @override
  String get passwordUppercase =>
      'पासवर्ड में कम से कम एक बड़ा अक्षर होना चाहिए';

  @override
  String get confirmPasswordRequired => 'पासवर्ड पुष्टि आवश्यक है';

  @override
  String get passwordsDoNotMatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get presentAddress => 'वर्तमान पता';

  @override
  String get permanentAddressSame => 'स्थायी पता वर्तमान जैसा';

  @override
  String get permanentAddress => 'स्थायी पता';

  @override
  String get healthAndQualifications => 'स्वास्थ्य और योग्यता';

  @override
  String get heightCm => 'ऊँचाई (से.मी.)';

  @override
  String get heightMin => 'ऊँचाई कम से कम 30 से.मी. होनी चाहिए';

  @override
  String get weightKg => 'वजन (किग्रा)';

  @override
  String get bloodGroup => 'रक्त समूह';

  @override
  String get educationalQualifications => 'शैक्षिक योग्यता';

  @override
  String get professionalQualifications => 'व्यावसायिक योग्यता';

  @override
  String get remarks => 'टिप्पणी';

  @override
  String get emergencyContact => 'आपातकालीन संपर्क';

  @override
  String get relation => 'संबंध';

  @override
  String get contactNumber => 'संपर्क नंबर';

  @override
  String get employmentHistoryOptional =>
      'पिछले रोजगार रिकॉर्ड जोड़ें (वैकल्पिक)।';

  @override
  String get previous => 'पिछला';

  @override
  String get addRecord => 'रिकॉर्ड जोड़ें';

  @override
  String get savedRecords => 'सहेजे गए रिकॉर्ड';

  @override
  String ctcWithValue(String value) {
    return 'CTC: $value';
  }

  @override
  String employeeSaved(String name) {
    return 'कर्मचारी $name सहेजा गया।';
  }

  @override
  String get employeeRegistered => 'पंजीकृत';

  @override
  String employeeUpdated(String name) {
    return 'कर्मचारी $name अपडेट किया गया।';
  }

  @override
  String get employeeNotFound => 'कर्मचारी नहीं मिला।';

  @override
  String employeeDeleted(String name) {
    return 'कर्मचारी $name हटाया गया।';
  }

  @override
  String get deleteEmployeeQuestion => 'कर्मचारी हटाएँ?';

  @override
  String get saveChangesPatch => 'परिवर्तन सहेजें';

  @override
  String get roleAndBranch => 'भूमिका और शाखा';

  @override
  String get employmentDatesAssessment => 'रोजगार तिथियाँ और मूल्यांकन';

  @override
  String get passwordOptionalPatch => 'वर्तमान पासवर्ड रखने के लिए खाली छोड़ें';

  @override
  String get chooseNewPhotoHint => 'वर्तमान फ़ोटो बदलने के लिए नई छवि चुनें।';

  @override
  String get uploadProfilePhoto => 'प्रोफ़ाइल फ़ोटो अपलोड करें (वैकल्पिक)।';

  @override
  String get pleaseSelectRole => 'कृपया एक भूमिका चुनें।';

  @override
  String get pleaseSelectBranch => 'कृपया एक शाखा चुनें।';

  @override
  String get fatherNameRequired => 'पिता का नाम आवश्यक है';

  @override
  String get placeOfBirthRequired => 'जन्म स्थान आवश्यक है';

  @override
  String get dateOfAppointmentRequired => 'नियुक्ति तिथि आवश्यक है';

  @override
  String get dateOfJoiningRequired => 'जॉइनिंग तिथि आवश्यक है';

  @override
  String get presentAddressRequired => 'वर्तमान पता आवश्यक है';

  @override
  String get permanentAddressRequired => 'स्थायी पता आवश्यक है';

  @override
  String get contactNameRequired => 'संपर्क नाम आवश्यक है';

  @override
  String get relationRequired => 'संबंध आवश्यक है';

  @override
  String get organizationNameRequired => 'संगठन का नाम आवश्यक है';

  @override
  String get serviceFromRequired => 'सेवा प्रारंभ तिथि आवश्यक है';

  @override
  String get serviceToRequired => 'सेवा समाप्ति तिथि आवश्यक है';

  @override
  String get serviceToAfterFrom => 'सेवा समाप्ति, प्रारंभ के बाद होनी चाहिए';

  @override
  String get enterValidAmount => 'मान्य राशि दर्ज करें';

  @override
  String get profileId => 'प्रोफ़ाइल ID';

  @override
  String get status => 'स्थिति';

  @override
  String get deleted => 'हटाया गया';

  @override
  String get personal => 'व्यक्तिगत';

  @override
  String get identity => 'पहचान';

  @override
  String get contact => 'संपर्क';

  @override
  String get uploadPhotoOptional => 'फ़ोटो अपलोड करें (वैकल्पिक)।';

  @override
  String currentImageCaption(String label) {
    return 'वर्तमान $label';
  }

  @override
  String get imageOnFile => 'फ़ाइल में छवि';

  @override
  String get photoSelected => 'फ़ोटो चयनित';

  @override
  String get tapPreviewFullSize =>
      'पूर्ण आकार देखने के लिए पूर्वावलोकन पर टैप करें';

  @override
  String get changePhoto => 'फ़ोटो बदलें';

  @override
  String get choosePhoto => 'फ़ोटो चुनें';

  @override
  String get removePhoto => 'फ़ोटो हटाएँ';

  @override
  String get imagePreview => 'छवि पूर्वावलोकन';

  @override
  String get close => 'बंद करें';

  @override
  String get next => 'अगला';

  @override
  String get submit => 'जमा करें';

  @override
  String get finish => 'समाप्त';

  @override
  String get create => 'बनाएँ';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String stepProgress(int current, int total, String label) {
    return 'चरण $current / $total: $label';
  }

  @override
  String get branchNameHint => 'उदा. Head Office';

  @override
  String get branchCodeHint => 'उदा. HO या JAIPUR';

  @override
  String get branchCodeHintShort => 'उदा. JAI';

  @override
  String get cityHint => 'उदा. Ratlam';

  @override
  String get branchNameRequired => 'शाखा का नाम आवश्यक है';

  @override
  String get branchCodeRequired => 'शाखा कोड आवश्यक है';

  @override
  String get cityRequired => 'शहर आवश्यक है';

  @override
  String get addressHint => 'सड़क का पता या लैंडमार्क';

  @override
  String get branchQrUploadHint => 'शाखा भुगतान QR छवि अपलोड करें (वैकल्पिक)।';

  @override
  String get branchPutIntro =>
      'पूर्ण अपडेट PUT (सभी फ़ील्ड) के माध्यम से Save changes पर।';

  @override
  String get activeBranch => 'सक्रिय शाखा';

  @override
  String get branchVisibleUsable => 'शाखा दिखाई देती है और उपयोग योग्य है';

  @override
  String get branchIsInactive => 'शाखा निष्क्रिय है';

  @override
  String branchUpdated(String name) {
    return 'शाखा $name अपडेट की गई।';
  }

  @override
  String get branchNotFound => 'शाखा नहीं मिली।';

  @override
  String get branchNotFoundDeleted =>
      'शाखा नहीं मिली। हो सकता है हटा दी गई हो — सूची रीफ़्रेश करें।';

  @override
  String get record => 'रिकॉर्ड';

  @override
  String get updated => 'अपडेट';

  @override
  String get noPaymentQrUploaded => 'अभी तक कोई भुगतान QR अपलोड नहीं।';

  @override
  String get scanToPayBranch => 'इस शाखा पर भुगतान के लिए स्कैन करें।';

  @override
  String get paymentQrConfigured => 'भुगतान QR कॉन्फ़िगर';

  @override
  String get qrUploaded => 'QR अपलोड';

  @override
  String get branchDeleteConfirmMessage =>
      'यह शाखा स्थायी रूप से हटा देगा। यह क्रिया पूर्ववत नहीं हो सकती।';

  @override
  String branchDeleted(String name) {
    return 'शाखा $name हटाई गई।';
  }

  @override
  String get quickUpdatePatch => 'त्वरित अपडेट (PATCH)';

  @override
  String patchBranchDescription(Object id) {
    return 'PATCH /branches/api/\'$id\'/ — आंशिक अपडेट; केवल बदले फ़ील्ड भेजे जाते हैं।';
  }

  @override
  String get markInactive => 'निष्क्रिय करें';

  @override
  String get markActive => 'सक्रिय करें';

  @override
  String get physical => 'शारीरिक';

  @override
  String get roleCode => 'भूमिका कोड';

  @override
  String get roleId => 'भूमिका ID';

  @override
  String get roleDescription => 'भूमिका विवरण';

  @override
  String get branchCity => 'शाखा शहर';

  @override
  String get branchLocation => 'शाखा स्थान';

  @override
  String get permissionsSection => 'अनुमतियाँ';

  @override
  String get userPermissions => 'उपयोगकर्ता अनुमतियाँ';

  @override
  String get rolePermissions => 'भूमिका अनुमतियाँ';

  @override
  String get employeePhoto => 'कर्मचारी फ़ोटो';

  @override
  String get firstName => 'पहला नाम';

  @override
  String get lastName => 'उपनाम';

  @override
  String get employeePatchIntro =>
      'कर्मचारी विवरण अपडेट करें। केवल बदले गए फ़ील्ड सर्वर को भेजे जाते हैं।';

  @override
  String employeeCodeReadOnly(String code) {
    return 'कर्मचारी कोड: $code (केवल पढ़ने योग्य)';
  }

  @override
  String get employeeDeleteConfirmMessage =>
      'यह कर्मचारी को स्थायी रूप से हटा देगा। यह क्रिया पूर्ववत नहीं हो सकती।';

  @override
  String get previousEmployment => 'पिछला रोज़गार';

  @override
  String get organizationName => 'संगठन का नाम';

  @override
  String get designation => 'पद';

  @override
  String get serviceFrom => 'सेवा से';

  @override
  String get serviceTo => 'सेवा तक';

  @override
  String get annualCtc => 'वार्षिक CTC';

  @override
  String removeCenterMemberQuestion(String name) {
    return '$name को इस केंद्र से हटाएँ?';
  }

  @override
  String get emiGenerated => 'जनरेट';

  @override
  String get emiNotGenerated => 'जनरेट नहीं';

  @override
  String get noMembersLinked => 'अभी तक कोई सदस्य लिंक नहीं।';

  @override
  String get leader => 'नेता';

  @override
  String get noEligibleCustomers => 'कोई योग्य ग्राहक नहीं मिला।';

  @override
  String get uploadKycDocument => 'KYC दस्तावेज़ अपलोड करें।';

  @override
  String get documentType => 'दस्तावेज़ प्रकार';

  @override
  String get chooseFile => 'फ़ाइल चुनें';

  @override
  String get selectedPreview => 'चयनित पूर्वावलोकन';

  @override
  String get documentPreview => 'दस्तावेज़ पूर्वावलोकन';

  @override
  String get emiStatusPartial => 'आंशिक';

  @override
  String get emiStatusPaid => 'भुगतान';

  @override
  String get emiStatusOverdue => 'अतिदेय';

  @override
  String get emiStatusCancelled => 'रद्द';

  @override
  String get nationalityIndian => 'Indian';

  @override
  String get productGold => 'सोना';

  @override
  String get productSilver => 'चाँदी';

  @override
  String get employeeCodeHint => 'उदा. JAIPUR-EMP001';

  @override
  String get annualCtcHint => 'उदा. 180000.00';

  @override
  String get genderMale => 'पुरुष';

  @override
  String get genderFemale => 'महिला';

  @override
  String get maritalSingle => 'अविवाहित';

  @override
  String get maritalMarried => 'विवाहित';

  @override
  String get employeePhotoRequired => 'कर्मचारी फ़ोटो आवश्यक है';

  @override
  String get dateOfConfirmationRequired => 'पुष्टि तिथि आवश्यक है';

  @override
  String get payableFromDateRequired => 'भुगतान प्रारंभ तिथि आवश्यक है';

  @override
  String get locationRequired => 'स्थान आवश्यक है';

  @override
  String get paymentQrRequired => 'भुगतान QR कोड आवश्यक है';

  @override
  String get startDateRequired => 'प्रारंभ तिथि आवश्यक है';

  @override
  String get designationRequired => 'पद आवश्यक है';

  @override
  String get annualCtcRequired => 'वार्षिक CTC आवश्यक है';

  @override
  String get invalidNumber => 'मान्य संख्या दर्ज करें';

  @override
  String fieldRequired(String field) {
    return '$field आवश्यक है';
  }

  @override
  String get fullNameMaxLength => 'पूरा नाम 200 अक्षर या उससे कम होना चाहिए';

  @override
  String get mobileRequired => 'मोबाइल नंबर आवश्यक है';

  @override
  String get emailRequired => 'ईमेल आवश्यक है';

  @override
  String get aadhaarRequired => 'आधार नंबर आवश्यक है';

  @override
  String get aadhaarTwelveDigits => 'आधार नंबर ठीक 12 अंकों का होना चाहिए';

  @override
  String get panRequired => 'PAN आवश्यक है';

  @override
  String get panFormat => 'PAN ABCDE1234F प्रारूप में होना चाहिए';

  @override
  String get pincodeRequired => 'पिनकोड आवश्यक है';

  @override
  String get pincodeSixDigits => 'पिनकोड ठीक 6 अंकों का होना चाहिए';

  @override
  String fieldValidNumber(String field) {
    return '$field मान्य संख्या होनी चाहिए';
  }

  @override
  String fieldCannotBeNegative(String field) {
    return '$field ऋणात्मक नहीं हो सकता';
  }

  @override
  String get genderRequired => 'लिंग आवश्यक है';

  @override
  String get selectValidGender => 'मान्य लिंग चुनें';

  @override
  String get maritalStatusRequired => 'वैवाहिक स्थिति आवश्यक है';

  @override
  String get selectValidMaritalStatus => 'मान्य वैवाहिक स्थिति चुनें';

  @override
  String get ageRequired => 'आयु आवश्यक है';

  @override
  String get ageWholeNumber => 'आयु पूर्ण संख्या होनी चाहिए';

  @override
  String get ageRange => 'आयु 0 से 150 के बीच होनी चाहिए';

  @override
  String get nameRequired => 'नाम आवश्यक है';

  @override
  String get nameMaxLength => 'नाम 200 अक्षर या उससे कम होना चाहिए';

  @override
  String fieldLettersOnly(String field) {
    return '$field में केवल अक्षर होने चाहिए';
  }
}
