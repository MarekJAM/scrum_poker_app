class RecoveryMessage {
  final String token;
  final String securityQuestion;

  const RecoveryMessage(this.token, this.securityQuestion);

  factory RecoveryMessage.fromJson(Map<String, dynamic> json) {
    final token = json["token"] ?? "";
    final securityQuestion = json["question"] ?? "";

    return RecoveryMessage(token, securityQuestion);
  }
}
