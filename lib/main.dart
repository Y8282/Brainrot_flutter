import 'package:brainrot_flutter/routes/router.dart';
import 'package:brainrot_flutter/services/spinnerserivce.dart';
import 'package:brainrot_flutter/widget/loadingView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//보완 필요 기기별로 반응형으로 만들어야함
void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final isLoading = ref.watch(spinnerProvider).isLoading;
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'Brainrot Flutter',
      theme: ThemeData(primarySwatch: Colors.blue),
      builder: (context, child) {
        return Stack(
          children: [child!, if (isLoading) Loadingview()],
        );
      },
    );
  }
}
