import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_chat_model.freezed.dart';
part 'ai_chat_model.g.dart';

@freezed
class AIChat with _$AIChat {
  const factory AIChat({
    @Default("gpt-4o") String model,
    required List<Message> messages,
  }) = _AIChat;

  factory AIChat.fromJson(Map<String, dynamic> json) => _$AIChatFromJson(json);
}

@freezed
class Message with _$Message {
  const factory Message({
    @Default("user") String role,
    required String content,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}
