import 'package:sawaliyatrader/core/api/api_client.dart';
import 'package:sawaliyatrader/core/api/api_error_parser.dart';
import 'package:sawaliyatrader/core/api/multipart_form.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/constants/api_config.dart';
import 'package:sawaliyatrader/core/customers/models/json_parse.dart';
import 'package:sawaliyatrader/core/employees/models/employee_detail.dart';
import 'package:sawaliyatrader/core/employees/models/employee_patch_request.dart';
import 'package:sawaliyatrader/core/models/picked_image.dart';

/// Employee PATCH API module.
///
/// **API:** `PATCH /employees/api/{id}/`
/// **Request type:** PATCH (partial update — only sent fields are updated)
///
/// UI: [EmployeePatchScreen]
class EmployeePatchService {
  EmployeePatchService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  /// PATCH `/employees/api/{id}/` — partial update of employee fields.
  Future<EmployeeDetail> patchEmployee({
    required LoginResponse session,
    required int employeeId,
    required EmployeePatchRequest request,
    PickedImage? employeePhoto,
  }) async {
    final Map<String, dynamic> body;

    if (employeePhoto != null && employeePhoto.isNotEmpty) {
      body = await _apiClient.patchMultipart(
        ApiConfig.employeePath(employeeId),
        data: await buildMultipartFormData(
          fields: request.toJson(),
          files: {'employee_photo': employeePhoto},
        ),
      );
    } else {
      body = await _apiClient.patch(
        ApiConfig.employeePath(employeeId),
        data: request.toJson(),
      );
    }

    _ensureSuccess(body, 'Failed to update employee');
    return EmployeeDetail.fromJson(dataMap(body));
  }

  void _ensureSuccess(Map<String, dynamic> body, String fallback) {
    if (body['success'] != true) {
      throw apiExceptionFromError(body['error'], fallback: fallback);
    }
  }
}
