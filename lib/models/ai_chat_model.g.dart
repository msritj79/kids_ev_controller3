// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AIChatImpl _$$AIChatImplFromJson(Map<String, dynamic> json) => _$AIChatImpl(
      model: json['model'] as String? ?? "gpt-4o",
      messages: (json['messages'] as List<dynamic>)
          .map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AIChatImplToJson(_$AIChatImpl instance) =>
    <String, dynamic>{
      'model': instance.model,
      'messages': instance.messages,
    };

_$MessageImpl _$$MessageImplFromJson(Map<String, dynamic> json) =>
    _$MessageImpl(
      role: json['role'] as String? ?? "user",
      content: json['content'] as String,
    );

Map<String, dynamic> _$$MessageImplToJson(_$MessageImpl instance) =>
    <String, dynamic>{
      'role': instance.role,
      'content': instance.content,
    };
