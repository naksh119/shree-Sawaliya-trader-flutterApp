import 'package:dio/dio.dart';
import 'package:sawaliyatrader/core/api/multipart_form.dart';
import 'package:sawaliyatrader/core/api/api_client.dart';import 'package:sawaliyatrader/core/api/api_error_parser.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/constants/api_config.dart';
import 'package:sawaliyatrader/core/customers/models/customer_detail.dart';
import 'package:sawaliyatrader/core/customers/models/customer_document.dart';
import 'package:sawaliyatrader/core/customers/models/customer_list_response.dart';
import 'package:sawaliyatrader/core/customers/models/customer_status.dart';
import 'package:sawaliyatrader/core/customers/models/family_member.dart';
import 'package:sawaliyatrader/core/customers/models/guarantor.dart';
import 'package:sawaliyatrader/core/customers/models/json_parse.dart';
import 'package:sawaliyatrader/core/customers/models/maternal_house.dart';
import 'package:sawaliyatrader/core/customers/models/other_loan.dart';
import 'package:sawaliyatrader/core/models/picked_image.dart';
class CustomerService {
  CustomerService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<CustomerListResponse> fetchCustomers({
    required LoginResponse session,
    int page = 1,
    int pageSize = 20,
    String? search,
    CustomerStatus? status,
    String? branch,
  }) async {
    final body = await _apiClient.get(
      ApiConfig.customersPath,
      queryParameters: {
        'page': page,
        'page_size': pageSize,
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null) 'status': status.value,
        if (branch != null && branch.isNotEmpty) 'branch': branch,
      },
    );

    _ensureSuccess(body, 'Failed to load customers');
    return CustomerListResponse.fromJson(body);
  }

  Future<CustomerDetail> fetchCustomer({
    required LoginResponse session,
    required int customerId,
  }) async {
    final body = await _apiClient.get(ApiConfig.customerPath(customerId));
    _ensureSuccess(body, 'Failed to load customer');
    return CustomerDetail.fromJson(dataMap(body));
  }

  Future<CustomerDetail> createCustomer({
    required LoginResponse session,
    required Map<String, dynamic> payload,
    PickedImage? livePhoto,
    PickedImage? housePhoto,
  }) async {
    final files = <String, PickedImage>{};
    if (livePhoto != null && livePhoto.isNotEmpty) {
      files['live_photo'] = livePhoto;
    }
    if (housePhoto != null && housePhoto.isNotEmpty) {
      files['house_photo'] = housePhoto;
    }

    final Map<String, dynamic> body;
    if (multipartHasFiles(files)) {
      body = await _apiClient.postMultipart(
        ApiConfig.customersPath,
        data: await buildMultipartFormData(fields: payload, files: files),
      );
    } else {
      body = await _apiClient.post(
        ApiConfig.customersPath,
        data: payload,
      );
    }

    _ensureSuccess(body, 'Failed to create customer');
    return CustomerDetail.fromJson(dataMap(body));
  }
  Future<CustomerDetail> updateCustomer({
    required LoginResponse session,
    required int customerId,
    required Map<String, dynamic> payload,
  }) async {
    final body = await _apiClient.patch(
      ApiConfig.customerPath(customerId),
      data: payload,
    );
    _ensureSuccess(body, 'Failed to update customer');
    return CustomerDetail.fromJson(dataMap(body));
  }

  Future<CustomerDetail> updateStatus({
    required LoginResponse session,
    required int customerId,
    required CustomerStatus status,
  }) async {
    return updateCustomer(
      session: session,
      customerId: customerId,
      payload: {'status': status.value},
    );
  }

  Future<FamilyMember> addFamilyMember({
    required LoginResponse session,
    required int customerId,
    required Map<String, dynamic> payload,
  }) async {
    final body = await _apiClient.post(
      ApiConfig.customerFamilyMembersPath(customerId),
      data: payload,
    );
    _ensureSuccess(body, 'Failed to add family member');
    return FamilyMember.fromJson(dataMap(body));
  }

  Future<MaternalHouse> saveMaternalHouse({
    required LoginResponse session,
    required int customerId,
    required Map<String, dynamic> payload,
    bool exists = false,
  }) async {
    final path = ApiConfig.customerMaternalHousePath(customerId);

    final body = exists
        ? await _apiClient.patch(path, data: payload)
        : await _apiClient.post(path, data: payload);

    _ensureSuccess(body, 'Failed to save maternal house details');
    return MaternalHouse.fromJson(dataMap(body));
  }

  Future<OtherLoan> addOtherLoan({
    required LoginResponse session,
    required int customerId,
    required Map<String, dynamic> payload,
  }) async {
    final body = await _apiClient.post(
      ApiConfig.customerOtherLoansPath(customerId),
      data: payload,
    );
    _ensureSuccess(body, 'Failed to add other loan');
    return OtherLoan.fromJson(dataMap(body));
  }

  Future<Guarantor> addGuarantor({
    required LoginResponse session,
    required int customerId,
    required Map<String, dynamic> payload,
  }) async {
    final body = await _apiClient.post(
      ApiConfig.customerGuarantorsPath(customerId),
      data: payload,
    );
    _ensureSuccess(body, 'Failed to add guarantor');
    return Guarantor.fromJson(dataMap(body));
  }

  Future<CustomerDocument> uploadDocument({
    required LoginResponse session,
    required int customerId,
    required String documentType,
    required String filePath,
    String? fileName,
  }) async {
    final formData = FormData.fromMap({
      'document_type': documentType,
      'file': await MultipartFile.fromFile(
        filePath,
        filename: fileName,
      ),
    });

    final body = await _apiClient.postMultipart(
      ApiConfig.customerDocumentsPath(customerId),
      data: formData,
    );
    _ensureSuccess(body, 'Failed to upload document');
    return CustomerDocument.fromJson(dataMap(body));
  }

  void _ensureSuccess(Map<String, dynamic> body, String fallback) {
    if (body['success'] != true) {
      throw apiExceptionFromError(body['error'], fallback: fallback);
    }
  }
}
