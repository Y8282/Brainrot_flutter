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
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 212, 215, 216)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        print('이미지 위 유저 한번 클릭');
                      },
                      child: const Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                AssetImage('assets/image/brainrot_profile.jpg'),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text("user_name"),
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
                  print('이미지 한번클릭');
                },
                onDoubleTap: () {
                  print('이미지 더블 클릭');
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  // child: Image.asset('assets/image/brainrot.jpg'),
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
                            Text("2025-02-05"),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Wrap(
                                spacing: 10,
                                children: [
                                  Text("퉁퉁퉁퉁 사후르"),
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
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return Container(
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
                                      Text("퉁퉁"),
                                    ],
                                  ),
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
