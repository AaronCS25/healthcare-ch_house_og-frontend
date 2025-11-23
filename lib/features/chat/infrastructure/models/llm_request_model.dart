class LlmRequestModel {
  final String userId;
  final String message;

  LlmRequestModel({required this.userId, required this.message});

  Map<String, dynamic> toJson() => {"user_id": userId, "message": message};
}
