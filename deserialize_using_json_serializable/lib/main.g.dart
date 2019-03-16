// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) {
  return new Person(json['name'] as String, json['addr1'] as String,
      json['city'] as String, json['state'] as String);
}

abstract class _$PersonSerializerMixin {
  String get name;
  String get addressLine1;
  String get addressCity;
  String get addressState;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'addr1': addressLine1,
        'city': addressCity,
        'state': addressState
      };
}
