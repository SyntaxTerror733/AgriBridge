/// Agribridge API Constants
/// Edit baseUrl here to point to your development server or Wi-Fi IP address.
class ApiConstants {
  /// Default base URL for Android Emulator is http://10.0.2.2:8000
  /// For physical devices over Wi-Fi, change to http://YOUR-LAPTOP-IP:8000
  static const String baseUrl = 'http://10.0.2.2:8000';

  // Endpoints
  static const String healthEndpoint = '$baseUrl/api/health';
  static const String landRegisterEndpoint = '$baseUrl/api/land/register';
  static const String landLookupEndpoint = '$baseUrl/api/land';
  static const String workerRegisterEndpoint = '$baseUrl/api/workers/register';
  static const String workerLookupEndpoint = '$baseUrl/api/workers';
  static const String advisorRecommendEndpoint = '$baseUrl/api/advisor/recommend';
  static const String advisorQueryEndpoint = '$baseUrl/api/advisor/query';
  static const String adminStatsEndpoint = '$baseUrl/api/admin/stats';
}
