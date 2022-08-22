import 'dart:async';
import 'dart:developer';

import 'package:app/app/app.dart';
import 'package:app/app/app_bloc_observer.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:phone_number_api/phone_number_api.dart';
import 'package:phone_number_repository/phone_number_repository.dart';

void bootstrap({required PhoneNumberApi api}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = AppBlocObserver();

  final repository = PhoneNumberRepository(api: api);

  runZonedGuarded(
    () => runApp(App(numberRepository: repository)),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
