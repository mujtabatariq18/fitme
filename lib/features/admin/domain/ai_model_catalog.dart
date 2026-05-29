import 'ai_provider_config.dart';

/// A selectable model in the admin AI panel.
class AiModelInfo {
  const AiModelInfo({
    required this.id,
    required this.name,
    required this.vision,
    required this.contextK,
    this.note = '',
  });

  final String id; // provider-qualified id (e.g. anthropic/claude-opus-4-8)
  final String name; // human label
  final bool vision; // accepts image inputs
  final int contextK; // context window in thousands of tokens
  final String note;
}

/// Curated model catalogs per vendor. The admin model picker reads from these.
/// Vision-capable models are flagged so vision-only tasks can filter them.
class AiModelCatalog {
  AiModelCatalog._();

  static List<AiModelInfo> forVendor(AiVendor vendor) => switch (vendor) {
        AiVendor.openRouter => openRouter,
        AiVendor.anthropic => anthropic,
        AiVendor.openai => openai,
        AiVendor.google => google,
        AiVendor.groq => groq,
        AiVendor.custom => const [],
      };

  static List<AiModelInfo> visionModels(AiVendor vendor) =>
      forVendor(vendor).where((m) => m.vision).toList();

  // ── OpenRouter (the user asked for this list specifically) ─────────────────
  static const openRouter = <AiModelInfo>[
    // Vision-capable
    AiModelInfo(id: 'anthropic/claude-opus-4-8', name: 'Claude Opus 4.8', vision: true, contextK: 200, note: 'Top reasoning + vision'),
    AiModelInfo(id: 'anthropic/claude-sonnet-4-6', name: 'Claude Sonnet 4.6', vision: true, contextK: 200, note: 'Fast, strong vision'),
    AiModelInfo(id: 'anthropic/claude-3.7-sonnet', name: 'Claude 3.7 Sonnet', vision: true, contextK: 200),
    AiModelInfo(id: 'openai/gpt-4o', name: 'GPT-4o', vision: true, contextK: 128, note: 'Great all-round vision'),
    AiModelInfo(id: 'openai/gpt-4o-mini', name: 'GPT-4o mini', vision: true, contextK: 128, note: 'Cheap vision'),
    AiModelInfo(id: 'openai/gpt-4.1', name: 'GPT-4.1', vision: true, contextK: 1000),
    AiModelInfo(id: 'google/gemini-2.5-pro', name: 'Gemini 2.5 Pro', vision: true, contextK: 1000, note: 'Huge context + vision'),
    AiModelInfo(id: 'google/gemini-2.5-flash', name: 'Gemini 2.5 Flash', vision: true, contextK: 1000, note: 'Fast + cheap vision'),
    AiModelInfo(id: 'google/gemini-2.0-flash-001', name: 'Gemini 2.0 Flash', vision: true, contextK: 1000),
    AiModelInfo(id: 'meta-llama/llama-4-maverick', name: 'Llama 4 Maverick', vision: true, contextK: 256),
    AiModelInfo(id: 'meta-llama/llama-4-scout', name: 'Llama 4 Scout', vision: true, contextK: 512),
    AiModelInfo(id: 'qwen/qwen2.5-vl-72b-instruct', name: 'Qwen2.5-VL 72B', vision: true, contextK: 128),
    AiModelInfo(id: 'mistralai/pixtral-large-2411', name: 'Pixtral Large', vision: true, contextK: 128),
    AiModelInfo(id: 'x-ai/grok-2-vision-1212', name: 'Grok 2 Vision', vision: true, contextK: 32),
    // Text-only
    AiModelInfo(id: 'anthropic/claude-3.5-haiku', name: 'Claude 3.5 Haiku', vision: false, contextK: 200, note: 'Fast text'),
    AiModelInfo(id: 'openai/gpt-4.1-mini', name: 'GPT-4.1 mini', vision: false, contextK: 1000),
    AiModelInfo(id: 'openai/o4-mini', name: 'o4-mini (reasoning)', vision: false, contextK: 200),
    AiModelInfo(id: 'google/gemini-2.5-flash-lite', name: 'Gemini 2.5 Flash-Lite', vision: false, contextK: 1000),
    AiModelInfo(id: 'deepseek/deepseek-chat-v3', name: 'DeepSeek V3', vision: false, contextK: 64, note: 'Cheap, capable'),
    AiModelInfo(id: 'deepseek/deepseek-r1', name: 'DeepSeek R1 (reasoning)', vision: false, contextK: 64),
    AiModelInfo(id: 'meta-llama/llama-3.3-70b-instruct', name: 'Llama 3.3 70B', vision: false, contextK: 128),
    AiModelInfo(id: 'qwen/qwen-2.5-72b-instruct', name: 'Qwen 2.5 72B', vision: false, contextK: 128),
    AiModelInfo(id: 'mistralai/mistral-large-2411', name: 'Mistral Large', vision: false, contextK: 128),
    AiModelInfo(id: 'x-ai/grok-3-beta', name: 'Grok 3 (beta)', vision: false, contextK: 131),
  ];

  static const anthropic = <AiModelInfo>[
    AiModelInfo(id: 'claude-opus-4-8', name: 'Claude Opus 4.8', vision: true, contextK: 200),
    AiModelInfo(id: 'claude-sonnet-4-6', name: 'Claude Sonnet 4.6', vision: true, contextK: 200),
    AiModelInfo(id: 'claude-3-5-haiku-latest', name: 'Claude 3.5 Haiku', vision: false, contextK: 200),
  ];

  static const openai = <AiModelInfo>[
    AiModelInfo(id: 'gpt-4o', name: 'GPT-4o', vision: true, contextK: 128),
    AiModelInfo(id: 'gpt-4o-mini', name: 'GPT-4o mini', vision: true, contextK: 128),
    AiModelInfo(id: 'gpt-4.1', name: 'GPT-4.1', vision: true, contextK: 1000),
    AiModelInfo(id: 'o4-mini', name: 'o4-mini', vision: false, contextK: 200),
  ];

  static const google = <AiModelInfo>[
    AiModelInfo(id: 'gemini-2.5-pro', name: 'Gemini 2.5 Pro', vision: true, contextK: 1000),
    AiModelInfo(id: 'gemini-2.5-flash', name: 'Gemini 2.5 Flash', vision: true, contextK: 1000),
    AiModelInfo(id: 'gemini-2.5-flash-lite', name: 'Gemini 2.5 Flash-Lite', vision: false, contextK: 1000),
  ];

  static const groq = <AiModelInfo>[
    AiModelInfo(id: 'llama-3.3-70b-versatile', name: 'Llama 3.3 70B', vision: false, contextK: 128),
    AiModelInfo(id: 'qwen-2.5-32b', name: 'Qwen 2.5 32B', vision: false, contextK: 128),
  ];
}
