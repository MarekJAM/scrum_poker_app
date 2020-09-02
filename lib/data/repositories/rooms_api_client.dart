import '../../data/models/models.dart';
import '../../utils/secure_storage.dart';
import 'repositories.dart';
import 'package:http/http.dart' as http;

class RoomsApiClient extends ApiClient {
  final _createRoomEndpoint = '/rooms/create';
  final _connectToRoomEndpoint = '/rooms/connect';
  final _disconnectFromRoomEndpoint = '/rooms/disconnect';

  final http.Client httpClient;

  RoomsApiClient({this.httpClient}) : assert(httpClient != null);

  Future<bool> createRoom(String roomName) async {
    http.Response response = await httpClient.put(
      'http://' + await SecureStorage().readServerAddress()+'$_createRoomEndpoint',
      headers: {"Content-Type": "application/json"},
      body: OutgoingMessage.createCreateRoomJsonMsg(await SecureStorage().readUsername(), roomName)
    );

    if (response.statusCode != 201) {
      throwException(response.statusCode, decodeErrorMessage(response) ?? "Error while creating room");
    }
  
    return true;
  }

  Future<bool> connectToRoom(String roomName) async {
    http.Response response = await httpClient.patch(
      'http://' + await SecureStorage().readServerAddress()+'$_connectToRoomEndpoint',
      headers: {"Content-Type": "application/json"},
      body: OutgoingMessage.createConnectRoomJsonMsg(await SecureStorage().readUsername(), roomName)
    );

    if (response.statusCode != 200) {
      throwException(response.statusCode, decodeErrorMessage(response) ?? 'Error while connecting to room');
    }
  
    return true;
  }

  Future<bool> disconnectFromRoom() async {
    http.Response response = await httpClient.patch(
      'http://' + await SecureStorage().readServerAddress()+'$_disconnectFromRoomEndpoint',
      headers: {"Content-Type": "application/json"},
      body: OutgoingMessage.createDisconnectFromRoomJsonMsg(await SecureStorage().readUsername())
    );

    if (response.statusCode != 200) {
      throwException(response.statusCode, decodeErrorMessage(response) ?? 'Error while disconnecting from room');
    }
  
    return true;
  }
}
