import 'package:flutter_test/flutter_test.dart';
import 'package:last_launcher/features/app_drawer/prefixes.dart';
import 'package:last_launcher/features/app_drawer/search.dart';
import 'package:last_launcher/features/settings/settings_state.dart';
import 'package:last_launcher/shared/data/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _web = SearchPrefix(
  trigger: 'g ',
  name: 'Web',
  action: OpenLink('https://duckduckgo.com/?q=%s'),
);
const _maps = SearchPrefix(
  trigger: 'gm ',
  name: 'Maps',
  action: OpenLink('geo:0,0?q=%s'),
);
const _mine = [...defaultPrefixes, _web, _maps];

SearchQuery _parse(String query, {bool profile = true}) =>
    SearchQuery.parse(query, prefixes: _mine, allowProfileFilter: profile);

void main() {
  group('defaults behave as before', () {
    test('"." is work apps and a space personal ones', () {
      expect(SearchQuery.parse('.mail').requireWorkApp, true);
      expect(SearchQuery.parse('.mail').searchTerm, 'mail');
      expect(SearchQuery.parse(' mail').requireWorkApp, false);
      expect(SearchQuery.parse('mail').requireWorkApp, isNull);
    });

    test('without a work profile they are plain text', () {
      final parsed = SearchQuery.parse('.mail', allowProfileFilter: false);
      expect(parsed.requireWorkApp, isNull);
      expect(parsed.searchTerm, '.mail');
    });
  });

  group('matching', () {
    test('the longest trigger wins', () {
      expect(_parse('gm Dam 1').action?.prefix.name, 'Maps');
      expect(_parse('g cats').action?.prefix.name, 'Web');
    });

    test('ignores case, as the keyboard capitalises', () {
      final parsed = _parse('G cats');
      expect(parsed.action?.prefix.name, 'Web');
      expect(parsed.action?.argument, 'cats');
    });

    test('an action searches no apps', () {
      final parsed = _parse('g cats');
      expect(parsed.searchTerm, '');
      expect(
        searchApps(
          const [AppInfo(packageName: 'a', label: 'Gallery')],
          'g cats',
          prefixes: _mine,
        ),
        isEmpty,
      );
    });

    test('actions work without a work profile, filters do not', () {
      expect(_parse('g cats', profile: false).action, isNotNull);
      expect(_parse('.mail', profile: false).requireWorkApp, isNull);
    });

    test('a disabled prefix is ignored', () {
      final off = [_web.copyWith(enabled: false)];
      expect(SearchQuery.parse('g cats', prefixes: off).action, isNull);
    });

    test('a trigger longer than the query does not match', () {
      expect(_parse('g').action, isNull);
    });
  });

  group('links', () {
    test('the query is encoded into the link', () {
      const link = OpenLink('https://duckduckgo.com/?q=%s');
      expect(
        link.linkFor(' cats & dogs '),
        'https://duckduckgo.com/?q=cats%20%26%20dogs',
      );
      expect(
        const OpenLink('geo:0,0?q=%s').linkFor('Dam 1'),
        'geo:0,0?q=Dam%201',
      );
    });
  });

  group('storage', () {
    test('round-trips every kind of prefix', () {
      final list = [
        ...defaultPrefixes,
        const SearchPrefix(
          trigger: 'm ',
          name: 'Maps',
          action: OpenLink('geo:0,0?q=%s', openWith: 'app.organicmaps'),
          enabled: false,
        ),
        const SearchPrefix(trigger: 's ', action: SearchInApp('com.music')),
      ];
      final back = SearchPrefix.decodeList(SearchPrefix.encodeList(list))!;
      expect(back.map((p) => p.trigger), ['.', ' ', 'm ', 's ']);
      expect((back[2].action as OpenLink).openWith, 'app.organicmaps');
      expect(back[2].enabled, isFalse);
      expect((back[3].action as SearchInApp).package, 'com.music');
      expect((back[0].action as FilterApps).work, isTrue);
    });

    test('skips entries it cannot read, keeps the rest', () {
      final back = SearchPrefix.decodeList(
        '[{"trigger":"x","action":{"type":"teleport"}},'
        '{"trigger":"g ","action":{"type":"link","template":"%s"}}]',
      )!;
      expect(back.single.trigger, 'g ');
    });

    test('settings start with the defaults and keep an empty list', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final settings = SettingsState(prefs);
      expect(settings.searchPrefixes.value.map((p) => p.trigger), ['.', ' ']);

      settings.searchPrefixes.value = const [];
      expect(SettingsState(prefs).searchPrefixes.value, isEmpty);
    });
  });
}
