// ══════════════════════════════════════════════════════════════════════
// lib/services/safe_doc_id.dart
//
// Pure Dart (no Flutter, no Firebase). Byte-for-byte port of
// CopilotFirestoreService._safeId so the trusted backend resolves the SAME
// document ids as the app does for existing, historical data.
//
//   • Short, safe ids pass through unchanged.
//   • Ids containing '/' or control characters, or longer than 1400 UTF-8
//     bytes, become "<escaped 24-char prefix>~<fnv1a-64 hex>".
//
// Do NOT change the algorithm: doing so would let already-awarded events be
// awarded again under a different document id.
// ══════════════════════════════════════════════════════════════════════

const int _maxIdBytes = 1400;

String safeDocId(String? raw) {
  final t = (raw ?? '').trim();
  if (t.isEmpty) return '';

  final utf8Len = _utf8ByteLength(t);
  if (utf8Len <= _maxIdBytes && !_needsEscaping(t)) {
    return t;
  }

  final digest = _stableHashHex(t);
  const prefixLen = 24;
  final prefix = t.length <= prefixLen ? t : t.substring(0, prefixLen);
  final safePrefix = _escapeForDocId(prefix);
  return '$safePrefix~$digest';
}

bool _needsEscaping(String s) {
  for (final rune in s.runes) {
    if (rune == 0x2F) return true;
    if (rune < 0x20) return true;
    if (rune == 0x7F) return true;
  }
  return false;
}

String _escapeForDocId(String s) {
  final buf = StringBuffer();
  for (final rune in s.runes) {
    if (rune == 0x2F) {
      buf.write('%2F');
    } else if (rune < 0x20 || rune == 0x7F) {
      buf.write('%');
      buf.write(rune.toRadixString(16).padLeft(2, '0').toUpperCase());
    } else {
      buf.writeCharCode(rune);
    }
  }
  return buf.toString();
}

int _utf8ByteLength(String s) {
  var n = 0;
  for (final rune in s.runes) {
    if (rune <= 0x7F) {
      n += 1;
    } else if (rune <= 0x7FF) {
      n += 2;
    } else if (rune <= 0xFFFF) {
      n += 3;
    } else {
      n += 4;
    }
  }
  return n;
}

String _stableHashHex(String s) {
  var hash = BigInt.parse('0xcbf29ce484222325');
  final prime = BigInt.parse('0x100000001b3');
  final mask = BigInt.parse('0xFFFFFFFFFFFFFFFF');
  for (final codeUnit in s.codeUnits) {
    hash = (hash ^ BigInt.from(codeUnit)) & mask;
    hash = (hash * prime) & mask;
  }
  return hash.toRadixString(16).padLeft(16, '0');
}