// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type, unnecessary_cast, todo

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Account _$$_AccountFromJson(Map json) => $checkedCreate(
      r'_$_Account',
      json,
      ($checkedConvert) {
        final val = _$_Account(
          accountId: $checkedConvert('accountId', (v) => v as String? ?? ''),
          createdAt: $checkedConvert(
              'createdAt',
              (v) => v == null
                  ? const UnionTimestamp.serverTimestamp()
                  : unionTimestampConverter.fromJson(v as Object)),
          updatedAt: $checkedConvert(
              'updatedAt',
              (v) => v == null
                  ? const UnionTimestamp.serverTimestamp()
                  : alwaysUseServerTimestampUnionTimestampConverter
                      .fromJson(v as Object)),
          isHost: $checkedConvert('isHost', (v) => v as bool? ?? false),
          displayName:
              $checkedConvert('displayName', (v) => v as String? ?? ''),
          imageURL: $checkedConvert('imageURL', (v) => v as String? ?? ''),
          providers: $checkedConvert(
              'providers',
              (v) =>
                  (v as List<dynamic>?)?.map((e) => e as String).toList() ??
                  const <String>[]),
          fcmTokens: $checkedConvert(
              'fcmTokens',
              (v) =>
                  (v as List<dynamic>?)?.map((e) => e as String).toList() ??
                  const <String>[]),
        );
        return val;
      },
    );

Map<String, dynamic> _$$_AccountToJson(_$_Account instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'createdAt': unionTimestampConverter.toJson(instance.createdAt),
      'updatedAt': alwaysUseServerTimestampUnionTimestampConverter
          .toJson(instance.updatedAt),
      'isHost': instance.isHost,
      'displayName': instance.displayName,
      'imageURL': instance.imageURL,
      'providers': instance.providers,
      'fcmTokens': instance.fcmTokens,
    };
