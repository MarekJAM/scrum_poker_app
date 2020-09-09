class LobbyStatus {
  final List<String> rooms;
  final String leftRoomReason;

  const LobbyStatus(this.rooms, this.leftRoomReason);

  factory LobbyStatus.fromJson(Map<String, dynamic> json) {
    List<String> roomsJson = [];
    final leftRoomReasonJson = json["lobby_status"]["left_room_reason"] ?? "";

    if (json['lobby_status'] != null) {
      for (var room in json['lobby_status']['rooms']) {
        roomsJson.add(room);
      }
    }
    return LobbyStatus(roomsJson, leftRoomReasonJson);
  }
}
