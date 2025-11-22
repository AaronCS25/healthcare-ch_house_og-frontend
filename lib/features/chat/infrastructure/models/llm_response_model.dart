class LlmResponseModel {
  final String detail;

  LlmResponseModel({required this.detail});

  factory LlmResponseModel.fromJson(Map<String, dynamic> json) =>
      LlmResponseModel(detail: json["detail"]);
}
