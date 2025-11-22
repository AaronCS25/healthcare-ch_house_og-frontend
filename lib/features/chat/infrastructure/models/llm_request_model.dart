class LlmRequestModel {
  final String message;

  LlmRequestModel({required this.message});

  Map<String, dynamic> toJson() => {"message": message};
}
