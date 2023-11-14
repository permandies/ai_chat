class AiModel {
  final String category;
  final String firstFavoriteLength;
  final String firstMessage;
  final String id;
  final String name;
  final String prompt;
  final String voiceId;
  AiModel({
    required this.voiceId,
    required this.category,
    required this.firstFavoriteLength,
    required this.firstMessage,
    required this.id,
    required this.name,
    required this.prompt,
  });
  AiModel.formJson(Map json)
      : category = json["category"],
        firstFavoriteLength = json["firstFavoriteLength"],
        firstMessage = json["firstMessage"],
        id = json["id"],
        name = json["name"],
        prompt = json["prompt"],
        voiceId = json["voiceId"];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};

    json["category"] = category;
    json["firstFavoriteLength"] = firstFavoriteLength;
    json["firstMessage"] = firstMessage;
    json["id"] = id;
    json["name"] = name;
    json["prompt"] = prompt;
    json["voiceId"] = voiceId;
    return json;
  }
}
