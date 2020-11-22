import 'package:flutter_test/flutter_test.dart' hide Fake;
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../lib/data/models/outgoing_message.dart';
import '../lib/data/repositories/repositories.dart';
import '../lib/utils/session_data_singleton.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeSessionDataSingleton extends Fake implements SessionDataSingleton {
  @override
  Future<void> init() async {}

  @override
  String getServerAddress() {
    return "127.0.0.1";
  }

  Future<void> setServerAddress(String url) async {}

  @override
  String getUsername() {
    return "username";
  }

  Future<void> setUsername(String username) async {}

  @override
  String getToken() {
    return "token";
  }

  Future<void> setToken(String token) async {}

  @override
  String getAppVersion() {
    return "1.0";
  }
}

void main() {
  group('RoomsApiClient', () {
    http.Client httpClient;
    RoomsApiClient roomsApiClient;
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Authorization": 'Bearer token'
    };

    setUp(() async {
      httpClient = MockHttpClient();
      roomsApiClient = RoomsApiClient(
        httpClient: httpClient,
        sessionDataSingleton: FakeSessionDataSingleton(),
      );
    });

    test('throws AssertionError when httpClient is null', () {
      expect(() => RoomsApiClient(httpClient: null), throwsAssertionError);
    });

    group('create room', () {
      test('returns true if room created successfully', () async {
        final mockedResponse = MockResponse();

        when(mockedResponse.statusCode).thenReturn(201);

        when(httpClient.put("http://127.0.0.1/rooms/create",
            headers: requestHeaders,
            body: OutgoingMessage.createCreateRoomJsonMsg(
              "testname",
            ))).thenAnswer((_) => Future.value(mockedResponse));

        final isCreated = await roomsApiClient.createRoom("testname");

        expect(isCreated, true);
      });

      test('throws Exception when httpClient returns non-201 response',
          () async {
        final mockedResponse = MockResponse();

        when(mockedResponse.statusCode).thenReturn(404);

        when(httpClient.put("http://127.0.0.1/rooms/create",
            headers: requestHeaders,
            body: OutgoingMessage.createCreateRoomJsonMsg(
              "testname",
            ))).thenAnswer((_) => Future.value(mockedResponse));

        expect(() async => await roomsApiClient.createRoom("testname"),
            throwsA(isException));
      });
    });

    group('connect to room', () {
      test('returns true if connected to room', () async {
        final mockedResponse = MockResponse();

        when(mockedResponse.statusCode).thenReturn(200);

        when(httpClient.patch("http://127.0.0.1/rooms/connect",
            headers: requestHeaders,
            body: OutgoingMessage.createConnectRoomJsonMsg(
              "testname",
            ))).thenAnswer((_) => Future.value(mockedResponse));

        final isConnected = await roomsApiClient.connectToRoom("testname");
        expect(isConnected, true);
      });

      test('throws Exception when httpClient returns non-200 response',
          () async {
        final mockedResponse = MockResponse();

        when(mockedResponse.statusCode).thenReturn(404);

        when(httpClient.patch("http://127.0.0.1/rooms/connect",
            headers: requestHeaders,
            body: OutgoingMessage.createConnectRoomJsonMsg(
              "testname",
            ))).thenAnswer((_) => Future.value(mockedResponse));

        expect(() async => await roomsApiClient.connectToRoom("testname"),
            throwsA(isException));
      });
    });

    group('disconnect from room', () {
      test('returns true if disconnected from room', () async {
        final mockedResponse = MockResponse();

        when(mockedResponse.statusCode).thenReturn(200);

        when(httpClient.patch(
          "http://127.0.0.1/rooms/disconnect",
          headers: requestHeaders,
        )).thenAnswer((_) => Future.value(mockedResponse));

        final isDisconnected = await roomsApiClient.disconnectFromRoom();
        expect(isDisconnected, true);
      });

      test('throws Exception when httpClient returns non-200 response',
          () async {
        final mockedResponse = MockResponse();

        when(mockedResponse.statusCode).thenReturn(407);

        when(httpClient.patch(
          "http://127.0.0.1/rooms/disconnect",
          headers: requestHeaders,
        )).thenAnswer((_) => Future.value(mockedResponse));

        expect(() async => await roomsApiClient.disconnectFromRoom(),
            throwsA(isException));
      });
    });

    group('destroy the room', () {
      test('returns true if room destroyed', () async {
        final mockedResponse = MockResponse();

        when(mockedResponse.statusCode).thenReturn(200);

        when(httpClient.delete(
          "http://127.0.0.1/rooms/destroy",
          headers: requestHeaders,
        )).thenAnswer((_) => Future.value(mockedResponse));

        final isDisconnected = await roomsApiClient.destroyRoom();
        expect(isDisconnected, true);
      });

      test('throws Exception when httpClient returns non-200 response',
          () async {
        final mockedResponse = MockResponse();

        when(mockedResponse.statusCode).thenReturn(407);

        when(httpClient.delete(
          "http://127.0.0.1/rooms/destroy",
          headers: requestHeaders,
        )).thenAnswer((_) => Future.value(mockedResponse));

        expect(() async => await roomsApiClient.destroyRoom(),
            throwsA(isException));
      });
    });
  });
}
