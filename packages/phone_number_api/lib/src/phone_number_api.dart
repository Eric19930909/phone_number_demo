import 'package:phone_number_api/src/models/phone_number.dart';

/// {@template phone_number_api}
/// The interface for an API that provides access to a list of todos.
/// {@endtemplate}
abstract class PhoneNumberApi {
  /// {@macro phone_number_api}
  const PhoneNumberApi();

  /// Provides a [Stream] of all PhoneNumber.
  Stream<List<PhoneNumber>> getAllPhoneNumber();

  /// Saves a [PhoneNumber].
  ///
  /// If a [PhoneNumber] with the same id already exists, it will be replaced.
  Future<void> save(PhoneNumber number);

  /// Deletes the PhoneNumber with the given id.
  ///
  /// If no PhoneNumber with the given id exists, a [PhoneNumberNotFoundException]
  /// error is thrown.
  Future<void> delete(String id);
}

/// Error thrown when a [PhoneNumber] with a given id is not found.
class PhoneNumberNotFoundException implements Exception {}

/// Error thrown when a [PhoneNumber] with a given item is equals.
class PhoneNumberDuplicateException implements Exception {}