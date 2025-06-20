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
  final Map<int, bool>? showHeart;

  MainViewState(
      {required this.isLoading,
      required this.isInitialized,
      this.posts,
      this.comments,
      this.favorite,
      this.showHeart});

  MainViewState copyWith({
    bool? isLoading,
    bool? isInitialized,
    List<Postmodel>? posts,
    Map<int, List<Commentmodel>>? comments,
    Map<int, bool>? favorite,
    Map<int, bool>? showHeart,
  }) {
    return MainViewState(
        isLoading: isLoading ?? this.isLoading,
        isInitialized: isInitialized ?? this.isInitialized,
        posts: posts ?? this.posts,
        comments: comments ?? this.comments,
        favorite: favorite ?? this.favorite,
        showHeart: showHeart ?? this.showHeart);
  }

  factory MainViewState.initial() => MainViewState(
        isLoading: false,
        isInitialized: false,
        posts: [],
        comments: {},
        favorite: {},
        showHeart: {},
      );
}

final mainViewModelProvider =
    StateNotifierProvider.autoDispose<MainViewModel, MainViewState>((ref) {
  return MainViewModel(ref);
});

class MainViewModel extends StateNotifier<MainViewState> {
  final Ref _ref;

  late int parentId;
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

  // 글 리스트
  Future<void> postList(BuildContext context) async {
    state = state.copyWith(isLoading: true, isInitialized: true, posts: []);

    final authUser = _ref.watch(userProvider);
    final requestId = 'list';

    final parameters = {
      'userId': authUser!.email,
    };

    await _ref.read(postServicesProvider).postList(
          parameters: parameters,
          requestId: requestId,
          callback: (status, data, reqId, _) {
            handleCallback(status, data, requestId, context);
          },
        );
  }

  // 댓글 리스트
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

  // 댓글 쓰기
  Future<void> handleSubmit(
      {BuildContext? context, required int postId, int? commentId}) async {
    // 유저 Id
    final vm = _ref.watch(userProvider);

    var content = commentController.text;
    // 댓글내용
    if (content.isEmpty) return;
    if (content.startsWith('@${vm!.username}')) {
      commentId = parentId;
      content =
          commentController.text.substring(vm!.username.length + 1).trim();
      print("@@@@@@@@ ${content}");
    }
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

    commentList(context, postId);

    print("댓글 ${commentController.text.trim()}");
    commentController.clear();
  }

  // 답글 달기
  Future<void> repliesComment(String userName, int id) async {
    parentId = id;
    commentController.text = '@${userName} ';
    focusNode.requestFocus();
  }

  // 댓글 삭제
  Future<void> commentDelete(
    BuildContext context,
    int id,
    int postId,
  ) async {
    final requestId = 'commentdelete';
    final authUser = _ref.watch(userProvider);
    final parameters = {
      'postId': postId,
      'userId': authUser!.username,
      'id': id
    };

    await _ref.read(postServicesProvider).commentDelete(
          parameters: parameters,
          requestId: requestId,
          callback: (status, data, requestId, _) {
            handleCallback(status, data, requestId, context);
          },
        );

    await commentList(context, postId);
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
          final favoriteMap = {
            for (var post in posts) post.id: post.liked ?? false,
          };

          state = state.copyWith(
            isLoading: false,
            posts: posts,
            favorite: favoriteMap,
          );

          print("불러온 글 갯수: ${posts.length}");
          // for (var post in posts) {
          //   await commentList(context!, post.id);
          // }
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
        } else {
          print("error : ${data['resultMessage']}");
        }
        break;

      case 'commentdelete':
        if (resultCode == '000') {
          print('댓글 삭제 성공 👌');
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

          print('토글 하트! postId: $postId, liked: $liked ❤️');
        } else {
          print("error : ${data['resultMessage']}");
        }
        break;

      default:
        print('Unknown requestId: $requestId');
        break;
    }
  }
}
