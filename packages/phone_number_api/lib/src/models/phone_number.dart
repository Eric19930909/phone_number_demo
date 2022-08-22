import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:phone_number_api/src/models/json_map.dart';
import 'package:uuid/uuid.dart';

part 'phone_number.g.dart';

@immutable
@JsonSerializable()
class PhoneNumber extends Equatable {
  /// {@macro PhoneNumber}
  PhoneNumber({
    String? id,
    required this.prefix,
    required this.number,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  /// The unique identifier of the PhoneNumber.
  ///
  /// Cannot be empty.
  final String id;

  ///
  final String prefix;

  ///
  final String number;

  /// Returns a copy of this PhoneNumber with the given values updated.
  ///
  /// {@macro PhoneNumber}
  PhoneNumber copyWith({
    String? id,
    String? prefix,
    String? number,
  }) {
    return PhoneNumber(
      id: id ?? this.id,
      prefix: prefix ?? this.prefix,
      number: number ?? this.number,
    );
  }

  /// Deserializes the given [JsonMap] into a [PhoneNumber].
  static PhoneNumber fromJson(JsonMap json) => _$PhoneNumberFromJson(json);

  /// Converts this [PhoneNumber] into a [JsonMap].
  JsonMap toJson() => _$PhoneNumberToJson(this);

  @override
  List<Object> get props => [prefix, number];
}
