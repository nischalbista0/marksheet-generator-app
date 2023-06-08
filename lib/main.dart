import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'view/result_view.dart';

// import 'package:riverpod_state_management/view/simpleint_view.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Student Marksheet',
        initialRoute: '/',
        routes: {
          '/': (context) => const ResultView(),
        },
      ),
    ),
  );
}
