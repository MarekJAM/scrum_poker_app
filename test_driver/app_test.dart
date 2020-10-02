// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '../lib/utils/keys.dart';

void main() {
  final serverAddress = '192.168.0.14:8080';
  final username = 'tester';
  final roomname = 'testroom';

  group('Basic use cases', () {
    final buttonConnect = find.byValueKey(Keys.buttonConnect);
    final buttonDisconnect = find.byValueKey(Keys.buttonDisconnect);
    final inputServerAddress = find.byValueKey(Keys.inputServerAddress);
    final inputUsername = find.byValueKey(Keys.inputUsername);
    final titleLobby = find.byValueKey(Keys.titleLobby);
    final locateDrawer = find.byTooltip('Open navigation menu');
    final buttonNavigateToCreateRoomScreen = find.byValueKey(Keys.buttonNavigateToCreateRoomScreen);
    final inputRoomname = find.byValueKey(Keys.inputRoomname);
    final buttonCreateRoom = find.byValueKey(Keys.buttonCreateRoom);
    final buttonDestroyRoom = find.byValueKey(Keys.buttonDestroyRoom);
    final buttonDestroyRoomConfirm = find.byValueKey(Keys.buttonDestroyRoomConfirm);

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('connect and disconnect', () async {
      await driver.runUnsynchronized(() async {
        await driver.waitFor(inputServerAddress);

        await driver.tap(inputServerAddress);

        await driver.enterText(serverAddress);

        await driver.tap(inputUsername);

        await driver.enterText(username);

        await driver.tap(buttonConnect);

        await driver.waitFor(titleLobby);

        await driver.tap(locateDrawer);

        await driver.tap(buttonDisconnect);

        await driver.waitFor(inputServerAddress);
      });
    });

    test('connect, create room, destroy it', () async {
      await driver.runUnsynchronized(() async {
        await driver.waitFor(inputServerAddress);

        await driver.tap(inputServerAddress);

        await driver.enterText(serverAddress);

        await driver.tap(inputUsername);

        await driver.enterText(username);

        await driver.tap(buttonConnect);

        await driver.waitFor(titleLobby);

        await driver.tap(buttonNavigateToCreateRoomScreen);

        await driver.waitFor(inputRoomname);

        await driver.tap(inputRoomname);

        await driver.enterText(roomname);

        await driver.tap(buttonCreateRoom);

        await driver.waitFor(find.text(roomname));

        await driver.tap(locateDrawer);

        await driver.tap(buttonDestroyRoom);

        await driver.tap(buttonDestroyRoomConfirm);

        await driver.waitFor(titleLobby);
      });
    });
  });
}
