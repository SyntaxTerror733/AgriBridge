import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../constants/strings.dart';
import '../models/land_model.dart';
import '../models/worker_model.dart';
import '../models/advisor_model.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class ApiService {
  static const Duration timeoutDuration = Duration(seconds: 10);

  static Future<LandModel> registerLand(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConstants.landRegisterEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 201) {
        return LandModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        final err = _parseErrorMessage(response);
        throw ApiException(err, response.statusCode);
      }
    } on SocketException {
      throw ApiException(AppStrings.serverConnectionError);
    } on TimeoutException {
      throw ApiException(AppStrings.serverConnectionError);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('${AppStrings.serverConnectionError} ($e)');
    }
  }

  static Future<LandModel> getLandStatus(String query) async {
    try {
      final response = await http
          .get(Uri.parse('${ApiConstants.landLookupEndpoint}/$query'))
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return LandModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else if (response.statusCode == 404) {
        throw ApiException(AppStrings.noRecordFound, 404);
      } else {
        final err = _parseErrorMessage(response);
        throw ApiException(err, response.statusCode);
      }
    } on SocketException {
      throw ApiException(AppStrings.serverConnectionError);
    } on TimeoutException {
      throw ApiException(AppStrings.serverConnectionError);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('${AppStrings.serverConnectionError} ($e)');
    }
  }

  static Future<WorkerModel> registerWorker(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConstants.workerRegisterEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 201) {
        return WorkerModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        final err = _parseErrorMessage(response);
        throw ApiException(err, response.statusCode);
      }
    } on SocketException {
      throw ApiException(AppStrings.serverConnectionError);
    } on TimeoutException {
      throw ApiException(AppStrings.serverConnectionError);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('${AppStrings.serverConnectionError} ($e)');
    }
  }

  static Future<WorkerModel> getWorkerStatus(String query) async {
    try {
      final response = await http
          .get(Uri.parse('${ApiConstants.workerLookupEndpoint}/$query'))
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return WorkerModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else if (response.statusCode == 404) {
        throw ApiException(AppStrings.noRecordFound, 404);
      } else {
        final err = _parseErrorMessage(response);
        throw ApiException(err, response.statusCode);
      }
    } on SocketException {
      throw ApiException(AppStrings.serverConnectionError);
    } on TimeoutException {
      throw ApiException(AppStrings.serverConnectionError);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('${AppStrings.serverConnectionError} ($e)');
    }
  }

  static Future<AdvisorResponseModel> getRecommendations({
    required String state,
    required String season,
    required String soil,
    required String water,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConstants.advisorRecommendEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'state': state,
              'season': season,
              'soil': soil,
              'water': water,
            }),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return AdvisorResponseModel.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        final err = _parseErrorMessage(response);
        throw ApiException(err, response.statusCode);
      }
    } on SocketException {
      throw ApiException(AppStrings.serverConnectionError);
    } on TimeoutException {
      throw ApiException(AppStrings.serverConnectionError);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('${AppStrings.serverConnectionError} ($e)');
    }
  }

  static Future<AdvisorQueryResponseModel> queryAdvisor(String question) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConstants.advisorQueryEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'question': question}),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return AdvisorQueryResponseModel.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        final err = _parseErrorMessage(response);
        throw ApiException(err, response.statusCode);
      }
    } on SocketException {
      throw ApiException(AppStrings.serverConnectionError);
    } on TimeoutException {
      throw ApiException(AppStrings.serverConnectionError);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('${AppStrings.serverConnectionError} ($e)');
    }
  }

  static String _parseErrorMessage(http.Response res) {
    try {
      final data = jsonDecode(utf8.decode(res.bodyBytes));
      if (data is Map && data.containsKey('detail')) {
        return data['detail'].toString();
      }
    } catch (_) {}
    return 'Server returned error (${res.statusCode})';
  }
}
