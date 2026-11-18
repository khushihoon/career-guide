// test/support/memory_xp_store.dart
//
// In-memory XpStore that behaves like a real transactional database:
//   • OPTIMISTIC CONCURRENCY — every document has a version; a transaction
//     records the versions it read and aborts at commit if any changed, then
//     the body is re-run (exactly what Firestore does on contention);
//   • bodies of concurrent transactions genuinely INTERLEAVE (reads yield to
//     the event loop), so duplicate requests race for real;
//   • `create` fails the commit if the document exists;
//   • commits are atomic (all or nothing);
//   • fault injection: abort the next N commits, or fail a commit hard.
import 'dart:convert';

import '../../../backend/xp_gateway_core.dart';

class MemoryXpStore implements XpStore {
  final Map<String, Json> docs = <String, Json>{};
  final Map<String, int> _versions = <String, int>{};

  /// Number of times a transaction body was executed (retries included).
  int bodyRuns = 0;
  int commits = 0;

  /// Abort (retryable) the next N commit attempts before applying anything.
  int abortNextCommits = 0;

  /// If set, the next commit throws this (non-retryable) and applies nothing.
  Object? failNextCommitWith;

  /// If set, the next read throws this.
  Object? failNextReadWith;

  static const int maxAttempts = 8;

  String snapshot() => jsonEncode(docs);

  @override
  Future<T> runTransaction<T>(Future<T> Function(XpTx tx) body) async {
    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      bodyRuns++;
      final tx = _MemTx(this);
      final result = await body(tx);

      if (abortNextCommits > 0) {
        abortNextCommits--;
        continue;
      }
      final hard = failNextCommitWith;
      if (hard != null) {
        failNextCommitWith = null;
        throw hard;
      }
      if (tx.tryCommit()) {
        commits++;
        return result;
      }
      // contention: another transaction changed something we read/created
      await Future<void>.delayed(Duration.zero);
    }
    throw StateError('transaction did not commit after $maxAttempts attempts');
  }

  int _versionOf(String path) => _versions[path] ?? 0;

  static Json _copy(Json j) =>
      Map<String, dynamic>.from(jsonDecode(jsonEncode(j)) as Map);
}

class _MemTx implements XpTx {
  _MemTx(this._store);
  final MemoryXpStore _store;
  final Map<String, int> _readVersions = <String, int>{};
  final List<void Function(Map<String, Json>)> _ops = [];
  final Set<String> _createdPaths = <String>{};
  final Set<String> _touched = <String>{};
  bool _wrote = false;

  @override
  Future<Json?> get(String path) async {
    if (_wrote) throw StateError('Reads must happen before the first write.');
    final fail = _store.failNextReadWith;
    if (fail != null) {
      _store.failNextReadWith = null;
      throw fail;
    }
    // Yield so concurrent transactions interleave between reads.
    await Future<void>.delayed(Duration.zero);
    _readVersions[path] = _store._versionOf(path);
    final d = _store.docs[path];
    return d == null ? null : MemoryXpStore._copy(d);
  }

  @override
  void create(String path, Json data) {
    _wrote = true;
    _createdPaths.add(path);
    _touched.add(path);
    final copy = MemoryXpStore._copy(data);
    _ops.add((docs) => docs[path] = copy);
  }

  @override
  void merge(String path, Json data) {
    _wrote = true;
    _touched.add(path);
    final copy = MemoryXpStore._copy(data);
    _ops.add((docs) => docs[path] = <String, dynamic>{...?docs[path], ...copy});
  }

  @override
  void increment(String path, Map<String, num> deltas) {
    _wrote = true;
    _touched.add(path);
    _ops.add((docs) {
      final d = docs[path] = <String, dynamic>{...?docs[path]};
      deltas.forEach((k, v) => d[k] = ((d[k] as num?) ?? 0) + v);
    });
  }

  @override
  void arrayUnion(String path, String field, List<String> values) {
    _wrote = true;
    _touched.add(path);
    _ops.add((docs) {
      final d = docs[path] = <String, dynamic>{...?docs[path]};
      final list = List<dynamic>.from((d[field] as List?) ?? const []);
      for (final v in values) {
        if (!list.contains(v)) list.add(v);
      }
      d[field] = list;
    });
  }

  /// Returns false on contention (version changed / create precondition).
  bool tryCommit() {
    for (final e in _readVersions.entries) {
      if (_store._versionOf(e.key) != e.value) return false;
    }
    for (final p in _createdPaths) {
      if (_store.docs.containsKey(p)) return false;
    }
    final work = <String, Json>{
      for (final e in _store.docs.entries) e.key: MemoryXpStore._copy(e.value),
    };
    for (final op in _ops) {
      op(work);
    }
    _store.docs
      ..clear()
      ..addAll(work);
    for (final p in _touched) {
      _store._versions[p] = _store._versionOf(p) + 1;
    }
    return true;
  }
}
