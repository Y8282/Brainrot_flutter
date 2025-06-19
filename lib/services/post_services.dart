import 'package:brainrot_flutter/services/http_json_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postServicesProvider = Provider<PostServices>((ref) {
  return PostServices(ref);
});

class PostServices extends ChangeNotifier {
  final Ref _ref;

  PostServices(this._ref);

  // 전체 글 list
  Future<void> postList({
    required String requestId,
    required Function(String, dynamic, String, BuildContext?) callback,
  }) async {
    await _ref.read(httpJsonServiceProvider).sendRequest(
        method: HttpMethod.GET,
        url: '/api/image/list',
        callback: callback,
        requestId: requestId);
  }

// 전체 댓글 list
  Future<void> commentList({
    required Map<String, dynamic> parameters,
    required String requestId,
    required Function(String, dynamic, String, BuildContext?) callback,
  }) async {
    await _ref.read(httpJsonServiceProvider).sendRequest(
        method: HttpMethod.POST,
        url: '/api/image/commentlist',
        data: parameters,
        callback: callback,
        requestId: requestId);
  }

  // 댓글 쓰기
  Future<void> commentSubmit({
    required Map<String, dynamic> parameters,
    required String requestId,
    required Function(String, dynamic, String, BuildContext?) callback,
  }) async {
    await _ref.read(httpJsonServiceProvider).sendRequest(
        method: HttpMethod.POST,
        url: '/api/image/commentsubmit',
        data: parameters,
        callback: callback,
        requestId: requestId);
  }

  // 하트
  Future<void> toggleLovePost({
    required Map<String, dynamic> parameters,
    required String requestId,
    required Function(String, dynamic, String, BuildContext?) callback,
  }) async {
    await _ref.read(httpJsonServiceProvider).sendRequest(
        method: HttpMethod.POST,
        url: '/api/image/lovepost',
        data: parameters,
        callback: callback,
        requestId: requestId);
  }
}
