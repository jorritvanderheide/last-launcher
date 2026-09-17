import 'package:flutter_test/flutter_test.dart';
import 'package:last_launcher/features/app_drawer/ranking.dart';
import 'package:last_launcher/shared/data/hints.dart';
import 'package:last_launcher/shared/data/models.dart';

AppInfo _app(String label) => AppInfo(
  packageName: label.toLowerCase().replaceAll(' ', '.'),
  label: label,
);

List<String> _rank(
  List<AppInfo> apps, {
  String searchTerm = '',
  Map<String, SubstringHint?> hints = const {},
  bool sortByHint = false,
  String Function(AppInfo)? searchLabel,
}) {
  return rankApps(
    apps: apps,
    searchTerm: searchTerm,
    hints: hints,
    sortByHint: sortByHint,
    searchLabel: searchLabel ?? (app) => app.label,
  ).map((a) => a.label).toList();
}

SubstringHint _hint(int length) => SubstringHint(start: 0, length: length);

void main() {
  group('rankApps', () {
    test('sorts alphabetically without a search term', () {
      final apps = [_app('Signal'), _app('Camera'), _app('maps')];
      expect(_rank(apps), ['Camera', 'maps', 'Signal']);
    });

    test('puts prefix matches before substring matches', () {
      final apps = [_app('Google Maps'), _app('Maps'), _app('Mail')];
      expect(_rank(apps, searchTerm: 'map'), ['Maps', 'Google Maps', 'Mail']);
    });

    test('ranks hinted apps first and shorter hints higher', () {
      final signal = _app('Signal');
      final settings = _app('Settings');
      final slack = _app('Slack');
      final hints = {
        signal.key: _hint(3),
        slack.key: _hint(2),
        settings.key: null,
      };
      expect(
        _rank(
          [settings, signal, slack],
          searchTerm: 's',
          hints: hints,
          sortByHint: true,
        ),
        ['Slack', 'Signal', 'Settings'],
      );
    });

    test('hint rank outweighs prefix rank', () {
      final exact = _app('Slack');
      final other = _app('Mastodon');
      final hints = {other.key: _hint(1), exact.key: _hint(2)};
      expect(
        _rank([exact, other], searchTerm: 'sl', hints: hints, sortByHint: true),
        ['Mastodon', 'Slack'],
      );
    });

    test('falls back to prefix rank when hints tie', () {
      final a = _app('Telegram');
      final b = _app('Signal');
      final hints = {a.key: _hint(2), b.key: _hint(2)};
      expect(_rank([a, b], searchTerm: 'sig', hints: hints, sortByHint: true), [
        'Signal',
        'Telegram',
      ]);
    });

    test('ranks on the label the match was found in', () {
      const renamed = AppInfo(packageName: 'com.chat', label: 'Chat');
      final other = _app('Chats');
      // The drawer shows the original label but matched a custom one.
      expect(
        _rank(
          [other, renamed],
          searchTerm: 'a',
          searchLabel: (app) => app.packageName == 'com.chat' ? 'Aaa' : 'Chats',
        ),
        ['Chat', 'Chats'],
      );
    });

    test('keeps non-matching apps last', () {
      final apps = [_app('Alpha'), _app('Beta')];
      // 'et' is a substring of Beta only; Alpha matched some other way.
      expect(_rank(apps, searchTerm: 'et'), ['Beta', 'Alpha']);
    });
  });
}
