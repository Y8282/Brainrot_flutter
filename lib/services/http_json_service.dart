import 'package:brainrot_flutter/providers/auth_provider.dart';
import 'package:brainrot_flutter/services/spinnerserivce.dart';
import 'package:brainrot_flutter/widget/navistate.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final httpJsonServiceProvider = Provider<HttpJsonService>((ref) {
  return HttpJsonService(ref);
});

enum HttpMethod { POST, GET }

class HttpJsonService {
  final Dio _dio = Dio();
  final Ref _ref;

  HttpJsonService(this._ref) {
    _dio.options = BaseOptions(
      baseUrl: Api.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      extra: {'withCredentials': true},
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          Spinnerservice.instance.show();
          final token = _ref.read(authTokenProvider);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          Spinnerservice.instance.hide();
          handler.next(response);
        },
        onError: (e, handler) {
          Spinnerservice.instance.hide();
          _errorHandler(e);
          handler.next(e);
        },
      ),
    );
  }

  Future<void> sendRequest({
    required HttpMethod method,
    required String url,
    Map<String, dynamic>? parameters,
    dynamic data,
    required Function(String, dynamic, String, BuildContext?) callback,
    required String requestId,
  }) async {
    if (url.isEmpty) {
      print('Error: Empty URL for requestId: $requestId');
      callback('ERROR', {'message': 'Empty URL'}, requestId, null);
      return;
    }

    try {
      print('Sending to: ${Api.baseUrl}$url, Data: $data'); // 요청 로그
      if (method == HttpMethod.POST) {
        final response = await _dio.post(
          url,
          data: data,
          queryParameters: parameters,
          options: Options(
            extra: {
              'callback': callback,
              'requestId': requestId,
            },
          ),
        );
        print('Response for requestId $requestId: ${response.data}'); // 응답 로그
        callback('COMPLETED', response.data, requestId, null);
      } else if (method == HttpMethod.GET) {
        final response = await _dio.get(
          url,
          data: data,
          options: Options(
            extra: {
              'callback': callback,
              'requestId': requestId,
            },
          ),
        );
        print('Response for requestId $requestId: ${response.data}'); // 응답로그
        callback('COMPLETED', response.data, requestId, null);
      }
    } on DioException catch (e) {
      print(
          'Dio Error: ${e.type}, Message: ${e.message}, Request: ${e.requestOptions.data}'); // 에러 로그
      await _errorHandler(e);
    }
  }

  Future<void> _errorHandler(DioException e) async {
    String errorMessage = '알 수 없는 오류가 발생했습니다.';
    bool clearToken = false;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = '서버 응답 시간이 초과되었습니다.';
        clearToken = true;
        break;
      case DioExceptionType.badResponse:
        errorMessage = e.response?.statusCode == 500
            ? e.response?.data['resultMessage'] ?? '서버 내부 오류가 발생했습니다.'
            : 'HTTP 오류: ${e.response?.statusCode}';
        break;
      case DioExceptionType.connectionError:
        errorMessage = '네트워크 연결 오류가 발생했습니다.';
        break;
      case DioExceptionType.cancel:
        errorMessage = '요청이 취소되었습니다.';
        break;
      default:
        errorMessage = e.message ?? errorMessage;
        break;
    }

    if (clearToken) {
      await _ref.read(authTokenProvider.notifier).clearToken();
    }

    final callback = e.requestOptions.extra['callback'] as Function(
        String, dynamic, String, BuildContext?)?;
    if (callback != null) {
      print(
          'Calling callback with error: $errorMessage, requestId: ${e.requestOptions.extra['requestId']}');
      callback(
          'ERROR',
          {
            'resultCode': '500',
            'resultMessage': errorMessage,
          },
          e.requestOptions.extra['requestId'],
          null);
    }
  }
}
