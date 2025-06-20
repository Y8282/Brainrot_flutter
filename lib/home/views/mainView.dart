import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:brainrot_flutter/common/CommonDialog.dart';
import 'package:brainrot_flutter/common/CustomBottomSheet.dart';
import 'package:brainrot_flutter/common/color.dart';
import 'package:brainrot_flutter/home/json/Commentmodel.dart';
import 'package:brainrot_flutter/home/model/home_view_model.dart';
import 'package:brainrot_flutter/home/model/main_view_model.dart';
import 'package:brainrot_flutter/home/model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Mainview extends ConsumerStatefulWidget {
  const Mainview({super.key});

  @override
  MainviewState createState() => MainviewState();
}

class MainviewState extends ConsumerState<Mainview> {
  final Set<int> _expandedPosts = {};
  final Map<int, bool> _showHeart = {};
  @override
  Widget build(BuildContext context) {
    final mainViewState = ref.watch(mainViewModelProvider);
    final mainViewModel = ref.read(mainViewModelProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if ((mainViewState.posts!.isEmpty ?? true) && !mainViewState.isLoading) {
        mainViewModel.initialize(context: context);
      }
    });

    return ListView.builder(
      itemCount: mainViewState.posts?.length ?? 1,
      itemBuilder: (context, index) {
        final post = mainViewState.posts![index];
        final double logicalSize =
            1024 / MediaQuery.of(context).devicePixelRatio;
        final isLiked = mainViewState.favorite?[post.id] ?? false; // 글 당 하트
        final showHeart = _showHeart[post.id] ?? false;
        final rootComments = mainViewState.comments?[post.id] ?? []; // 답글달기
        final isExpanded = _expandedPosts.contains(post.id); // 더보기 , 숨기기
        final displayContent =
            isExpanded || post.content.length < 10 // 더보기 , 숨기기
                ? post.content
                : '${post.content.substring(0, 10)}...';
        return Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(color: ColorStyles.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        print('이미지 위 유저 한번 클릭');
                      },
                      child: Row(
                        children: [
                          // CircleAvatar(
                          //   radius: 25,
                          //   backgroundImage:
                          //       AssetImage('assets/image/brainrot_profile.jpg'),
                          // ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(post.username),
                        ],
                      ),
                    ),
                    GestureDetector(
                      child: Icon(Icons.info_outline),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  print('이미지 한번 클릭');
                },
                onDoubleTap: () async {
                  mainViewModel.toggleLovePost(context, post.id);
                  if (isLiked) {
                    setState(() {
                      _showHeart[post.id] = true;
                    });
                    Timer(Duration(seconds: 1), () {
                      setState(() {
                        _showHeart[post.id] = false;
                      });
                    });
                  }
                },
                child: Container(
                  width: logicalSize,
                  height: logicalSize,
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: Stack(
                    children: [
                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   height: MediaQuery.of(context).size.height,
                      //   child: Image.network(
                      //     'http://localhost:8080/api/image/raw/${post.imgId}',
                      //     fit: BoxFit.cover,
                      //     errorBuilder: (context, error, stackTrace) {
                      //       print(
                      //           "Image decode error: $error, stackTrace: $stackTrace context : $context");
                      //       return Icon(Icons.error);
                      //     },
                      //   ),
                      // ),
                      Text("hi"),
                      Positioned.fill(
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            switchInCurve: Curves.easeOutBack,
                            switchOutCurve: Curves.easeInOut,
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
                            },
                            child: showHeart
                                ? const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 80,
                                  )
                                : const SizedBox(
                                    width: 80,
                                    height: 80,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Wrap(
                          spacing: 10,
                          children: [
                            GestureDetector(
                              child: (mainViewState.favorite?[post.id] ?? false)
                                  ? Icon(Icons.favorite)
                                  : Icon(Icons.favorite_outline),
                              onTap: () async {
                                mainViewModel.toggleLovePost(context, post.id);
                                if (!isLiked) {
                                  setState(() {
                                    _showHeart[post.id] = true;
                                  });
                                  Timer(Duration(seconds: 1), () {
                                    setState(() {
                                      _showHeart[post.id] = false;
                                    });
                                  });
                                }
                              },
                            ),
                            GestureDetector(
                              child: Icon(Icons.chat_bubble_outline),
                              onTap: () {
                                mainViewModel.commentList(context, post.id);
                                mainViewModel.commentController.clear();
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) =>
                                      Consumer(builder: (context, ref, child) {
                                    final updatedComments = ref
                                            .watch(mainViewModelProvider)
                                            .comments?[post.id] ??
                                        [];

                                    return Custombottomsheet(
                                      controller:
                                          mainViewModel.commentController,
                                      focusNode: mainViewModel.focusNode,
                                      buttonClick: () {
                                        mainViewModel.handleSubmit(
                                            postId: post.id);
                                      },
                                      onSubmitted: () {
                                        mainViewModel.handleSubmit(
                                            postId: post.id);
                                      },
                                      child: commentWidget(updatedComments),
                                    );
                                  }),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 10,
                            children: [
                              Text(
                                displayContent,
                                maxLines: isExpanded ? null : 1,
                                overflow: isExpanded
                                    ? TextOverflow.visible
                                    : TextOverflow.ellipsis,
                              ),
                              if (post.content.length > 10)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isExpanded) {
                                        _expandedPosts.remove(post.id);
                                      } else {
                                        _expandedPosts.add(post.id);
                                      }
                                    });
                                  },
                                  child: Text(!isExpanded ? "더보기" : "숨기기"),
                                ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Expanded commentWidget(List<Commentmodel> rootComments) {
    return Expanded(
      child: ListView.builder(
        itemCount: rootComments.length,
        itemBuilder: (context, commentIndex) {
          final mainViewState = ref.watch(mainViewModelProvider);
          final mainViewModel = ref.read(mainViewModelProvider.notifier);
          final rootComment = rootComments[commentIndex];
          final authUser = ref.watch(userProvider);
          return Column(
            children: [
              GestureDetector(
                onDoubleTap: () {
                  if (authUser!.username == rootComment.userId) {
                    openDialog(
                      context,
                      message: "정말 삭제 하시겠습니까??",
                      buttonType: MessageBottomButtonType.yesno,
                      type: MessagePopupType.question,
                      onConfirmed: () {
                        mainViewModel.commentDelete(
                            context, rootComment.id, rootComment.postId);
                      },
                    );
                  }
                },
                child: Container(
                  color: ColorStyles.transparent,
                  padding: EdgeInsets.all(7),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundImage:
                            AssetImage('assets/image/brainrot_profile.jpg'),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(rootComment.userId),
                            Text(
                              rootComment.content ?? '',
                              overflow: TextOverflow.visible,
                              maxLines: null,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  child: Text(
                                    "답글 달기",
                                    style: TextStyle(
                                      color: ColorStyles.gray.withOpacity(1.0),
                                    ),
                                  ),
                                  onTap: () {
                                    bool focus = true;
                                    if (focus) {
                                      mainViewModel.repliesComment(
                                          rootComment.userId, rootComment.id);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (rootComment.replies.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: rootComment.replies.length,
                    itemBuilder: (context, replyIndex) {
                      final replyComment = rootComment.replies[replyIndex];
                      return Container(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 15,
                              backgroundImage: AssetImage(
                                  'assets/image/brainrot_profile.jpg'),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(replyComment.userId),
                                  Text(
                                    replyComment.content ?? '',
                                    overflow: TextOverflow.visible,
                                    maxLines: null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
