class Roomies {
  final List<String> admins;
  final List<String> users;

  const Roomies(this.admins, this.users);

  factory Roomies.fromJson(Map<String, dynamic> json) {
    List<String> adminsList = [];
    List<String> usersList = [];
    if (json["roomies"] != null) {
      for (var admin in json["roomies"]["admins"]) {
        adminsList.add(admin);
      }
      for (var user in json["roomies"]["users"]) {
        usersList.add(user);
      }
    }
    return Roomies(adminsList, usersList);
  }
}
