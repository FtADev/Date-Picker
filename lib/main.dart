import 'package:custom_date_picker/provider/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'all_providers.dart';
import 'generated/l10n.dart';
import 'home.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    MainProvider provider = ref.watch(AllProvider.mainProvider);

    return MaterialApp(
      title: 'Custom Date Picker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      locale: provider.locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: const MyHomePage(),
    );
  }
}
