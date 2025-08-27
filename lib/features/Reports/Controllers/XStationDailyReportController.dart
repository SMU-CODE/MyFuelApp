import 'package:dio/dio.dart';
import 'package:my_fuel/features/Reports/Models/XStationDailyReportResponse.dart';
import 'package:my_fuel/shared/api/api_response_model.dart';
import 'package:my_fuel/shared/api/api_service.dart';
import 'package:my_fuel/shared/helper/MuLogger.dart';
import 'package:my_fuel/shared/helper/Parser.dart';

abstract class XStationRepository {
  Future<void> cacheDailyReports(List<XStationDailyInfo> reports);
  Future<List<XStationDailyInfo>> getCachedDailyReports({
    DateTime? date,
    int? stationId,
    int? fuelTypeId,
  });
}

class XStationDailyReportController {
  final XStationRepository repository;
  final ApiService apiService;

  XStationDailyReportController({
    required this.repository,
    required this.apiService,
  });

  Future<ApiResponse<List<XStationDailyInfo>>> getDailyReports({
    DateTime? date,
    int? stationId,
    int? fuelTypeId,
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'per_page': perPage.toString(),
        if (date != null) 'date': Parser.formatDateTime(date),
        if (stationId != null) 'station_id': stationId.toString(),
        if (fuelTypeId != null) 'fuel_type_id': fuelTypeId.toString(),
      };

      final response = await apiService.getList<XStationDailyInfo>(
        '/reporting/station-daily',
        XStationDailyInfo.fromJson,
        query: queryParams,
      );

      if (response.success && response.data != null) {
        await _cacheReports(response.data!);
        MuLogger.success('Successfully fetched daily reports');
      } else {
        MuLogger.warning('API request succeeded but no data received');
      }

      return response;
    } on DioException catch (e) {
      final errorMsg = 'Failed to get daily reports: ${e.message}';
      MuLogger.exception(e, e.stackTrace, errorMsg);
      return ApiResponse.fromDioException(e);
    } catch (e, stack) {
      final errorMsg = 'Unexpected error in getDailyReports';
      MuLogger.exception(e, stack, errorMsg);
      return ApiResponse.error('حدث خطأ غير متوقع أثناء جلب التقارير اليومية');
    }
  }

  Future<void> _cacheReports(List<XStationDailyInfo> reports) async {
    try {
      await repository.cacheDailyReports(reports);
      MuLogger.info('Successfully cached ${reports.length} reports');
    } catch (e, stack) {
      MuLogger.exception(e, stack, 'Failed to cache reports');
    }
  }

  Future<ApiResponse<List<XStationDailyInfo>>> getCachedDailyReports({
    DateTime? date,
    int? stationId,
    int? fuelTypeId,
  }) async {
    try {
      MuLogger.debug('Fetching cached daily reports');
      final reports = await repository.getCachedDailyReports(
        date: date,
        stationId: stationId,
        fuelTypeId: fuelTypeId,
      );

      return ApiResponse(
        success: true,
        statusCode: 200,
        message: 'تم جلب البيانات المخزنة مؤقتًا بنجاح',
        data: reports,
      );
    } catch (e, stack) {
      MuLogger.exception(e, stack, 'Failed to get cached reports');
      return ApiResponse.error('حدث خطأ أثناء جلب البيانات المخزنة مؤقتًا');
    }
  }
}
