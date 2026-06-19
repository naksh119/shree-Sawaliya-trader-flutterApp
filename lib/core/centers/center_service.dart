import 'package:sawaliyatrader/core/api/api_client.dart';
import 'package:sawaliyatrader/core/api/api_exception.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/centers/models/center_create_request.dart';
import 'package:sawaliyatrader/core/centers/models/center_detail.dart';
import 'package:sawaliyatrader/core/centers/models/center_list_response.dart';
import 'package:sawaliyatrader/core/centers/models/center_member.dart';
import 'package:sawaliyatrader/core/centers/models/center_status.dart';
import 'package:sawaliyatrader/core/constants/api_config.dart';
import 'package:sawaliyatrader/core/customers/models/json_parse.dart';

class CenterService {
  CenterService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<CenterListResponse> fetchCenters({
    required LoginResponse session,
    int page = 1,
    int pageSize = 20,
    String? search,
    CenterStatus? status,
    String? branch,
  }) async {
    final body = await _apiClient.get(
      ApiConfig.centersPath,
      queryParameters: {
        'page': page,
        'page_size': pageSize,
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null) 'status': status.value,
        if (branch != null && branch.isNotEmpty) 'branch': branch,
      },
    );

    _ensureSuccess(body, 'Failed to load centers');
    return CenterListResponse.fromJson(body);
  }

  Future<CenterDetail> fetchCenter({
    required LoginResponse session,
    required int centerId,
  }) async {
    final body = await _apiClient.get(ApiConfig.centerPath(centerId));
    _ensureSuccess(body, 'Failed to load center');
    return CenterDetail.fromJson(dataMap(body));
  }

  Future<CenterDetail> createCenter({
    required LoginResponse session,
    required CenterCreateRequest request,
  }) async {
    final body = await _apiClient.post(
      ApiConfig.centersPath,
      data: request.toJson(),
    );
    _ensureSuccess(body, 'Failed to create center');
    return CenterDetail.fromJson(dataMap(body));
  }

  Future<CenterMember> addMember({
    required LoginResponse session,
    required int centerId,
    required int customerId,
  }) async {
    final body = await _apiClient.post(
      ApiConfig.centerMembersPath(centerId),
      data: {'customer_id': customerId},
    );
    _ensureSuccess(body, 'Failed to add member');
    return CenterMember.fromJson(dataMap(body));
  }

  Future<void> removeMember({
    required LoginResponse session,
    required int centerId,
    required int memberId,
  }) async {
    final body = await _apiClient.delete(
      ApiConfig.centerMemberPath(centerId, memberId),
    );
    _ensureSuccess(body, 'Failed to remove member');
  }

  Future<CenterDetail> generateEmi({
    required LoginResponse session,
    required int centerId,
  }) async {
    final body = await _apiClient.post(
      ApiConfig.centerGenerateEmiPath(centerId),
    );
    _ensureSuccess(body, 'Failed to generate EMI schedule');
    return CenterDetail.fromJson(dataMap(body));
  }

  void _ensureSuccess(Map<String, dynamic> body, String fallback) {
    if (body['success'] != true) {
      throw ApiException(body['error'] as String? ?? fallback);
    }
  }
}
