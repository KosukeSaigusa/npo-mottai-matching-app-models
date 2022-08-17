import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../firestore_models/account.dart';

final accountRepositoryProvider =
    Provider.autoDispose<AccountRepository>((_) => AccountRepository());

class AccountRepository {
  AccountRepository();

  static const collectionName = 'accounts';

  final accountsRef = FirebaseFirestore.instance.collection(collectionName).withConverter<Account>(
        fromFirestore: (snapshot, _) => Account.fromDocumentSnapshot(snapshot),
        toFirestore: (obj, _) => obj.toJson(),
      );

  DocumentReference<Account> accountRef({
    required String accountId,
  }) =>
      accountsRef.doc(accountId).withConverter<Account>(
            fromFirestore: (snapshot, _) => Account.fromDocumentSnapshot(snapshot),
            toFirestore: (obj, _) => obj.toJson(),
          );

  /// Account 一覧を取得する。
  Future<List<Account>> fetchAccounts({
    Source source = Source.serverAndCache,
    Query<Account>? Function(Query<Account> query)? queryBuilder,
    int Function(Account lhs, Account rhs)? compare,
  }) async {
    Query<Account> query = accountsRef;
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

  /// Account 一覧を購読する。
  Stream<List<Account>> subscribeAccounts({
    Query<Account>? Function(Query<Account> query)? queryBuilder,
    int Function(Account lhs, Account rhs)? compare,
  }) {
    Query<Account> query = accountsRef;
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

  /// 指定した Account を取得する。
  Future<Account?> fetchAccount({
    required String accountId,
    Source source = Source.serverAndCache,
  }) async {
    final ds = await accountRef(accountId: accountId).get(GetOptions(source: source));
    return ds.data();
  }

  /// 指定した Account を購読する。
  Stream<Account?> subscribeAccount({
    required String accountId,
  }) {
    final docStream = accountRef(accountId: accountId).snapshots();
    return docStream.map((ds) => ds.data());
  }
}
