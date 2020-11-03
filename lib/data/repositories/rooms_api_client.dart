import '../../utils/secure_storage.dart';
import '../../data/models/models.dart';
import 'repositories.dart';
import 'package:http/http.dart' as http;

class RoomsApiClient extends ApiClient {
  final _createRoomEndpoint = '/rooms/create';
  final _connectToRoomEndpoint = '/rooms/connect';
  final _disconnectFromRoomEndpoint = '/rooms/disconnect';
  final _destroyRoomEndpoint = '/rooms/destroy';

  final http.Client httpClient;

  RoomsApiClient({this.httpClient, SecureStorage secureStorage}) : assert(httpClient != null), super(secureStorage: secureStorage);

  Future<bool> createRoom(String roomName) async {    
    http.Response response = await httpClient.put(
      getServerUrl() + '$_createRoomEndpoint',
      headers: {"Content-Type": "application/json"},
      body: OutgoingMessage.createCreateRoomJsonMsg(getUsername(), roomName)
    );

    if (response.statusCode != 201) {
      throwException(response.statusCode, decodeErrorMessage(response) ?? "Error while creating room");
    }
  
    return true;
  }

  Future<bool> connectToRoom(String roomName) async {
    http.Response response = await httpClient.patch(
      getServerUrl() + '$_connectToRoomEndpoint',
      headers: {"Content-Type": "application/json"},
      body: OutgoingMessage.createConnectRoomJsonMsg(getUsername(), roomName)
    );

    if (response.statusCode != 200) {
      throwException(response.statusCode, decodeErrorMessage(response) ?? 'Error while connecting to room');
    }
  
    return true;
  }

  Future<bool> disconnectFromRoom() async {
    http.Response response = await httpClient.patch(
      getServerUrl() + '$_disconnectFromRoomEndpoint',
      headers: {"Content-Type": "application/json"},
      body: OutgoingMessage.createDisconnectFromRoomJsonMsg(getUsername())
    );

    if (response.statusCode != 200) {
      throwException(response.statusCode, decodeErrorMessage(response) ?? 'Error while disconnecting from room');
    }
  
    return true;
  }

  Future<bool> destroyRoom() async {
    final response = await httpClient.send(
      http.Request(
          "DELETE", Uri.parse(getServerUrl() + '$_destroyRoomEndpoint'))
        ..headers["Content-Type"] = "application/json"
        ..body = OutgoingMessage.createDisconnectFromRoomJsonMsg(getUsername()),
    );

    if (response.statusCode != 200) {
      throwException(response.statusCode, decodeErrorMessage(response) ?? 'Error while destroying room');
    }
  
    return true;
  }
}
