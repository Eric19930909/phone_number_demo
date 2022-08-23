import 'package:app/home/view/home_page.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_number_repository/phone_number_repository.dart';

class App extends StatelessWidget {
  const App({super.key, required this.numberRepository});

  final PhoneNumberRepository numberRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: numberRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FlutterNumberTheme.light,
      darkTheme: FlutterNumberTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    );
  }
}
