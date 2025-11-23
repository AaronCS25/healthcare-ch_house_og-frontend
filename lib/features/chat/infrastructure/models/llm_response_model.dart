class LlmResponseModel {
  final String answer;
  final List<Citation> citations;
  final double latencySec;

  LlmResponseModel({
    required this.answer,
    required this.citations,
    required this.latencySec,
  });

  factory LlmResponseModel.fromJson(Map<String, dynamic> json) =>
      LlmResponseModel(
        answer: json["answer"],
        citations: List<Citation>.from(
          json["citations"].map((x) => Citation.fromJson(x)),
        ),
        latencySec: json["latency_sec"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
    "answer": answer,
    "citations": List<dynamic>.from(citations.map((x) => x.toJson())),
    "latency_sec": latencySec,
  };
}

class Citation {
  final GeneratedResponsePart generatedResponsePart;
  final List<RetrievedReference> retrievedReferences;

  Citation({
    required this.generatedResponsePart,
    required this.retrievedReferences,
  });

  factory Citation.fromJson(Map<String, dynamic> json) => Citation(
    generatedResponsePart: GeneratedResponsePart.fromJson(
      json["generatedResponsePart"],
    ),
    retrievedReferences: List<RetrievedReference>.from(
      json["retrievedReferences"].map((x) => RetrievedReference.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "generatedResponsePart": generatedResponsePart.toJson(),
    "retrievedReferences": List<dynamic>.from(
      retrievedReferences.map((x) => x.toJson()),
    ),
  };
}

class GeneratedResponsePart {
  final TextResponsePart textResponsePart;

  GeneratedResponsePart({required this.textResponsePart});

  factory GeneratedResponsePart.fromJson(Map<String, dynamic> json) =>
      GeneratedResponsePart(
        textResponsePart: TextResponsePart.fromJson(json["textResponsePart"]),
      );

  Map<String, dynamic> toJson() => {
    "textResponsePart": textResponsePart.toJson(),
  };
}

class TextResponsePart {
  final Span span;
  final String text;

  TextResponsePart({required this.span, required this.text});

  factory TextResponsePart.fromJson(Map<String, dynamic> json) =>
      TextResponsePart(span: Span.fromJson(json["span"]), text: json["text"]);

  Map<String, dynamic> toJson() => {"span": span.toJson(), "text": text};
}

class Span {
  final int end;
  final int start;

  Span({required this.end, required this.start});

  factory Span.fromJson(Map<String, dynamic> json) =>
      Span(end: json["end"], start: json["start"]);

  Map<String, dynamic> toJson() => {"end": end, "start": start};
}

class RetrievedReference {
  final Content content;
  final Location location;
  final Metadata metadata;

  RetrievedReference({
    required this.content,
    required this.location,
    required this.metadata,
  });

  factory RetrievedReference.fromJson(Map<String, dynamic> json) =>
      RetrievedReference(
        content: Content.fromJson(json["content"]),
        location: Location.fromJson(json["location"]),
        metadata: Metadata.fromJson(json["metadata"]),
      );

  Map<String, dynamic> toJson() => {
    "content": content.toJson(),
    "location": location.toJson(),
    "metadata": metadata.toJson(),
  };
}

class Content {
  final String text;
  final String type;

  Content({required this.text, required this.type});

  factory Content.fromJson(Map<String, dynamic> json) =>
      Content(text: json["text"], type: json["type"]);

  Map<String, dynamic> toJson() => {"text": text, "type": type};
}

class Location {
  final S3Location s3Location;
  final String type;

  Location({required this.s3Location, required this.type});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    s3Location: S3Location.fromJson(json["s3Location"]),
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "s3Location": s3Location.toJson(),
    "type": type,
  };
}

class S3Location {
  final String uri;

  S3Location({required this.uri});

  factory S3Location.fromJson(Map<String, dynamic> json) =>
      S3Location(uri: json["uri"]);

  Map<String, dynamic> toJson() => {"uri": uri};
}

class Metadata {
  final String xAmzBedrockKbSourceUri;
  final String xAmzBedrockKbSourceFileModality;
  final String xAmzBedrockKbDataSourceId;

  Metadata({
    required this.xAmzBedrockKbSourceUri,
    required this.xAmzBedrockKbSourceFileModality,
    required this.xAmzBedrockKbDataSourceId,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
    xAmzBedrockKbSourceUri: json["x-amz-bedrock-kb-source-uri"],
    xAmzBedrockKbSourceFileModality:
        json["x-amz-bedrock-kb-source-file-modality"],
    xAmzBedrockKbDataSourceId: json["x-amz-bedrock-kb-data-source-id"],
  );

  Map<String, dynamic> toJson() => {
    "x-amz-bedrock-kb-source-uri": xAmzBedrockKbSourceUri,
    "x-amz-bedrock-kb-source-file-modality": xAmzBedrockKbSourceFileModality,
    "x-amz-bedrock-kb-data-source-id": xAmzBedrockKbDataSourceId,
  };
}
