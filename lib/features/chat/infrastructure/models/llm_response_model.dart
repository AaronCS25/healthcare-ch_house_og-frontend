class LlmResponseModel {
  final String endpoint;
  final double confidence;
  final String reasoning;
  final String message;

  LlmResponseModel({
    required this.endpoint,
    required this.confidence,
    required this.reasoning,
    required this.message,
  });

  factory LlmResponseModel.fromJson(Map<String, dynamic> json) =>
      LlmResponseModel(
        endpoint: json["endpoint"],
        confidence: json["confidence"]?.toDouble(),
        reasoning: json["reasoning"],
        message: json["message"],
      );
}
