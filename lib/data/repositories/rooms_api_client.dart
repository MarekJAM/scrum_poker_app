import 'repositories.dart';
import 'package:http/http.dart' as http;

import '../../data/models/models.dart';
import '../../utils/session_data_singleton.dart';

class RoomsApiClient extends ApiClient {
  final _createRoomEndpoint = '/rooms/create';
  final _connectToRoomEndpoint = '/rooms/connect';
  final _disconnectFromRoomEndpoint = '/rooms/disconnect';
  final _destroyRoomEndpoint = '/rooms/destroy';

  final http.Client httpClient;

  RoomsApiClient({this.httpClient, SessionDataSingleton sessionDataSingleton})
      : assert(httpClient != null),
        super(sessionDataSingleton: sessionDataSingleton);

  Future<bool> createRoom(String roomName) async {
    http.Response response = await httpClient.put(
      Uri.parse(getBaseURL() + '$_createRoomEndpoint'),
      headers: getRequestHeaders(),
      body: OutgoingMessage.createCreateRoomJsonMsg(roomName),
    );

    if (response.statusCode != 201) {
      throwException(response.statusCode, decodeErrorMessage(response) ?? "Error while creating room");
    }

    return true;
  }

  Future<bool> connectToRoom(String roomName, bool asSpectator) async {
    http.Response response = await httpClient.patch(
      Uri.parse(getBaseURL() + '$_connectToRoomEndpoint'),
      headers: getRequestHeaders(),
      body: OutgoingMessage.createConnectRoomJsonMsg(roomName, asSpectator),
    );

    if (response.statusCode != 200) {
      throwException(response.statusCode, decodeErrorMessage(response) ?? 'Error while connecting to room');
    }

    return true;
  }

  Future<bool> disconnectFromRoom() async {
    http.Response response = await httpClient.patch(
      Uri.parse(getBaseURL() + '$_disconnectFromRoomEndpoint'),
      headers: getRequestHeaders(),
    );

    if (response.statusCode != 200) {
      throwException(response.statusCode, decodeErrorMessage(response) ?? 'Error while disconnecting from room');
    }

    return true;
  }

  Future<bool> destroyRoom() async {
    http.Response response = await httpClient.delete(
      Uri.parse(getBaseURL() + '$_destroyRoomEndpoint'),
      headers: getRequestHeaders(),
    );

    if (response.statusCode != 200) {
      throwException(response.statusCode, decodeErrorMessage(response) ?? 'Error while destroying room');
    }

    return true;
  }
}
