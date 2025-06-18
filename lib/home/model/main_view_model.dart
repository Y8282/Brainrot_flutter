import 'dart:convert';

import 'package:brainrot_flutter/home/json/Commentmodel.dart';
import 'package:brainrot_flutter/home/json/postmodel.dart';
import 'package:brainrot_flutter/services/post_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainViewState {
  final bool isLoading;
  final bool isInitialized;
  final List<Postmodel>? posts;
  final List<Commentmodel>? comments;

  MainViewState({
    required this.isLoading,
    required this.isInitialized,
    this.posts,
    this.comments,
  });

  MainViewState copyWith({
    bool? isLoading,
    bool? isInitialized,
    List<Postmodel>? posts,
    List<Commentmodel>? comments,
  }) {
    return MainViewState(
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
      posts: posts ?? this.posts,
      comments: comments ?? this.comments,
    );
  }

  factory MainViewState.initial() => MainViewState(
        isLoading: false,
        isInitialized: false,
        posts: [],
        comments: [],
      );
}

final mainViewModelProvider =
    StateNotifierProvider.autoDispose<MainViewModel, MainViewState>((ref) {
  return MainViewModel(ref);
});

class MainViewModel extends StateNotifier<MainViewState> {
  final Ref _ref;

  MainViewModel(this._ref) : super(MainViewState.initial());

  Future<void> initialize({required BuildContext context}) async {
    state = MainViewState(
      isLoading: false,
      isInitialized: false,
    );

    await Future.wait([
      postList(context),
    ]);
  }

  // 글화면
  Future<void> postList(BuildContext context) async {
    state = state.copyWith(isLoading: true, isInitialized: true, posts: []);

    final requestId = 'list';

    await _ref.read(postServicesProvider).postList(
          requestId: requestId,
          callback: (status, data, reqId, _) {
            handleCallback(status, data, requestId, context);
          },
        );
  }

  // 댓글
  Future<void> commentList(BuildContext context, int postId) async {
    final requestId = 'commentlist';

    final parameters = {'postId': postId};

    await _ref.read(postServicesProvider).commentList(
          parameters: parameters,
          requestId: requestId,
          callback: (status, data, reqId, _) {
            handleCallback(status, data, requestId, context);
          },
        );
  }

  // api
  Future<void> handleCallback(String status, dynamic data, String requestId,
      BuildContext? context) async {
    print('HandleCallback: status=$status, requestId=$requestId');

    // 결과 추출
    final result = data['resultData'];
    final resultCode = data['resultCode'];
    switch (requestId) {
      case 'list':
        if (resultCode == '000') {
          final List<dynamic> postLists = data['resultData']['posts'] ?? [];
          final posts =
              postLists.map((json) => Postmodel.fromJson(json)).toList();
          print("불러온 글 갯수: ${posts.length}");
          state = state.copyWith(
            isLoading: false,
            posts: posts,
          );

          for (var post in posts) {
            await commentList(context!, post.id);
          }
        } else {
          state = state.copyWith(
            isLoading: false,
            posts: [],
          );
        }
        break;

      case 'commentlist':
        if (resultCode == '000') {
          final List<dynamic> commentLists =
              data['resultData']?['comments'] ?? [];
          final comments =
              commentLists.map((json) => Commentmodel.fromJson(json)).toList();
          print('댓글개수 ${comments.length}');

          final Map<int, Commentmodel> commentMap = {};
          final List<Commentmodel> rootComments = [];

          for (var comment in comments) {
            commentMap[comment.id] = Commentmodel(
                id: comment.id,
                postId: comment.postId,
                userId: comment.userId,
                content: comment.content,
                commentId: comment.commentId,
                createdAt: comment.createdAt,
                updatedAt: comment.updatedAt,
                replies: []);
          }

          for (var comment in commentMap.values) {
            if (comment.commentId == null) {
              rootComments.add(comment);
            } else {
              final parent = commentMap[comment.commentId!];
              if (parent != null) {
                parent.replies.add(comment);
              } else {
              }
            }
          }

          for (var root in rootComments) {
            print("${root.id} , ${root.content}");
            for (var reply in root.replies) {
              print("   └── 💬 [${reply.id}] ${reply.content}");
            }
          }

          final existingComments = state.comments ?? [];
          state = state.copyWith(
            isLoading: state.posts == null,
            comments: [...existingComments, ...rootComments],
          );
        } else {
          print('Error: ${data['resultMessage']}');
        }
        break;

      default:
        print('Unknown requestId: $requestId');
        break;
    }
  }
}
