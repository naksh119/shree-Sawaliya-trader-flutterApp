import 'package:sawaliyatrader/core/api/api_client.dart';
import 'package:sawaliyatrader/core/api/api_exception.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/branches/branch_models.dart';
import 'package:sawaliyatrader/core/constants/api_config.dart';
import 'package:sawaliyatrader/core/customers/models/json_parse.dart';

class BranchService {
  BranchService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

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

  Future<BranchDto> fetchBranch({
    required LoginResponse session,
    required int branchId,
  }) async {
    final body = await _apiClient.get(ApiConfig.branchPath(branchId));
    _ensureSuccess(body, 'Failed to load branch');
    return BranchDto.fromJson(dataMap(body));
  }

  Future<BranchDto> createBranch({
    required LoginResponse session,
    required BranchCreateRequest request,
  }) async {
    final body = await _apiClient.post(
      ApiConfig.branchesPath,
      data: request.toJson(),
    );
    _ensureSuccess(body, 'Failed to create branch');
    final created = dataMap(body);
    final branchJson = asJsonMap(created['branch']) ?? created;
    return BranchDto.fromJson(branchJson);
  }

  void _ensureSuccess(Map<String, dynamic> body, String fallback) {
    if (body['success'] != true) {
      throw ApiException(body['error'] as String? ?? fallback);
    }
  }
}
