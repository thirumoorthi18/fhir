// ignore_for_file: invalid_annotation_target, sort_unnamed_constructors_first, sort_constructors_first, prefer_mixin

// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:yaml/yaml.dart';

// Project imports:
import 'integer.dart';
import 'number.dart';
import 'primitive_type_exceptions.dart';

class FhirDecimal extends FhirNumber {
  const FhirDecimal._(
      super.valueString, super.valueNumber, super.isValid, this.isInt);

  factory FhirDecimal(dynamic inValue) {
    if (inValue is FhirDecimal) {
      return inValue;
    } else if (inValue is FhirInteger) {
      return FhirDecimal._(
        inValue.toString(),
        inValue.value?.toDouble(),
        inValue.isValid,
        inValue.isValid,
      );
    } else if (inValue is num) {
      return FhirDecimal._(
        inValue.toString(),
        inValue.toDouble(),
        true,
        int.tryParse(inValue.toString()) != null,
      );
    } else if (inValue is String) {
      final double? parsedDouble = double.tryParse(inValue);

      if (parsedDouble != null) {
        return FhirDecimal._(
          inValue,
          parsedDouble,
          true,
          int.tryParse(inValue) != null,
        );
      }
    }
    throw CannotBeConstructed<FhirDecimal>(
        'Decimal cannot be constructed from $inValue ${inValue.runtimeType}');
  }

  factory FhirDecimal.fromJson(dynamic json) => FhirDecimal(json);

  factory FhirDecimal.fromYaml(dynamic yaml) => yaml is String
      ? FhirDecimal.fromJson(jsonDecode(jsonEncode(loadYaml(yaml))))
      : yaml is YamlMap
          ? FhirDecimal.fromJson(jsonDecode(jsonEncode(yaml)))
          : throw YamlFormatException<FhirDecimal>(
              'FormatException: "$json" is not a valid Yaml string or YamlMap.');

  final bool isInt;
  @override
  double? get value => valueNumber as double?;

  @override
  dynamic toJson() => isInt ? valueNumber?.toInt() : valueNumber;

  @override
  dynamic toYaml() => isInt ? valueNumber?.toInt() : valueNumber;
}
