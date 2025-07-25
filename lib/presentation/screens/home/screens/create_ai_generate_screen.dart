import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handy_home_app/data/models/home_model.dart';

class CreateAiGenerateScreen extends ConsumerWidget {
  const CreateAiGenerateScreen({super.key, required this.homePreview});

  final HomeModel homePreview;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Image.asset('assets/images/ai_generate.gif', width: MediaQuery.sizeOf(context).width*0.6,)
          ],
        ),
      ),
    );
  }
}
