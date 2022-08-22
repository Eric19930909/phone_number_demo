import 'package:flutter/material.dart';
import 'package:local_storage_number_api/local_storage_number_api.dart';

import 'bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final api = LocalStorageNumberApi(
    plugin: await SharedPreferences.getInstance(),
  );

  bootstrap(api: api);
}
