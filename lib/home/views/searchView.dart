import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Searchview extends ConsumerStatefulWidget {
  const Searchview({super.key});

  @override
  SearchviewState createState() => SearchviewState();
}

class SearchviewState extends ConsumerState<Searchview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: "Search",
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
              padding: EdgeInsets.all(8),
              itemCount: 10,
              itemBuilder: (context, index) {
                final bool? favorite = false;
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.green),
                  padding: EdgeInsets.all(8),
                  child: Stack(
                    children: [
                      // GestureDetector(
                      //   child: Image.asset('assets/image/brainrot.jpg'),
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
            ),
          ),
        ],
      ),
    ));
  }
}
