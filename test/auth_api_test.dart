import 'package:flutter_test/flutter_test.dart' hide Fake;
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../lib/data/repositories/auth_api_client.dart';
import '../lib/data/models/outgoing_message.dart';
import '../lib/data/repositories/repositories.dart';
import 'fake_session_data_singleton.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

void main() {
  group('AuthApiClient', () {
    http.Client httpClient;
    AuthApiClient authApiClient;
    Map<String, String> requestHeaders = {"Content-Type": "application/json"};
    Map<String, String> requestHeadersWithToken = {
      "Content-Type": "application/json",
      "Authorization": "Bearer token"
    };

    setUp(() async {
      httpClient = MockHttpClient();
      authApiClient = AuthApiClient(
        httpClient: httpClient,
        sessionDataSingleton: FakeSessionDataSingleton(),
      );
    });

    test('throws AssertionError when httpClient is null', () {
      expect(() => AuthApiClient(httpClient: null), throwsAssertionError);
    });

    group('login with password', () {
      test('returns true if logged successfully', () async {
        final mockedResponse = MockResponse();

        when(mockedResponse.statusCode).thenReturn(200);
        when(mockedResponse.body).thenReturn('{"token": "token"}');

        when(httpClient.post(
          Uri.parse("http://127.0.0.1/auth/login"),
          headers: requestHeaders,
          body: OutgoingMessage.createLoginMessage("testname", "password"),
        )).thenAnswer((_) => Future.value(mockedResponse));

        final isLogged =
            await authApiClient.loginWithCredentials("testname", "password");

        expect(isLogged, true);
      });

      test('throws Exception when httpClient returns non-200 response',
          () async {
        final mockedResponse = MockResponse();

        when(mockedResponse.statusCode).thenReturn(404);

        when(httpClient.post(
          Uri.parse("http://127.0.0.1/auth/login"),
          headers: requestHeaders,
          body: OutgoingMessage.createLoginMessage(
            "testname",
            "password",
          ),
        )).thenAnswer((_) => Future.value(mockedResponse));

        expect(
          () async =>
              await authApiClient.loginWithCredentials("testname", "password"),
          throwsA(isException),
        );
      });
    });
    group('login as guest', () {
      test('returns true if logged successfully', () async {
        final mockedResponse = MockResponse();

        when(mockedResponse.statusCode).thenReturn(200);
        when(mockedResponse.body).thenReturn('{"token": "token"}');

        when(httpClient.post(
          Uri.parse("http://127.0.0.1/auth/login/guest"),
          headers: requestHeaders,
          body: OutgoingMessage.createLoginAsGuestMessage("testname"),
        )).thenAnswer((_) => Future.value(mockedResponse));

        final isLogged = await authApiClient.loginAsGuest("testname");

        expect(isLogged, true);
      });

      test('throws Exception when httpClient returns non-200 response',
          () async {
        final mockedResponse = MockResponse();

        when(mockedResponse.statusCode).thenReturn(404);

        when(httpClient.post(
          Uri.parse("http://127.0.0.1/auth/login/guest"),
          headers: requestHeaders,
          body: OutgoingMessage.createLoginAsGuestMessage(
            "testname",
          ),
        )).thenAnswer((_) => Future.value(mockedResponse));

        expect(
          () async => await authApiClient.loginAsGuest("testname"),
          throwsA(isException),
        );
      });
    });

    group('register', () {
      test('returns true if registered successfully', () async {
        final mockedResponse = MockResponse();

        when(mockedResponse.statusCode).thenReturn(201);

        when(httpClient.post(
          Uri.parse("http://127.0.0.1/auth/register"),
          headers: requestHeaders,
          body: OutgoingMessage.createRegisterMessage(
            "testname",
            "password",
            "testQuestion",
            "answer",
          ),
        )).thenAnswer((_) => Future.value(mockedResponse));

        final isRegistered = await authApiClient.register(
          "testname",
          "password",
          "testQuestion",
          "answer",
        );

        expect(isRegistered, true);
      });

      test('throws Exception when httpClient returns non-201 response',
          () async {
        final mockedResponse = MockResponse();

        when(mockedResponse.statusCode).thenReturn(404);

        when(httpClient.post(
          Uri.parse("http://127.0.0.1/auth/register"),
          headers: requestHeaders,
          body: OutgoingMessage.createRegisterMessage(
            "testname",
            "password",
            "testQuestion",
            "answer",
          ),
        )).thenAnswer((_) => Future.value(mockedResponse));

        expect(
          () async => await authApiClient.register(
            "testname",
            "password",
            "testQuestion",
            "answer",
          ),
          throwsA(isException),
        );
      });
    });

    group('recover', () {
      test('returns true if step one successful', () async {
        final mockedResponse = MockResponse();

        when(mockedResponse.statusCode).thenReturn(200);
        when(mockedResponse.body)
            .thenReturn('{"question": "testQuestion", "token": "token"}');

        when(httpClient.post(
          Uri.parse("http://127.0.0.1/auth/recovery"),
          headers: requestHeaders,
          body: OutgoingMessage.createGetRecoveryTokenMessage(
            "testname",
          ),
        )).thenAnswer((_) => Future.value(mockedResponse));

        final result = await authApiClient.recoverStepOne(
          "testname",
        );

        expect(
            true,
            (result.token == "token" &&
                result.securityQuestion == "testQuestion"));
      });

      test(
          'step one - throws Exception when httpClient returns non-200 response',
          () async {
        final mockedResponse = MockResponse();

        when(mockedResponse.statusCode).thenReturn(404);

        when(httpClient.post(
          Uri.parse("http://127.0.0.1/auth/recovery"),
          headers: requestHeaders,
          body: OutgoingMessage.createGetRecoveryTokenMessage(
            "testname",
          ),
        )).thenAnswer((_) => Future.value(mockedResponse));

        expect(
          () async => await authApiClient.recoverStepOne(
            "testname",
          ),
          throwsA(isException),
        );
      });

      test('returns true if step two successful', () async {
        final mockedResponse = MockResponse();

        when(mockedResponse.statusCode).thenReturn(200);
        when(mockedResponse.body).thenReturn('{"token": "token"}');

        when(httpClient.post(
          Uri.parse("http://127.0.0.1/auth/recovery/answer"),
          headers: requestHeadersWithToken,
          body: OutgoingMessage.createSendRecoveryAnswerMessage(
            "answer",
          ),
        )).thenAnswer((_) => Future.value(mockedResponse));

        final result = await authApiClient.recoverStepTwo(
          "token",
          "answer",
        );

        expect(true, result == "token");
      });

      test(
          'step two - throws Exception when httpClient returns non-200 response ',
          () async {
        final mockedResponse = MockResponse();

        when(mockedResponse.statusCode).thenReturn(404);

        when(httpClient.post(
          Uri.parse("http://127.0.0.1/auth/recovery/answer"),
          headers: requestHeadersWithToken,
          body: OutgoingMessage.createSendRecoveryAnswerMessage(
            "answer",
          ),
        )).thenAnswer((_) => Future.value(mockedResponse));

        expect(
          () async => await authApiClient.recoverStepTwo(
            "token",
            "answer",
          ),
          throwsA(isException),
        );
      });

      test(
          'step three - throws Exception when httpClient returns non-200 response ',
          () async {
        final mockedResponse = MockResponse();

        when(mockedResponse.statusCode).thenReturn(401);

        when(httpClient.patch(
          Uri.parse("http://127.0.0.1/auth/recovery/password"),
          headers: requestHeadersWithToken,
          body: OutgoingMessage.createSendRecoveryPasswordMessage(
            "password",
          ),
        )).thenAnswer((_) => Future.value(mockedResponse));

        expect(
          () async => await authApiClient.recoverStepThree(
            "token",
            "password",
          ),
          throwsA(isException),
        );
      });
    });
  });
}
