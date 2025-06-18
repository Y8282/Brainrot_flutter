import 'package:brainrot_flutter/common/CommonButton.dart';
import 'package:brainrot_flutter/home/model/profile_view_model.dart';
import 'package:brainrot_flutter/login/model/login_view_model.dart';
import 'package:brainrot_flutter/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Profileview extends ConsumerWidget {
  const Profileview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(userProvider);
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      // CircleAvatar(
                      //   radius: 40,
                      //   backgroundImage:
                      //       AssetImage('assets/image/brainrot_profile.jpg'),
                      // ),
                      Text(vm!.username),
                    ],
                  ),
                ),
                Commonbutton(
                    text: "프로필 변경",
                    onPressed: () {
                      print('클');
                    }),
                SizedBox(
                  width: 10,
                ),
                // Commonbutton(
                //     text: "모드 변경경",
                //     onPressed: () {
                //       print('클');
                //     }),
              ],
            ),
          ),
          Expanded(child: CustomTabBar())
        ],
      ),
    );
  }
}

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({super.key});

  @override
  State<CustomTabBar> createState() => _TabBarState();
}

class _TabBarState extends State<CustomTabBar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Column(
        children: [
          TabBar(tabs: [
            Tab(
              child: Column(
                children: [Text("35"), Text("게시물")],
              ),
            ),
            Tab(
              child: Column(
                children: [Text("20"), Text("하트")],
              ),
            ),
          ]),
          Expanded(
            child: TabBarView(
              children: [
                Container(
                  child: Center(
                    child: ImageGridView(),
                  ),
                ),
                Container(
                  child: Center(
                    child: ImageGridView(
                      favorite: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImageGridView extends StatelessWidget {
  final bool? favorite;

  const ImageGridView({this.favorite, super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      padding: EdgeInsets.all(8),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.green),
          padding: EdgeInsets.all(8),
          child: Stack(
            children: [
              // GestureDetector(
              //   child: Image.asset(
              //     'assets/image/brainrot.jpg',
              //   ),
              //   onTap: () {
              //     context.go('/detailImage');

              //   },
              // ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  child: (favorite == true)
                      ? Icon(Icons.favorite)
                      : Icon(Icons.favorite_outline),
                  onTap: () {},
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
