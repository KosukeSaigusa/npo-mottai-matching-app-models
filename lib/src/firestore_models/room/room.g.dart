// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Room _$$_RoomFromJson(Map<String, dynamic> json) => _$_Room(
      roomId: json['roomId'] as String,
      hostId: json['hostId'] as String,
      workerId: json['workerId'] as String,
      updatedAt: const AutoTimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$_RoomToJson(_$_Room instance) => <String, dynamic>{
      'roomId': instance.roomId,
      'hostId': instance.hostId,
      'workerId': instance.workerId,
      'updatedAt': const AutoTimestampConverter().toJson(instance.updatedAt),
    };