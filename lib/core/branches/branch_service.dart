import 'package:sawaliyatrader/core/api/api_client.dart';
import 'package:sawaliyatrader/core/api/api_error_parser.dart';
import 'package:sawaliyatrader/core/api/multipart_form.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/branches/branch_models.dart';
import 'package:sawaliyatrader/core/constants/api_config.dart';
import 'package:sawaliyatrader/core/customers/models/json_parse.dart';
import 'package:sawaliyatrader/core/models/picked_image.dart';

class BranchService {
  BranchService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  /// GET `/branches/api/` — Lists branches with pagination and filters.
  Future<BranchListResponse> fetchBranches({
    required LoginResponse session,
    int page = 1,
    int pageSize = 50,
    String? search,
    bool? isActive,
  }) async {
    final queryParameters = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
      if (search != null && search.isNotEmpty) 'search': search,
      if (isActive != null) 'is_active': isActive ? 'true' : 'false',
    };

    final body = await _apiClient.get(
      ApiConfig.branchesPath,
      queryParameters: queryParameters,
    );

    _ensureSuccess(body, 'Failed to load branches');
    return BranchListResponse.fromJson(body);
  }

  /// GET `/branches/api/{id}/` — Returns full detail for one branch.
  Future<BranchDto> fetchBranch({
    required LoginResponse session,
    required int branchId,
  }) async {
    final body = await _apiClient.get(ApiConfig.branchPath(branchId));
    _ensureSuccess(body, 'Failed to load branch');
    final payload = dataMap(body);
    final branchJson = asJsonMap(payload['branch']) ?? payload;
    return BranchDto.fromJson(branchJson);
  }

  /// POST `/branches/api/` — Creates a new branch.
  Future<BranchDto> createBranch({
    required LoginResponse session,
    required BranchCreateRequest request,
    PickedImage? paymentQrCode,
  }) async {
    final Map<String, dynamic> body;

    if (paymentQrCode != null && paymentQrCode.isNotEmpty) {
      body = await _apiClient.postMultipart(
        ApiConfig.branchesPath,
        data: await buildMultipartFormData(
          fields: request.toJson(),
          files: {'payment_qr_code': paymentQrCode},
        ),
      );
    } else {
      body = await _apiClient.post(
        ApiConfig.branchesPath,
        data: request.toJson(),
      );
    }

    _ensureSuccess(body, 'Failed to create branch');
    return _parseBranchBody(body);
  }

  /// DELETE `/branches/api/{id}/` — Deletes a branch.
  Future<void> deleteBranch({
    required LoginResponse session,
    required int branchId,
  }) async {
    final body = await _apiClient.delete(ApiConfig.branchPath(branchId));
    _ensureSuccess(body, 'Failed to delete branch');
  }

  /// PATCH `/branches/api/{id}/` — Updates branch fields.
  Future<BranchDto> patchBranch({
    required LoginResponse session,
    required int branchId,
    required BranchPatchRequest request,
    PickedImage? paymentQrCode,
  }) async {
    final Map<String, dynamic> body;

    if (paymentQrCode != null && paymentQrCode.isNotEmpty) {
      body = await _apiClient.patchMultipart(
        ApiConfig.branchPath(branchId),
        data: await buildMultipartFormData(
          fields: request.toJson(),
          files: {'payment_qr_code': paymentQrCode},
        ),
      );
    } else {
      body = await _apiClient.patch(
        ApiConfig.branchPath(branchId),
        data: request.toJson(),
      );
    }

    _ensureSuccess(body, 'Failed to update branch');
    return _parseBranchBody(body);
  }

  BranchDto _parseBranchBody(Map<String, dynamic> body) {
    final payload = dataMap(body);
    final branchJson = asJsonMap(payload['branch']) ?? payload;
    return BranchDto.fromJson(branchJson);
  }

  void _ensureSuccess(Map<String, dynamic> body, String fallback) {
    if (body['success'] != true) {
      throw apiExceptionFromError(body['error'], fallback: fallback);
    }
  }
}
