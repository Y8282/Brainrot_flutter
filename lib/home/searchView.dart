import 'package:flutter/material.dart';

class Searchview extends StatefulWidget {
  const Searchview({super.key});

  @override
  State<Searchview> createState() => _SearchviewState();
}

class _SearchviewState extends State<Searchview> {
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
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.green),
                  width: 200,
                  height: 200,
                  padding: EdgeInsets.all(8),
                  child: GestureDetector(
                    child: Text("data"),
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
