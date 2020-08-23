class Rooms {
  final List<String> roomList;

  const Rooms(this.roomList);

  factory Rooms.fromJson(Map<String, dynamic> json) {
    List<String> list = [];
    if (json['rooms'] != null) {
      for (var room in json['rooms']) {
        list.add(room);
      }
    }
    return Rooms(list);
  }
}
