import 'dart:convert';
import 'dart:typed_data';

import 'package:brainrot_flutter/common/color.dart';
import 'package:brainrot_flutter/home/json/Commentmodel.dart';
import 'package:brainrot_flutter/home/model/home_view_model.dart';
import 'package:brainrot_flutter/home/model/main_view_model.dart';
import 'package:brainrot_flutter/home/model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Mainview extends ConsumerStatefulWidget {
  const Mainview({super.key});

  @override
  MainviewState createState() => MainviewState();
}

class MainviewState extends ConsumerState<Mainview> {
  @override
  Widget build(BuildContext context) {
    final mainViewState = ref.watch(mainViewModelProvider);
    final mainViewModel = ref.read(mainViewModelProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if ((mainViewState.posts!.isEmpty ?? true) && !mainViewState.isLoading) {
        mainViewModel.initialize(context: context);
      }
    });

    if (mainViewState.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (mainViewState.posts == null || mainViewState.posts!.isEmpty) {
      return Center(
        child: Text("글이 없습니다"),
      );
    }

    return ListView.builder(
      itemCount: mainViewState.posts?.length ?? 1,
      itemBuilder: (context, index) {
        final post = mainViewState.posts![index];
        final double logicalSize =
            1024 / MediaQuery.of(context).devicePixelRatio;
        final rootComments = mainViewState.comments
                ?.where(
                  (comment) =>
                      comment.postId == post.id && comment.commentId == null,
                )
                .toList() ??
            [];

        return Container(
          child: Column(
            children: [
              Container(
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
                      child: Icon(Icons.toc),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  print('이미지 한번 클릭');
                },
                onDoubleTap: () {
                  print('이미지 더블 클릭');
                },
                child: Container(
                  width: logicalSize,
                  height: logicalSize,
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: Text("hi"),
                  // child: Image.network(
                  //   'http://localhost:8080/api/image/raw/${post.imgId}',
                  //   fit: BoxFit.cover,
                  //   errorBuilder: (context, error, stackTrace) {
                  //     print(
                  //         "Image decode error: $error, stackTrace: $stackTrace context : $context");
                  //     return Icon(Icons.error);
                  //   },
                  // ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Wrap(
                          spacing: 10,
                          children: [
                            GestureDetector(
                              child: Icon(Icons.favorite_outline),
                            ),
                            GestureDetector(
                              child: Icon(Icons.chat_bubble_outline),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Wrap(
                                spacing: 10,
                                children: [
                                  Text(post.content),
                                  GestureDetector(
                                    onTap: () {
                                      print("더보기 클릭");
                                    },
                                    child: Text("더보기"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: rootComments.length,
                              itemBuilder: (context, commentIndex) {
                                final rootComment = rootComments[commentIndex];
                                print(
                                    "@@@@@@@@@@comment : ${rootComment.content} commentId : ${rootComment.commentId}");

                                return Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(2),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 10,
                                            backgroundImage: AssetImage(
                                                'assets/image/brainrot_profile.jpg'),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(rootComment.content ?? ''),
                                        ],
                                      ),
                                    ),
                                    if (rootComment.replies.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(left: 16),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: rootComment.replies.length,
                                          itemBuilder: (context, replyIndex) {
                                            final replyComment =
                                                rootComment.replies[replyIndex];
                                            print(
                                                "@@@@@@@@@@reply: ${replyComment.content} commentId: ${replyComment.commentId}");
                                            return Container(
                                              padding: EdgeInsets.all(12),
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 10,
                                                    backgroundImage: AssetImage(
                                                        'assets/image/brainrot_profile.jpg'),
                                                  ),
                                                  Text(replyComment.content ??
                                                      ''),
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
}
