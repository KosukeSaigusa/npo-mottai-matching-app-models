import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models.dart';

final messageRepositoryProvider =
    Provider.autoDispose<MessageRepository>((_) => MessageRepository());

class MessageRepository {
  MessageRepository();

  static const domainCollectionName = 'message';
  static const domainDocumentName = 'v1Message';
  static const attendingRoomSubCollectionName = 'attendingRooms';
  static const roomSubCollectionName = 'rooms';
  static const userSubCollectionName = 'users';
  static const messageSubCollectionName = 'messages';
  static const readStatusSubCollectionName = 'readStatus';

  final baseRef =
      FirebaseFirestore.instance.collection(domainCollectionName).doc(domainDocumentName);

  CollectionReference<AttendingRoom> attendingRoomsRef({
    required String userId,
  }) =>
      baseRef
          .collection(userSubCollectionName)
          .doc(userId)
          .collection(attendingRoomSubCollectionName)
          .withConverter<AttendingRoom>(
            fromFirestore: (snapshot, _) => AttendingRoom.fromDocumentSnapshot(snapshot),
            toFirestore: (obj, _) => obj.toJson(),
          );

  DocumentReference<AttendingRoom> attendingRoomRef({
    required String userId,
    required String roomId,
  }) =>
      attendingRoomsRef(userId: userId).doc(roomId);

  CollectionReference<Room> get roomsRef =>
      baseRef.collection(roomSubCollectionName).withConverter<Room>(
            fromFirestore: (snapshot, _) => Room.fromDocumentSnapshot(snapshot),
            toFirestore: (obj, _) => obj.toJson(),
          );

  DocumentReference<Room> roomRef({
    required String roomId,
  }) =>
      roomsRef.doc(roomId);

  CollectionReference<Message> messagesRef({
    required String roomId,
  }) =>
      roomRef(roomId: roomId).collection(messageSubCollectionName).withConverter<Message>(
            fromFirestore: (snapshot, _) => Message.fromDocumentSnapshot(snapshot),
            toFirestore: (obj, _) => obj.toJson(),
          );

  DocumentReference<Message> messageRef({
    required String roomId,
    required String messageId,
  }) =>
      messagesRef(roomId: roomId).doc(messageId).withConverter<Message>(
            fromFirestore: (snapshot, _) => Message.fromDocumentSnapshot(snapshot),
            toFirestore: (obj, _) => obj.toJson(),
          );

  CollectionReference<ReadStatus> readStatusesRef({
    required String roomId,
  }) =>
      roomRef(roomId: roomId).collection(readStatusSubCollectionName).withConverter<ReadStatus>(
            fromFirestore: (snapshot, _) => ReadStatus.fromDocumentSnapshot(snapshot),
            toFirestore: (obj, _) => obj.toJson(),
          );

  DocumentReference<ReadStatus> readStatusRef({
    required String roomId,
    required String readStatusId,
  }) =>
      readStatusesRef(roomId: roomId).doc(readStatusId).withConverter<ReadStatus>(
            fromFirestore: (snapshot, _) => ReadStatus.fromDocumentSnapshot(snapshot),
            toFirestore: (obj, _) => obj.toJson(),
          );

  /// AttendingRoom 一覧を取得する。
  Future<List<AttendingRoom>> fetchAttendingRooms({
    required String userId,
    Source source = Source.serverAndCache,
    Query<AttendingRoom>? Function(Query<AttendingRoom> query)? queryBuilder,
    int Function(AttendingRoom lhs, AttendingRoom rhs)? compare,
  }) async {
    Query<AttendingRoom> query = attendingRoomsRef(userId: userId);
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }
    final qs = await query.get(GetOptions(source: source));
    final result = qs.docs.map((qds) => qds.data()).toList();
    if (compare != null) {
      result.sort(compare);
    }
    return result;
  }

  /// AttendingRoom 一覧を購読する。
  Stream<List<AttendingRoom>> subscribeAttendingRooms({
    required String userId,
    Query<AttendingRoom>? Function(Query<AttendingRoom> query)? queryBuilder,
    int Function(AttendingRoom lhs, AttendingRoom rhs)? compare,
  }) {
    Query<AttendingRoom> query = attendingRoomsRef(userId: userId);
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }
    return query.snapshots().map((qs) {
      final result = qs.docs.map((qds) => qds.data()).toList();
      if (compare != null) {
        result.sort(compare);
      }
      return result;
    });
  }

  /// 指定した AttendingRoom を取得する。
  Future<AttendingRoom?> fetchAttendingRoom({
    required String userId,
    required String roomId,
    Source source = Source.serverAndCache,
  }) async {
    final ds =
        await attendingRoomRef(userId: userId, roomId: roomId).get(GetOptions(source: source));
    return ds.data();
  }

  /// 指定した AttendingRoom を購読する。
  Stream<AttendingRoom?> subscribeAttendingRoom({
    required String userId,
    required String roomId,
  }) {
    final docStream = attendingRoomRef(userId: userId, roomId: roomId).snapshots();
    return docStream.map((ds) => ds.data());
  }

  /// Room 一覧を取得する。
  Future<List<Room>> fetchRooms({
    Source source = Source.serverAndCache,
    Query<Room>? Function(Query<Room> query)? queryBuilder,
    int Function(Room lhs, Room rhs)? compare,
  }) async {
    Query<Room> query = roomsRef;
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }
    final qs = await query.get(GetOptions(source: source));
    final result = qs.docs.map((qds) => qds.data()).toList();
    if (compare != null) {
      result.sort(compare);
    }
    return result;
  }

  /// Room 一覧を購読する。
  Stream<List<Room>> subscribeRooms({
    Query<Room>? Function(Query<Room> query)? queryBuilder,
    int Function(Room lhs, Room rhs)? compare,
  }) {
    Query<Room> query = roomsRef;
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }
    return query.snapshots().map((qs) {
      final result = qs.docs.map((qds) => qds.data()).toList();
      if (compare != null) {
        result.sort(compare);
      }
      return result;
    });
  }

  /// 指定した Room を取得する。
  Future<Room?> fetchRoom({
    required String roomId,
    Source source = Source.serverAndCache,
  }) async {
    final ds = await roomRef(roomId: roomId).get(GetOptions(source: source));
    return ds.data();
  }

  /// 指定した Room を購読する。
  Stream<Room?> subscribeRoom({
    required String roomId,
  }) {
    final docStream = roomRef(roomId: roomId).snapshots();
    return docStream.map((ds) => ds.data());
  }

  /// Message 一覧を取得する。
  Future<List<Message>> fetchMessages({
    required String roomId,
    Source source = Source.serverAndCache,
    Query<Message>? Function(Query<Message> query)? queryBuilder,
    int Function(Message lhs, Message rhs)? compare,
  }) async {
    Query<Message> query = messagesRef(roomId: roomId);
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }
    final qs = await query.get(GetOptions(source: source));
    final result = qs.docs.map((qds) => qds.data()).toList();
    if (compare != null) {
      result.sort(compare);
    }
    return result;
  }

  /// Message 一覧を購読する。
  Stream<List<Message>> subscribeMessages({
    required String roomId,
    Query<Message>? Function(Query<Message> query)? queryBuilder,
    int Function(Message lhs, Message rhs)? compare,
  }) {
    Query<Message> query = messagesRef(roomId: roomId);
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }
    return query.snapshots().map((qs) {
      final result = qs.docs.map((qds) => qds.data()).toList();
      if (compare != null) {
        result.sort(compare);
      }
      return result;
    });
  }

  /// 指定した Message を取得する。
  Future<Message?> fetchMessage({
    required String roomId,
    required String messageId,
    Source source = Source.serverAndCache,
  }) async {
    final ds =
        await messageRef(roomId: roomId, messageId: messageId).get(GetOptions(source: source));
    return ds.data();
  }

  /// 指定した Message を購読する。
  Stream<Message?> subscribeMessage({
    required String roomId,
    required String messageId,
  }) {
    final docStream = messageRef(roomId: roomId, messageId: messageId).snapshots();
    return docStream.map((ds) => ds.data());
  }

  /// ReadStatus 一覧を取得する。
  Future<List<ReadStatus>> fetchReadStatuses({
    required String roomId,
    Source source = Source.serverAndCache,
    Query<ReadStatus>? Function(Query<ReadStatus> query)? queryBuilder,
    int Function(ReadStatus lhs, ReadStatus rhs)? compare,
  }) async {
    Query<ReadStatus> query = readStatusesRef(roomId: roomId);
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }
    final qs = await query.get(GetOptions(source: source));
    final result = qs.docs.map((qds) => qds.data()).toList();
    if (compare != null) {
      result.sort(compare);
    }
    return result;
  }

  /// ReadStatus 一覧を購読する。
  Stream<List<ReadStatus>> subscribeReadStatuses({
    required String roomId,
    Query<ReadStatus>? Function(Query<ReadStatus> query)? queryBuilder,
    int Function(ReadStatus lhs, ReadStatus rhs)? compare,
    bool excludePendingWrites = false,
  }) {
    Query<ReadStatus> query = readStatusesRef(roomId: roomId);
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }
    var collectionStream = query.snapshots();
    if (excludePendingWrites) {
      collectionStream = collectionStream.where((qs) => !qs.metadata.hasPendingWrites);
    }
    return collectionStream.map((qs) {
      final result = qs.docs.map((qds) => qds.data()).toList();
      if (compare != null) {
        result.sort(compare);
      }
      return result;
    });
  }

  /// 指定した ReadStatus を取得する。
  Future<ReadStatus?> fetchReadStatus({
    required String roomId,
    required String readStatusId,
    Source source = Source.serverAndCache,
  }) async {
    final ds = await readStatusRef(roomId: roomId, readStatusId: readStatusId)
        .get(GetOptions(source: source));
    return ds.data();
  }

  /// 指定した ReadStatus を購読する。
  Stream<ReadStatus?> subscribeReadStatus({
    required String roomId,
    required String readStatusId,
    bool excludePendingWrites = false,
  }) {
    var docStream = readStatusRef(roomId: roomId, readStatusId: readStatusId).snapshots();
    if (excludePendingWrites) {
      docStream = docStream.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return docStream.map((ds) {
      final data = ds.data();
      return data;
    });
  }
}
