import 'package:sawaliyatrader/core/api/api_client.dart';
import 'package:sawaliyatrader/core/api/api_error_parser.dart';
import 'package:sawaliyatrader/core/api/multipart_form.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/constants/api_config.dart';
import 'package:sawaliyatrader/core/customers/models/json_parse.dart';
import 'package:sawaliyatrader/core/employees/models/employee_detail.dart';
import 'package:sawaliyatrader/core/employees/models/employee_put_request.dart';
import 'package:sawaliyatrader/core/models/picked_image.dart';

/// Full employee PUT API module.
///
/// **API:** `PUT /employees/api/{id}/`
/// **Request type:** PUT (full update — all fields must be sent)
/// **Purpose:** Replace the entire employee record.
///
/// UI: [EmployeePutEditScreen]
class EmployeePutService {
  EmployeePutService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  /// PUT `/employees/api/{id}/` — full update; replaces all employee fields.
  Future<EmployeeDetail> putEmployee({
    required LoginResponse session,
    required int employeeId,
    required EmployeePutRequest request,
    PickedImage? employeePhoto,
  }) async {
    final Map<String, dynamic> body;

    if (employeePhoto != null && employeePhoto.isNotEmpty) {
      body = await _apiClient.putMultipart(
        ApiConfig.employeePath(employeeId),
        data: await buildMultipartFormData(
          fields: request.toJson(),
          files: {'employee_photo': employeePhoto},
        ),
      );
    } else {
      body = await _apiClient.put(
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
