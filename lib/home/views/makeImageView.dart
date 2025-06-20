import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Makeimageview extends ConsumerStatefulWidget {
  const Makeimageview({super.key});

  @override
  MakeimageState createState() => MakeimageState();
}

class MakeimageState extends ConsumerState<Makeimageview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: "Head",
                      border: OutlineInputBorder(),
                      constraints: BoxConstraints()),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: "Body", border: OutlineInputBorder()),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(""),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: "Arm", border: OutlineInputBorder()),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 100,
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Leg", border: OutlineInputBorder()),
                  ),
                ),
                Container(
                  width: 100,
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Tail", border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: null,
            child: const Text('button'),
          ),
        ],
      ),
    );
  }
}
