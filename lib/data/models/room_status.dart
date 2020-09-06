class RoomStatus {
  final List<String> admins;
  final List<String> users;
  final String estimateRequest;

  const RoomStatus(this.admins, this.users, this.estimateRequest);

  factory RoomStatus.fromJson(Map<String, dynamic> json) {
    print(json);
    List<String> adminsListJson = [];
    List<String> usersListJson = [];
    final estimateRequestJson = json["room_status"]["estimate_request"] ?? "";

    if (json["room_status"] != null) {
      for (var admin in json["room_status"]["admins"]) {
        adminsListJson.add(admin);
      }
      for (var user in json["room_status"]["users"]) {
        usersListJson.add(user);
      }
    }
    return RoomStatus(adminsListJson, usersListJson, estimateRequestJson);
  }
}
