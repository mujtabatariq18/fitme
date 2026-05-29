import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/admin/domain/ai_provider_config.dart';
import 'http_ai_client.dart';

/// One chat turn.
class AiMessage {
  const AiMessage.user(this.content) : role = 'user';
  const AiMessage.assistant(this.content) : role = 'assistant';
  const AiMessage.system(this.content) : role = 'system';
  final String role;
  final String content;
}

class AiException implements Exception {
  AiException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;
  @override
  String toString() => 'AiException($statusCode): $message';
}

/// Vendor-agnostic AI client. Implementations translate to each vendor's
/// wire format (OpenAI-compatible, Anthropic Messages, Gemini).
abstract class AiClient {
  /// Text (and optional single image) completion. [imageBytes] + [imageMime]
  /// enable vision; the provider's model must support it.
  Future<String> complete({
    required AiProvider provider,
    required String system,
    required String user,
    List<AiMessage> history,
    List<int>? imageBytes,
    String? imageMime,
  });
}

/// App-wide client. Concrete implementation lives in http_ai_client.dart.
final aiClientProvider = Provider<AiClient>((ref) => HttpAiClient());
