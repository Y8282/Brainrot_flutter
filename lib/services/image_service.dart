import 'package:brainrot_flutter/services/http_json_service.dart';
import 'package:brainrot_flutter/widget/navistate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final imageServiceProvider = Provider<ImageService>((ref) {
  return ImageService(ref);
});

class ImageService {
  final Ref _ref;

  ImageService(this._ref);

  Future<void> generateImage({
    required Map<String, dynamic> parameters,
    required String requestId,
    required Function(String, dynamic, String, BuildContext?) callback,
  }) async {
    await _ref.read(httpJsonServiceProvider).sendRequest(
          method: HttpMethod.POST,
          url: '/images/generate',
          data: {'parameters': parameters},
          requestId: requestId,
          callback: (status, data, reqId, context) {
            if (status == 'COMPLETED' && data['resultCode'] == '000') {
              final result = {
                ...data,
                'image': data['image'],
              };
              callback(status, result, reqId, context);
            } else {
              callback(
                  'ERROR',
                  {
                    'message':
                        data['resultMessage'] ?? 'Image generation failed'
                  },
                  reqId,
                  context);
            }
          },
        );
  }

  Future<void> getImage({
    required int imageId,
    required String requestId,
    required Function(String, dynamic, String, BuildContext?) callback,
  }) async {
    await _ref.read(httpJsonServiceProvider).sendRequest(
          method: HttpMethod.GET,
          url: '/images/$imageId',
          requestId: requestId,
          callback: (status, data, reqId, context) {
            if (status == 'COMPLETED' && data['resultCode'] == '000') {
              final result = {
                'imageUrl': '${Api.baseUrl}/images/$imageId',
              };
              callback(status, result, reqId, context);
            } else {
              callback(
                  'ERROR',
                  {
                    'message': data['resultMessage'] ?? 'Image retrieval failed'
                  },
                  reqId,
                  context);
            }
          },
        );
  }
}
