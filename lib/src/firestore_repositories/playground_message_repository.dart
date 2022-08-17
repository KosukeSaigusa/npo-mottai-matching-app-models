import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../firestore_models/playground_message.dart';

final playgroundMessageRepositoryProvider =
    Provider.autoDispose<PlaygroundMessageRepository>((_) => PlaygroundMessageRepository());

class PlaygroundMessageRepository {
  PlaygroundMessageRepository();

  static const collectionName = 'playgroundMessages';

  final playgroundMessagesRef =
      FirebaseFirestore.instance.collection(collectionName).withConverter<PlaygroundMessage>(
            fromFirestore: (snapshot, _) => PlaygroundMessage.fromDocumentSnapshot(snapshot),
            toFirestore: (obj, _) => obj.toJson(),
          );

  DocumentReference<PlaygroundMessage> playgroundMessageRef({
    required String playgroundMessageId,
  }) =>
      playgroundMessagesRef.doc(playgroundMessageId).withConverter<PlaygroundMessage>(
            fromFirestore: (snapshot, _) => PlaygroundMessage.fromDocumentSnapshot(snapshot),
            toFirestore: (obj, _) => obj.toJson(),
          );

  /// PlaygroundMessage 一覧を取得する。
  Future<List<PlaygroundMessage>> fetchPlaygroundMessages({
    Source source = Source.serverAndCache,
    Query<PlaygroundMessage>? Function(Query<PlaygroundMessage> query)? queryBuilder,
    int Function(PlaygroundMessage lhs, PlaygroundMessage rhs)? compare,
  }) async {
    Query<PlaygroundMessage> query = playgroundMessagesRef;
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

  /// PlaygroundMessage 一覧を購読する。
  Stream<List<PlaygroundMessage>> subscribePlaygroundMessages({
    Query<PlaygroundMessage>? Function(Query<PlaygroundMessage> query)? queryBuilder,
    int Function(PlaygroundMessage lhs, PlaygroundMessage rhs)? compare,
  }) {
    Query<PlaygroundMessage> query = playgroundMessagesRef;
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

  /// 指定した PlaygroundMessage を取得する。
  Future<PlaygroundMessage?> fetchPlaygroundMessage({
    required String playgroundMessageId,
    Source source = Source.serverAndCache,
  }) async {
    final ds = await playgroundMessageRef(playgroundMessageId: playgroundMessageId)
        .get(GetOptions(source: source));
    return ds.data();
  }

  /// 指定した PlaygroundMessage を購読する。
  Stream<PlaygroundMessage?> subscribePlaygroundMessage({
    required String playgroundMessageId,
  }) {
    final docStream = playgroundMessageRef(playgroundMessageId: playgroundMessageId).snapshots();
    return docStream.map((ds) => ds.data());
  }
}
