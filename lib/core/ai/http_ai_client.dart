import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../features/admin/domain/ai_provider_config.dart';
import 'ai_client.dart';

/// Real multi-vendor HTTP implementation of [AiClient].
/// Routes requests to the correct wire format based on [AiVendor].
class HttpAiClient implements AiClient {
  @override
  Future<String> complete({
    required AiProvider provider,
    required String system,
    required String user,
    List<AiMessage> history = const [],
    List<int>? imageBytes,
    String? imageMime,
  }) async {
    final vendor = provider.vendor;

    switch (vendor) {
      case AiVendor.openai:
      case AiVendor.openRouter:
      case AiVendor.groq:
      case AiVendor.custom:
        return _openAiCompat(
          provider: provider,
          system: system,
          user: user,
          history: history,
          imageBytes: imageBytes,
          imageMime: imageMime,
        );
      case AiVendor.anthropic:
        return _anthropic(
          provider: provider,
          system: system,
          user: user,
          history: history,
          imageBytes: imageBytes,
          imageMime: imageMime,
        );
      case AiVendor.google:
        return _google(
          provider: provider,
          system: system,
          user: user,
          imageBytes: imageBytes,
          imageMime: imageMime,
        );
    }
  }

  // ---------------------------------------------------------------------------
  // OpenAI-compatible (openai, openRouter, groq, custom)
  // ---------------------------------------------------------------------------

  Future<String> _openAiCompat({
    required AiProvider provider,
    required String system,
    required String user,
    required List<AiMessage> history,
    List<int>? imageBytes,
    String? imageMime,
  }) async {
    final uri = Uri.parse('${provider.baseUrl}/chat/completions');

    final messages = <Map<String, dynamic>>[
      {'role': 'system', 'content': system},
      for (final m in history) {'role': m.role, 'content': m.content},
      {
        'role': 'user',
        'content': _openAiUserContent(
          user: user,
          imageBytes: imageBytes,
          imageMime: imageMime,
        ),
      },
    ];

    final body = jsonEncode({
      'model': provider.model,
      'messages': messages,
    });

    try {
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer ${provider.apiKey}',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw AiException(response.body, statusCode: response.statusCode);
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return (json['choices'] as List).first['message']['content'] as String;
    } on AiException {
      rethrow;
    } catch (e) {
      throw AiException(e.toString());
    }
  }

  /// Returns either a plain string or a content-parts array for vision.
  dynamic _openAiUserContent({
    required String user,
    List<int>? imageBytes,
    String? imageMime,
  }) {
    if (imageBytes == null || imageMime == null) {
      return user;
    }
    final b64 = base64Encode(imageBytes);
    return [
      {'type': 'text', 'text': user},
      {
        'type': 'image_url',
        'image_url': {'url': 'data:$imageMime;base64,$b64'},
      },
    ];
  }

  // ---------------------------------------------------------------------------
  // Anthropic Messages API
  // ---------------------------------------------------------------------------

  Future<String> _anthropic({
    required AiProvider provider,
    required String system,
    required String user,
    required List<AiMessage> history,
    List<int>? imageBytes,
    String? imageMime,
  }) async {
    final uri = Uri.parse('${provider.baseUrl}/messages');

    final messages = <Map<String, dynamic>>[
      for (final m in history)
        if (m.role == 'user' || m.role == 'assistant')
          {'role': m.role, 'content': m.content},
      {
        'role': 'user',
        'content': _anthropicUserContent(
          user: user,
          imageBytes: imageBytes,
          imageMime: imageMime,
        ),
      },
    ];

    final body = jsonEncode({
      'model': provider.model,
      'max_tokens': 1024,
      'system': system,
      'messages': messages,
    });

    try {
      final response = await http.post(
        uri,
        headers: {
          'x-api-key': provider.apiKey,
          'anthropic-version': '2023-06-01',
          'content-type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw AiException(response.body, statusCode: response.statusCode);
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return (json['content'] as List).first['text'] as String;
    } on AiException {
      rethrow;
    } catch (e) {
      throw AiException(e.toString());
    }
  }

  dynamic _anthropicUserContent({
    required String user,
    List<int>? imageBytes,
    String? imageMime,
  }) {
    if (imageBytes == null || imageMime == null) {
      return user;
    }
    final b64 = base64Encode(imageBytes);
    return [
      {
        'type': 'image',
        'source': {
          'type': 'base64',
          'media_type': imageMime,
          'data': b64,
        },
      },
      {'type': 'text', 'text': user},
    ];
  }

  // ---------------------------------------------------------------------------
  // Google Gemini (generateContent)
  // ---------------------------------------------------------------------------

  Future<String> _google({
    required AiProvider provider,
    required String system,
    required String user,
    List<int>? imageBytes,
    String? imageMime,
  }) async {
    final uri = Uri.parse(
      '${provider.baseUrl}/models/${provider.model}:generateContent?key=${provider.apiKey}',
    );

    final parts = <Map<String, dynamic>>[
      {'text': user},
    ];

    if (imageBytes != null && imageMime != null) {
      final b64 = base64Encode(imageBytes);
      parts.add({
        'inlineData': {
          'mimeType': imageMime,
          'data': b64,
        },
      });
    }

    final body = jsonEncode({
      'contents': [
        {
          'role': 'user',
          'parts': parts,
        },
      ],
      'systemInstruction': {
        'parts': [
          {'text': system},
        ],
      },
    });

    try {
      final response = await http.post(
        uri,
        headers: {'content-type': 'application/json'},
        body: body,
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw AiException(response.body, statusCode: response.statusCode);
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return (json['candidates'] as List).first['content']['parts'].first['text']
          as String;
    } on AiException {
      rethrow;
    } catch (e) {
      throw AiException(e.toString());
    }
  }
}
