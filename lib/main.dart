import 'package:app/bootstrap.dart';
import 'package:flutter/material.dart';
import 'package:local_storage_number_api/local_storage_number_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final api = LocalStorageNumberApi(
    plugin: await SharedPreferences.getInstance(),
  );

  bootstrap(api: api);
}
