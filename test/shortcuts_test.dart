import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:last_launcher/features/app_drawer/app_list_state.dart';
import 'package:last_launcher/shared/data/app_channel.dart';
import 'package:last_launcher/shared/data/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAppChannel extends AppChannel {
  _FakeAppChannel(this.apps);

  List<AppInfo> apps;

  @override
  Future<List<AppInfo>> getInstalledApps() async => apps;

  @override
  Future<bool> hasWorkProfile() async => false;
}

const _browser = AppInfo(packageName: 'org.browser', label: 'Browser');
const _webApp = AppInfo(
  packageName: 'org.browser',
  label: 'News',
  shortcutId: 'web-news',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('keys', () {
    test('app keys keep their shape', () {
      expect(_browser.key, 'org.browser|false');
    });

    test('a shortcut has its own key, apart from its app', () {
      expect(_webApp.key, 'org.browser|false|web-news');
      expect(_webApp.key, isNot(_browser.key));
      expect(AppInfo.packageOfKey(_webApp.key), 'org.browser');
    });

    test('work shortcuts are recognised as work entries', () {
      const work = AppInfo(
        packageName: 'org.browser',
        label: 'News',
        isWorkApp: true,
        shortcutId: 'web-news',
      );
      expect(AppInfo.isWorkKey(work.key), isTrue);
      expect(AppInfo.isWorkKey(_webApp.key), isFalse);
    });
  });

  group('pinned', () {
    test('a pinned shortcut keeps its id', () {
      const pinned = PinnedApp(
        packageName: 'org.browser',
        label: 'News',
        shortcutId: 'web-news',
      );
      final restored = PinnedApp.decodeList(PinnedApp.encodeList([pinned]));
      expect(restored.single.shortcutId, 'web-news');
      expect(restored.single.key, _webApp.key);
    });

    test('pins saved before shortcuts existed still read as apps', () {
      final restored = PinnedApp.decodeList(
        jsonEncode([
          {'packageName': 'org.browser', 'label': 'Browser'},
        ]),
      );
      expect(restored.single.shortcutId, isNull);
      expect(restored.single.key, _browser.key);
    });
  });

  group('app list', () {
    Future<AppListState> load(
      List<AppInfo> apps, {
      Map<String, Object> stored = const {},
    }) async {
      SharedPreferences.setMockInitialValues(stored);
      final state = AppListState(
        _FakeAppChannel(apps),
        await SharedPreferences.getInstance(),
      );
      await state.loadApps();
      return state;
    }

    test('hiding a shortcut leaves its app alone', () async {
      final state = await load([_browser, _webApp]);
      state.hideApp(_webApp.key);
      expect(state.isHidden(_webApp.key), isTrue);
      expect(state.isHidden(_browser.key), isFalse);
      expect(state.search('').map((a) => a.label), ['Browser']);
    });

    test('renaming a shortcut leaves its app alone', () async {
      final state = await load([_browser, _webApp]);
      state.setCustomLabel(_webApp.key, 'Morning paper');
      expect(state.displayLabel(_webApp), 'Morning paper');
      expect(state.displayLabel(_browser), 'Browser');
    });

    test('a paused work shortcut keeps its label', () async {
      const workKey = 'org.browser|true|web-news';
      final state = await load(
        [_browser],
        stored: {
          'custom_labels': jsonEncode({workKey: 'Work news'}),
        },
      );
      expect(state.displayLabelFor(workKey, 'fallback'), 'Work news');
    });
  });

  group('channel', () {
    const channel = MethodChannel('nl.bw20.last_launcher/apps');
    final calls = <MethodCall>[];

    setUp(() {
      calls.clear();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            calls.add(call);
            if (call.method == 'getInstalledApps') {
              return [
                {'packageName': 'org.browser', 'label': 'Browser'},
                {
                  'packageName': 'org.browser',
                  'label': 'News',
                  'shortcutId': 'web-news',
                },
              ];
            }
            return null;
          });
    });

    tearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null),
    );

    test('lists shortcuts next to apps', () async {
      final apps = await AppChannel().getInstalledApps();
      expect(apps.map((a) => a.shortcutId), [null, 'web-news']);
    });

    test('opens links and searches in apps', () async {
      await AppChannel().openLink('geo:0,0?q=Dam%201', package: 'app.maps');
      await AppChannel().openLink('https://example.org');
      await AppChannel().searchInApp('com.music', 'jazz');
      final args = calls.map((c) => c.arguments as Map).toList();
      expect(calls.map((c) => c.method), [
        'openLink',
        'openLink',
        'searchInApp',
      ]);
      expect(args[0], {'uri': 'geo:0,0?q=Dam%201', 'package': 'app.maps'});
      expect(args[1].containsKey('package'), isFalse);
      expect(args[2], {'package': 'com.music', 'query': 'jazz'});
    });

    test('launches a shortcut by id, an app without one', () async {
      await AppChannel().launchApp('org.browser', shortcutId: 'web-news');
      await AppChannel().launchApp('org.browser');
      final args = calls.map((c) => c.arguments as Map).toList();
      expect(args[0]['shortcutId'], 'web-news');
      expect(args[1].containsKey('shortcutId'), isFalse);
    });
  });
}
