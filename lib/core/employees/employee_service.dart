import 'package:flutter/foundation.dart';
import 'package:sawaliyatrader/core/api/api_client.dart';
import 'package:sawaliyatrader/core/api/api_error_parser.dart';
import 'package:sawaliyatrader/core/auth/models/login_response.dart';
import 'package:sawaliyatrader/core/constants/api_config.dart';
import 'package:sawaliyatrader/core/customers/models/json_parse.dart';
import 'package:sawaliyatrader/core/employees/models/branch_option.dart';
import 'package:sawaliyatrader/core/employees/models/employee_detail.dart';
import 'package:sawaliyatrader/core/employees/models/employee_register_request.dart';
import 'package:sawaliyatrader/core/employees/models/employee_list_response.dart';
import 'package:sawaliyatrader/core/employees/models/role_option.dart';

class EmployeeService {
  EmployeeService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<EmployeeListResponse> fetchEmployees({
    required LoginResponse session,
    int page = 1,
    int pageSize = 20,
    String? search,
    bool? isActive,
    String? branch,
    int? role,
    String? roleCode,
  }) async {

    final queryParameters = {
      'page': page,
      'page_size': pageSize,
      if (search != null && search.isNotEmpty) 'search': search,
      if (isActive != null) 'is_active': isActive,
      if (branch != null && branch.isNotEmpty) 'branch': branch,
      if (role != null) 'role': role,
      if (roleCode != null && roleCode.isNotEmpty) 'role_code': roleCode,
    };

    debugPrint(
      '[Employees] GET ${ApiConfig.employeesPath} '
      'query=$queryParameters',
    );

    final body = await _apiClient.get(
      ApiConfig.employeesPath,
      queryParameters: queryParameters,
    );

    debugPrint(
      '[Employees] list response keys=${body.keys.toList()} '
      'success=${body['success']} '
      'dataType=${body['data']?.runtimeType}',
    );
    if (body['data'] is Map<String, dynamic>) {
      final data = body['data'] as Map<String, dynamic>;
      debugPrint(
        '[Employees] data keys=${data.keys.toList()} '
        'resultsType=${data['results']?.runtimeType} '
        'resultsLen=${data['results'] is List ? (data['results'] as List).length : 'n/a'}',
      );
    }

    _ensureSuccess(body, 'Failed to load employees');
    final parsed = EmployeeListResponse.fromJson(body);
    debugPrint(
      '[Employees] parsed items=${parsed.items.length} '
      'total=${parsed.total} page=${parsed.page}',
    );
    return parsed;
  }

  Future<EmployeeDetail> fetchEmployee({
    required LoginResponse session,
    required int employeeId,
  }) async {

    final body = await _apiClient.get(ApiConfig.employeePath(employeeId));
    _ensureSuccess(body, 'Failed to load employee');
    return EmployeeDetail.fromJson(dataMap(body));
  }

  Future<EmployeeDetail> registerEmployee({
    required LoginResponse session,
    required EmployeeRegisterRequest request,
  }) async {

    final body = await _apiClient.post(
      ApiConfig.employeeRegisterPath,
      data: request.toJson(),
    );
    _ensureSuccess(body, 'Failed to register employee');
    return EmployeeDetail.fromJson(dataMap(body));
  }

  @Deprecated('Use registerEmployee')
  Future<EmployeeDetail> createEmployee({
    required LoginResponse session,
    required Map<String, dynamic> payload,
  }) async {

    final body = await _apiClient.post(
      ApiConfig.employeesPath,
      data: payload,
    );
    _ensureSuccess(body, 'Failed to create employee');
    return EmployeeDetail.fromJson(dataMap(body));
  }

  Future<List<RoleOption>> fetchRoles({
    required LoginResponse session,
  }) async {

    try {
      final body = await _apiClient.get(ApiConfig.employeeRolesPath);
      _ensureSuccess(body, 'Failed to load roles');
      return _parseOptions(body, RoleOption.fromJson);
    } catch (_) {
      return RoleOption.fallbackRoles();
    }
  }

  Future<List<BranchOption>> fetchBranches({
    required LoginResponse session,
  }) async {

    final body = await _apiClient.get(
      ApiConfig.branchesPath,
      queryParameters: const {'page': 1, 'page_size': 200},
    );
    _ensureSuccess(body, 'Failed to load branches');
    return _parseOptions(body, BranchOption.fromJson);
  }

  List<T> _parseOptions<T>(
    Map<String, dynamic> body,
    T Function(Map<String, dynamic>) mapper,
  ) {
    final itemMaps = listMapsFromBody(body);
    if (itemMaps.isNotEmpty) {
      return itemMaps.map(mapper).toList();
    }

    final data = dataMap(body);
    final raw = data['roles'] ?? data['results'] ?? data['items'];
    if (raw is List) {
      return raw.whereType<Map<String, dynamic>>().map(mapper).toList();
    }

    return const [];
  }

  void _ensureSuccess(Map<String, dynamic> body, String fallback) {
    if (body['success'] != true) {
      throw apiExceptionFromError(body['error'], fallback: fallback);
    }
  }
}
