import 'dart:developer';
import 'package:calender/core/network/network_service.dart';
import 'package:dio/dio.dart';
import 'dio_client.dart';
import 'api_result.dart';
import 'api_exceptions.dart';

// Base API Service class that uses DioClient
// It provides helper methods to make requests and handle errors centrally (simple mapping).
// More complex error handling should be done in error_handler.dart or repository layer.
class ApiService {
  final Dio _dio;
  final internet = NetworkService.instance.checkStatus();
  ApiService(DioClient dioClient) : _dio = dioClient.dio;

  // GET: جلب البيانات
  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic data) fromJson,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return Success(fromJson(response.data));
    } on DioException catch (e) {
      return Failure(_handleDioException(e));
    } catch (e) {
      return Failure(UnknownException(message: e.toString()));
    }
  }

  // POST: إضافة بيانات جديدة
  Future<ApiResult<T>> post<T>(
    String path,
    dynamic data, { // جعلنا البيانات dynamic لتقبل Map أو List
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic data) fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data, // تمرير الـ Body الفعلي هنا
        queryParameters: queryParameters,
        options: options,
      );
      return Success(fromJson(response.data));
    } on DioException catch (e) {
      return Failure(_handleDioException(e));
    } catch (e) {
      return Failure(UnknownException(message: e.toString()));
    }
  }

  // PUT: تحديث بيانات موجودة
  Future<ApiResult<T>> put<T>(
    String path,
    dynamic data, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic data) fromJson,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return Success(fromJson(response.data));
    } on DioException catch (e) {
      return Failure(_handleDioException(e));
    } catch (e) {
      return Failure(UnknownException(message: e.toString()));
    }
  }

  // DELETE: حذف
  Future<ApiResult<T>> delete<T>(
    String path,
    dynamic data, { // غيرناه ليكون مرن (أحياناً نرسل ID أو Body كامل)
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic data) fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return Success(fromJson(response.data));
    } on DioException catch (e) {
      return Failure(_handleDioException(e));
    } catch (e) {
      return Failure(UnknownException(message: e.toString()));
    }
  }

  Exception _handleDioException(DioException e) {
    // طباعة الخطأ القادم من السيرفر مهم جداً لفك شفرة الـ 400 Bad Request
    if (e.response != null) {
      log("Dio Error Body: ${e.response?.data}");
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(message: "Connection timed out");
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        // هنا يمكنك استخراج رسالة الخطأ من السيرفر إذا وجدت
        final errorMessage =
            e.response?.data is Map ? e.response?.data['message'] : null;

        if (statusCode == 401) {
          return UnauthorizedException(
            message: errorMessage ?? "Unauthorized",
            statusCode: statusCode,
          );
        }
        if (statusCode == 400) {
          return BadRequestException(
            message: errorMessage ?? "Bad Request",
            statusCode: statusCode,
          );
        }
        if (statusCode != null && statusCode >= 500) {
          return ServerException(
            message: "Server Error",
            statusCode: statusCode,
          );
        }

        return UnknownException(
          message: errorMessage ?? "Invalid status code: $statusCode",
          statusCode: statusCode,
        );
      default:
        return NetworkException(message: "Network error occurred");
    }
  }
}
