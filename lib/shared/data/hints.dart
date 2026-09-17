import 'package:last_launcher/shared/data/fold_for_search.dart';

final _stripPunct = RegExp(r'[^\p{L}\p{N}]', unicode: true);

class SubstringHint {
  const SubstringHint({required this.start, required this.length});

  final int start;
  final int length;

  /// This hint grown by [by] characters, never running past [maxLength].
  SubstringHint extendedBy(int by, int maxLength) => SubstringHint(
    start: start,
    length: (start + length + by).clamp(0, maxLength) - start,
  );
}

/// Returns the shortest unique substring of each display label.
/// Checks uniqueness against both folded (space-preserved) and clean
/// (alphanumeric-only) forms of all labels. Returns null for labels with no
/// unique substring (e.g. duplicates). Result is indexed parallel to the input.
List<SubstringHint?> computeHints(
  List<String> displayLabels,
  List<String> originalLabels,
) {
  final foldedDisplay = displayLabels.map(foldForSearch).toList();
  final foldedOriginal = originalLabels.map(foldForSearch).toList();
  final cleanedDisplay = foldedDisplay
      .map((s) => s.replaceAll(_stripPunct, ''))
      .toList();
  final cleanedOriginal = foldedOriginal
      .map((s) => s.replaceAll(_stripPunct, ''))
      .toList();
  final result = <SubstringHint?>[];

  for (int i = 0; i < displayLabels.length; i++) {
    final f = foldedDisplay[i];
    SubstringHint? best;

    bool uniqueInAll(String sub, int index) {
      for (int j = 0; j < foldedDisplay.length; j++) {
        if (j == index) continue;
        if (foldedDisplay[j].contains(sub)) return false;
        if (j < foldedOriginal.length && foldedOriginal[j].contains(sub)) {
          return false;
        }
      }
      final cleanSub = sub.replaceAll(_stripPunct, '');
      if (cleanSub.isEmpty) return false;
      for (int j = 0; j < cleanedDisplay.length; j++) {
        if (j == index) continue;
        if (cleanedDisplay[j].contains(cleanSub)) return false;
        if (j < cleanedOriginal.length &&
            cleanedOriginal[j].contains(cleanSub)) {
          return false;
        }
      }
      return true;
    }

    for (int len = 1; len <= f.length && best == null; len++) {
      for (int start = 0; start + len <= f.length; start++) {
        final sub = f.substring(start, start + len);
        if (uniqueInAll(sub, i)) {
          best = SubstringHint(start: start, length: len);
          break;
        }
      }
    }

    result.add(best);
  }
  return result;
}

/// Like [computeHints] but uses the search query to anchor hints at the
/// match position. Returns continuation hints without uniqueness constraints.
///
/// Apps whose folded label starts with the query get prefix-aware hints
/// (unique within the start-matching group). Other apps get a simple 1-char
/// continuation from the first match position. Result is indexed parallel to
/// the input.
List<SubstringHint?> computeHintsWithQuery(
  List<String> displayLabels,
  List<String> originalLabels,
  String query,
) {
  final foldedQuery = foldForSearch(query);
  final folded = displayLabels.map(foldForSearch).toList();
  final foldedOriginal = originalLabels.map(foldForSearch).toList();
  final cleaned = folded.map((s) => s.replaceAll(_stripPunct, '')).toList();
  final cleanedOriginal = foldedOriginal
      .map((s) => s.replaceAll(_stripPunct, ''))
      .toList();

  if (query.isEmpty) {
    return computeHints(displayLabels, originalLabels);
  }

  // Pre-compute start-matching indices (needed by _uniquePrefix)
  final startIndices = <int>{};
  for (int i = 0; i < folded.length; i++) {
    if (folded[i].startsWith(foldedQuery)) {
      startIndices.add(i);
    }
  }

  if (displayLabels.length < 2 && startIndices.length == 1) {
    return [
      _uniquePrefix(
        folded[0],
        foldedQuery,
        startIndices,
        folded,
        0,
        foldedOriginal,
        cleaned,
        cleanedOriginal,
      ),
    ];
  }

  if (displayLabels.length < 2) {
    if (displayLabels.isEmpty) return [];
    final f = folded[0];
    final fo = foldedOriginal[0];
    SubstringHint? hint;
    if (f.contains(foldedQuery)) {
      final pos = f.indexOf(foldedQuery);
      hint = SubstringHint(start: pos, length: foldedQuery.length);
    } else if (fo.contains(foldedQuery)) {
      final pos = fo.indexOf(foldedQuery);
      hint = SubstringHint(start: pos, length: foldedQuery.length);
    } else {
      final cleanQuery2 = foldedQuery.replaceAll(_stripPunct, '');
      if (cleanQuery2.length >= 2) {
        hint =
            _cleanMatchHint(f, cleanQuery2) ?? _cleanMatchHint(fo, cleanQuery2);
      }
    }
    return [hint];
  }

  final result = <SubstringHint?>[];

  for (int i = 0; i < displayLabels.length; i++) {
    final f = folded[i];
    final fo = foldedOriginal[i];

    SubstringHint? hint;

    if (startIndices.contains(i)) {
      hint = _uniquePrefix(
        f,
        foldedQuery,
        startIndices,
        folded,
        i,
        foldedOriginal,
        cleaned,
        cleanedOriginal,
      );
    } else if (f.contains(foldedQuery)) {
      final pos = f.indexOf(foldedQuery);
      if (pos + foldedQuery.length < f.length) {
        int hintLen = foldedQuery.length + 1;
        while (pos + hintLen <= f.length &&
            _stripPunct.hasMatch(f[pos + hintLen - 1])) {
          hintLen++;
        }
        for (; pos + hintLen <= f.length; hintLen++) {
          final sub = f.substring(pos, pos + hintLen);
          final subClean = sub.replaceAll(_stripPunct, '');
          bool unique = true;
          for (int j = 0; j < folded.length; j++) {
            if (j == i) continue;
            if (folded[j].contains(sub) || foldedOriginal[j].contains(sub)) {
              unique = false;
              break;
            }
          }
          if (!unique) continue;
          for (final j in startIndices) {
            if (cleaned[j].startsWith(subClean) ||
                cleanedOriginal[j].startsWith(subClean)) {
              unique = false;
              break;
            }
          }
          if (unique) {
            hint = SubstringHint(start: pos, length: hintLen);
            break;
          }
        }
      }
    } else if (fo.contains(foldedQuery)) {
      final pos = fo.indexOf(foldedQuery);
      if (pos + foldedQuery.length < fo.length) {
        int hintLen = foldedQuery.length + 1;
        while (pos + hintLen <= fo.length &&
            _stripPunct.hasMatch(fo[pos + hintLen - 1])) {
          hintLen++;
        }
        for (; pos + hintLen <= fo.length; hintLen++) {
          final sub = fo.substring(pos, pos + hintLen);
          final subClean = sub.replaceAll(_stripPunct, '');
          bool unique = true;
          for (int j = 0; j < foldedOriginal.length; j++) {
            if (j == i) continue;
            if (foldedOriginal[j].contains(sub) || folded[j].contains(sub)) {
              unique = false;
              break;
            }
          }
          if (!unique) continue;
          for (final j in startIndices) {
            if (cleanedOriginal[j].startsWith(subClean) ||
                cleaned[j].startsWith(subClean)) {
              unique = false;
              break;
            }
          }
          if (unique) {
            hint = SubstringHint(start: pos, length: hintLen);
            break;
          }
        }
      }
    } else {
      final cleanQuery = foldedQuery.replaceAll(_stripPunct, '');
      if (cleanQuery.length >= 2) {
        final dc = f.replaceAll(_stripPunct, '');
        final oc = fo.replaceAll(_stripPunct, '');
        if (dc.contains(cleanQuery) || oc.contains(cleanQuery)) {
          hint = _cleanMatchHint(f, cleanQuery);
        }
      }
    }

    result.add(hint);
  }

  return result;
}

/// For start-matching apps: find the shortest prefix (beyond the query) that
/// is unique among start-matching apps (by prefix) and doesn't visually
/// collide with non-start matching apps (by substring).
SubstringHint? _uniquePrefix(
  String foldedLabel,
  String foldedQuery,
  Set<int> startIndices,
  List<String> foldedAll,
  int appIndex,
  List<String> foldedOriginal,
  List<String> cleanedAll,
  List<String> cleanedOriginal,
) {
  int firstLen = foldedQuery.length + 1;
  while (firstLen <= foldedLabel.length &&
      _stripPunct.hasMatch(foldedLabel[firstLen - 1])) {
    firstLen++;
  }
  for (int len = firstLen; len <= foldedLabel.length; len++) {
    final prefix = foldedLabel.substring(0, len);
    final cleanPrefix = prefix.replaceAll(_stripPunct, '');
    bool unique = true;
    for (final j in startIndices) {
      if (j == appIndex) continue;
      if (foldedAll[j].startsWith(prefix)) {
        unique = false;
        break;
      }
    }
    if (!unique) continue;
    // Avoid visual overlap: check non-start apps that match the query.
    for (int j = 0; j < foldedAll.length; j++) {
      if (j == appIndex || startIndices.contains(j)) continue;
      if (foldedAll[j].contains(foldedQuery) &&
          (foldedAll[j].contains(prefix) ||
              foldedOriginal[j].contains(prefix) ||
              cleanedAll[j].contains(cleanPrefix) ||
              cleanedOriginal[j].contains(cleanPrefix))) {
        unique = false;
        break;
      }
    }
    if (unique) return SubstringHint(start: 0, length: len);
  }
  return null;
}

/// For clean-only matches: find where the clean query appears in the clean
/// label and map the position back to the folded label. Returns a hint with
/// 1 char of continuation past the minimum clean-match span.
SubstringHint? _cleanMatchHint(String foldedLabel, String cleanQuery) {
  final kept = <int>[];
  for (int i = 0; i < foldedLabel.length; i++) {
    if (!_stripPunct.hasMatch(foldedLabel[i])) kept.add(i);
  }
  final cleaned = String.fromCharCodes(kept.map(foldedLabel.codeUnitAt));
  final cleanPos = cleaned.indexOf(cleanQuery);
  if (cleanPos == -1) return null;

  final origStart = kept[cleanPos];
  final minLen = kept[cleanPos + cleanQuery.length - 1] - origStart + 1;
  final hintEnd = origStart + minLen + 1;
  if (hintEnd <= foldedLabel.length) {
    return SubstringHint(start: origStart, length: hintEnd - origStart);
  }
  return SubstringHint(
    start: origStart,
    length: foldedLabel.length - origStart,
  );
}
