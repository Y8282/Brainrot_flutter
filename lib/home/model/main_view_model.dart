import 'dart:convert';

import 'package:brainrot_flutter/home/json/Commentmodel.dart';
import 'package:brainrot_flutter/home/json/postmodel.dart';
import 'package:brainrot_flutter/home/model/profile_view_model.dart';
import 'package:brainrot_flutter/providers/auth_provider.dart';
import 'package:brainrot_flutter/services/auth_services.dart';
import 'package:brainrot_flutter/services/post_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainViewState {
  final bool isLoading;
  final bool isInitialized;
  final List<Postmodel>? posts;
  final Map<int, List<Commentmodel>>? comments;
  final Map<int, bool>? favorite;

  MainViewState({
    required this.isLoading,
    required this.isInitialized,
    this.posts,
    this.comments,
    this.favorite,
  });

  MainViewState copyWith({
    bool? isLoading,
    bool? isInitialized,
    List<Postmodel>? posts,
    Map<int, List<Commentmodel>>? comments,
    Map<int, bool>? favorite,
  }) {
    return MainViewState(
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
      posts: posts ?? this.posts,
      comments: comments ?? this.comments,
      favorite: favorite ?? this.favorite,
    );
  }

  factory MainViewState.initial() => MainViewState(
        isLoading: false,
        isInitialized: false,
        posts: [],
        comments: {},
        favorite: {},
      );
}

final mainViewModelProvider =
    StateNotifierProvider.autoDispose<MainViewModel, MainViewState>((ref) {
  return MainViewModel(ref);
});

class MainViewModel extends StateNotifier<MainViewState> {
  final Ref _ref;
  final TextEditingController commentController =
      TextEditingController(); // 댓글 컨트롤러
  final FocusNode focusNode = FocusNode(); // 댓글 포커스

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

  // 댓글 쓰기
  Future<void> handleSubmit(
      {BuildContext? context, required int postId, int? commentId}) async {
    // 유저 Id
    final vm = _ref.watch(userProvider);

    // 댓글내용
    final content = commentController.text.trim();
    if (content.isEmpty) return;

    final requestId = 'commentsubmit';

    final parameters = {
      'postId': postId,
      'content': content,
      'userId': vm!.username,
      if (commentId != null) 'commentId': commentId
    };

    await _ref.read(postServicesProvider).commentSubmit(
          parameters: parameters,
          requestId: requestId,
          callback: (status, data, requestId, context) {
            handleCallback(status, data, requestId, context);
          },
        );

    // 상태 업데이트
    final newComment = Commentmodel(
        id: DateTime.now().microsecondsSinceEpoch,
        postId: postId,
        userId: vm.username,
        content: content,
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
        replies: []);

    final exisitingComments = state.comments?[postId] ?? [];

    final updatedComments = [
      newComment,
      ...exisitingComments,
    ];

    state = state.copyWith(
        comments: {...(state.comments ?? {}), postId: updatedComments});

    print("댓글 ${commentController.text.trim()}");
    commentController.clear();
  }

  // 글
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
  Future<void> commentList(BuildContext? context, int postId) async {
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

  // 글 하트
  Future<void> toggleLovePost(BuildContext? context, int postId) async {
    final requestId = 'lovepost';

    // 유저 Id
    final vm = _ref.watch(userProvider);

    final parameters = {'postId': postId, 'userId': vm!.email};

    await _ref.read(postServicesProvider).toggleLovePost(
          parameters: parameters,
          requestId: requestId,
          callback: (status, data, requestId, _) {
            handleCallback(status, data, requestId, context);
          },
        );
  }

  // api
  Future<void> handleCallback(String status, dynamic data, String requestId,
      BuildContext? context) async {
    print('HandleCallback: status=$status, data=${data}, requestId=$requestId');

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
              } else {}
            }
          }

          // for (var root in rootComments) {
          //   print("${root.id} , ${root.content}");
          //   for (var reply in root.replies) {
          //     print("   └──  [${reply.id}] ${reply.content}");
          //   }
          // }

          final postId = comments.isNotEmpty ? comments.first.postId : null;

          if (postId != null) {
            final exisitngMap = state.comments ?? {};
            exisitngMap[postId] = rootComments;
            state = state.copyWith(comments: exisitngMap);
          }
        } else {
          print('Error: ${data['resultMessage']}');
        }
        break;

      case 'commentsubmit':
        if (resultCode == '000') {
          print('댓글 추가 성공 😊');
          final postId = result?['postId'] ?? 0;
          if (postId != 0) {
            await commentList(context, postId);
          }
        } else {
          print("error : ${data['resultMessage']}");
        }
        break;

      case 'lovepost':
        if (resultCode == '000') {
          final currentFavorites = state.favorite ?? <int, bool>{};
          final updatedFavorites = Map<int, bool>.from(currentFavorites);
          final liked = result?['liked'];
          final postId = result?['postId'] ?? 0;

  

          updatedFavorites[postId] = liked;

          state = state.copyWith(favorite: updatedFavorites);

          state = state.copyWith(favorite: updatedFavorites);

          print('토글 하트! ❤️');
        }

      default:
        print('Unknown requestId: $requestId');
        break;
    }
  }
}
