import 'dart:convert';

class OutgoingMessage {
  static String createWebSocketTokenMessage(String token) {
    return json.encode({"token": token});
  }

  static String createLoginMessage(String username, String password) {
    return json.encode({"username": username, "password": password});
  }

  static String createRegisterMessage(String username, String password,
      String securityQuestion, String answer) {
    return json.encode({
      "username": username,
      "password": password,
      "security_question": securityQuestion,
      "security_answer": answer,
    });
  }

  static String createLoginAsGuestMessage(String username) {
    return json.encode({"username": username});
  }

  static String createCreateRoomJsonMsg(String roomName) {
    return json.encode({"roomname": roomName});
  }

  static String createConnectRoomJsonMsg(String roomName, bool asSpectator) {
    return json.encode({
      "roomname": roomName,
      "role": asSpectator ? "spectator" : "estimator"
    });
  }

  static String createRequestEstimateJsonMsg(String taskNumber) {
    return json.encode({"request_estimate": taskNumber});
  }

  static String createEstimateJsonMsg(int estimate) {
    return json.encode({"estimate": estimate});
  }

  static String createGetRecoveryTokenMessage(String username) {
    return json.encode({"username": username});
  }

  static String createSendRecoveryAnswerMessage(String answer) {
    return json.encode({"security_answer": answer});
  }

  static String createSendRecoveryPasswordMessage(String password) {
    return json.encode({"password": password});
  }
}
