import 'package:sawaliyatrader/core/api/api_client.dart';
import 'package:sawaliyatrader/core/api/api_error_parser.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/branches/branch_models.dart';
import 'package:sawaliyatrader/core/constants/api_config.dart';
import 'package:sawaliyatrader/core/customers/models/json_parse.dart';

/// Optional branch PATCH API module.
///
/// **API:** `PATCH /branches/api/{id}/`
/// **Request type:** PATCH (partial update — only include fields you want to change)
/// **Purpose:** Update one or more branch fields without sending the full object.
///
/// To remove PATCH support later: delete this file and [BranchPatchSection].
class BranchPatchService {
  BranchPatchService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  /// PATCH `/branches/api/{id}/` — partial update with [fields] only.
  Future<BranchDto> patchBranch({
    required LoginResponse session,
    required int branchId,
    required Map<String, dynamic> fields,
  }) async {
    final body = await _apiClient.patch(
      ApiConfig.branchPath(branchId),
      data: fields,
    );
    _ensureSuccess(body, 'Failed to patch branch');
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

/// PATCH request bodies for `/branches/api/{id}/`.
abstract final class BranchPatchPayload {
  BranchPatchPayload._();

  /// Sends only `is_active` (and clears `is_deleted` when re-activating).
  static Map<String, dynamic> activeStatus(bool isActive) => {
        'is_active': isActive,
        if (isActive) 'is_deleted': false,
      };
}
