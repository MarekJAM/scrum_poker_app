import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import '../lib/data/models/outgoing_message.dart';
import '../lib/utils/secure_storage.dart';
import '../lib/data/repositories/repositories.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeSecureStorage extends Fake implements SecureStorage {
  @override
  Future<String> readServerAddress() {
    return Future.value("127.0.0.1");
  }

  @override
  Future<String> readUsername() {
    return Future.value("username");
  }
}

void main() {
  group('RoomsApiClient', () {
    http.Client httpClient;
    RoomsApiClient roomsApiClient;

    setUp(() async {
      httpClient = MockHttpClient();
      roomsApiClient = RoomsApiClient(
          httpClient: httpClient, secureStorage: FakeSecureStorage());
    });

    test('throws AssertionError when httpClient is null', () {
      expect(() => RoomsApiClient(httpClient: null), throwsAssertionError);
    });

    group('create room', () {
      test('returns true if room created successfully', () async {
        final mockedResponse = MockResponse();

        when(mockedResponse.statusCode).thenReturn(201);

        when(httpClient.put("http://127.0.0.1/rooms/create",
            headers: {"Content-Type": "application/json"},
            body: OutgoingMessage.createCreateRoomJsonMsg(
              "username",
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
            headers: {"Content-Type": "application/json"},
            body: OutgoingMessage.createCreateRoomJsonMsg(
              "username",
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
            headers: {"Content-Type": "application/json"},
            body: OutgoingMessage.createConnectRoomJsonMsg(
              "username",
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
            headers: {"Content-Type": "application/json"},
            body: OutgoingMessage.createConnectRoomJsonMsg(
              "username",
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

        when(httpClient.patch("http://127.0.0.1/rooms/disconnect",
            headers: {"Content-Type": "application/json"},
            body: OutgoingMessage.createDisconnectFromRoomJsonMsg(
              "username",
            ))).thenAnswer((_) => Future.value(mockedResponse));

        final isDisconnected = await roomsApiClient.disconnectFromRoom();
        expect(isDisconnected, true);
      });

      test('throws Exception when httpClient returns non-200 response',
          () async {
        final mockedResponse = MockResponse();

        when(mockedResponse.statusCode).thenReturn(407);

        when(httpClient.patch("http://127.0.0.1/rooms/disconnect",
            headers: {"Content-Type": "application/json"},
            body: OutgoingMessage.createDisconnectFromRoomJsonMsg(
              "username",
            ))).thenAnswer((_) => Future.value(mockedResponse));

        expect(() async => await roomsApiClient.disconnectFromRoom(),
            throwsA(isException));
      });
    });
  });
}
