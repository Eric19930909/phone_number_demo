import 'package:phone_number_api/phone_number_api.dart';

/// {@template phone_number_repository}
/// A repository that handles phone number related requests.
/// {@endtemplate}
class PhoneNumberRepository {
  /// {@macro phone_number_repository}
  const PhoneNumberRepository({
    required PhoneNumberApi api,
  }) : _api = api;

  final PhoneNumberApi _api;

  /// Provides a [Stream] of all todos.
  Stream<List<PhoneNumber>> getAllPhoneNumber() => _api.getAllPhoneNumber();

  /// Saves a [number].
  ///
  /// If a [number] with the same id already exists, it will be replaced.
  Future<void> save(PhoneNumber number) => _api.save(number);

  /// Deletes the number with the given id.
  ///
  /// If no number with the given id exists, a
  /// [PhoneNumberNotFoundException] error is thrown.
  Future<void> delete(String id) => _api.delete(id);
}
