import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:phone_number_api/phone_number_api.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template local_storage_number_api}
/// A Flutter implementation of the [PhoneNumberApi] that uses local storage.
/// {@endtemplate}
class LocalStorageNumberApi extends PhoneNumberApi {
  /// {@macro local_storage_todos_api}
  LocalStorageNumberApi({
    required SharedPreferences plugin,
  }) : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;

  final _numberStreamController =
      BehaviorSubject<List<PhoneNumber>>.seeded(const []);

  /// The key used for storing the phone number locally.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers of
  /// this library.
  @visibleForTesting
  static const kNumberCollectionKey = '__number_collection_key__';

  String? _getValue(String key) => _plugin.getString(key);

  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  void _init() {
    final numberListJson = _getValue(kNumberCollectionKey);
    if (numberListJson != null) {
      final numberList = List<Map<dynamic, dynamic>>.from(
        json.decode(numberListJson) as List,
      )
          .map(
            (jsonMap) => PhoneNumber.fromJson(
              Map<String, dynamic>.from(jsonMap),
            ),
          )
          .toList();
      _numberStreamController.add(numberList);
    } else {
      _numberStreamController.add(const []);
    }
  }

  @override
  Stream<List<PhoneNumber>> getAllPhoneNumber() =>
      _numberStreamController.asBroadcastStream();

  @override
  Future<void> save(PhoneNumber number) {
    final numberList = [..._numberStreamController.value];
    final index = numberList.indexWhere((t) => t.id == number.id);
    if (numberList.contains(number)) {
      throw PhoneNumberDuplicateException();
    }
    if (index >= 0) {
      numberList[index] = number;
    } else {
      numberList.add(number);
    }

    _numberStreamController.add(numberList);
    return _setValue(kNumberCollectionKey, json.encode(numberList));
  }

  @override
  Future<void> delete(String id) async {
    final numberList = [..._numberStreamController.value];
    final index = numberList.indexWhere((t) => t.id == id);
    if (index == -1) {
      throw PhoneNumberNotFoundException();
    } else {
      numberList.removeAt(index);
      _numberStreamController.add(numberList);
      return _setValue(kNumberCollectionKey, json.encode(numberList));
    }
  }
}
