// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '../lib/utils/keys.dart';

void main() {
  final serverAddress = '192.168.0.14:8080';
  final username = 'tester';
  final roomname = 'testroom';
  final estimatedTask = 'testtask';
  final estimate = '4';

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
    final buttonRequestEstimateOpenDialog = find.byValueKey(Keys.buttonRequestEstimateOpenDialog);
    final buttonRequestEstimateConfirm = find.byValueKey(Keys.buttonRequestEstimateConfirm);
    final inputEstimatedTask = find.byValueKey(Keys.inputEstimatedTask);
    final buttonSendEstimateConfirm = find.byValueKey(Keys.buttonSendEstimateConfirm);
    final textMedianAndAverage = find.byValueKey(Keys.textMedianAndAverage);

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    Future<void> connect() async {
      await driver.waitFor(inputServerAddress);

      await driver.tap(inputServerAddress);

      await driver.enterText(serverAddress);

      await driver.tap(inputUsername);

      await driver.enterText(username);

      await driver.tap(buttonConnect);

      await driver.waitFor(titleLobby);
    }

    Future<void> disconnect() async {
      await driver.tap(locateDrawer);

      await driver.tap(buttonDisconnect);

      await driver.waitFor(inputServerAddress);
    }

    test('connect and disconnect', () async {
      await driver.runUnsynchronized(() async {
        await connect();

        await disconnect();
      });
    });

    test('connect, create room, destroy it, disconnect', () async {
      await driver.runUnsynchronized(() async {
        await connect();

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

        await disconnect();
      });
    });

    test('connect, create room, request estimate, estimate, disconnect', () async {
      await driver.runUnsynchronized(() async {
        await connect();

        await driver.tap(buttonNavigateToCreateRoomScreen);

        await driver.waitFor(inputRoomname);

        await driver.tap(inputRoomname);

        await driver.enterText(roomname);

        await driver.tap(buttonCreateRoom);

        await driver.waitFor(find.text(roomname));

        await driver.tap(buttonRequestEstimateOpenDialog);

        await driver.tap(inputEstimatedTask);

        await driver.enterText(estimatedTask);

        await driver.tap(buttonRequestEstimateConfirm);

        await driver.waitFor(find.text(estimate));

        await driver.tap(find.text(estimate));

        await driver.tap(buttonSendEstimateConfirm);

        await driver.waitFor(textMedianAndAverage);

        await disconnect();
      });
    });
  });
}
