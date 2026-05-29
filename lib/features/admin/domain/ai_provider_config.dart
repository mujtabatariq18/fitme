import 'dart:convert';

/// Supported AI vendors. "custom" allows any OpenAI-compatible endpoint.
enum AiVendor { anthropic, openai, google, groq, openRouter, custom }

extension AiVendorMeta on AiVendor {
  String get label => switch (this) {
        AiVendor.anthropic => 'Anthropic (Claude)',
        AiVendor.openai => 'OpenAI',
        AiVendor.google => 'Google (Gemini)',
        AiVendor.groq => 'Groq',
        AiVendor.openRouter => 'OpenRouter',
        AiVendor.custom => 'Custom (OpenAI-compatible)',
      };

  /// Whether this vendor's models can accept image inputs (food/body photos).
  bool get supportsVision => switch (this) {
        AiVendor.groq => false,
        _ => true,
      };

  String get defaultBaseUrl => switch (this) {
        AiVendor.anthropic => 'https://api.anthropic.com/v1',
        AiVendor.openai => 'https://api.openai.com/v1',
        AiVendor.google => 'https://generativelanguage.googleapis.com/v1beta',
        AiVendor.groq => 'https://api.groq.com/openai/v1',
        AiVendor.openRouter => 'https://openrouter.ai/api/v1',
        AiVendor.custom => '',
      };

  String get defaultModel => switch (this) {
        AiVendor.anthropic => 'claude-opus-4-8',
        AiVendor.openai => 'gpt-4o',
        AiVendor.google => 'gemini-2.5-pro',
        AiVendor.groq => 'llama-3.3-70b-versatile',
        AiVendor.openRouter => 'anthropic/claude-opus-4-8',
        AiVendor.custom => '',
      };
}

/// AI tasks that can each be routed to a different provider. This is what the
/// admin "AI Settings" panel binds providers to.
enum AiTask {
  foodVision, // calorie/macro estimate from a meal photo
  bodyAnalysis, // analyze body-area photo, assess problem areas
  workoutSuggestion, // generate/adapt a workout plan
  mealPlanning, // generate personalized meal plans
  chatCoach, // conversational coaching
  nutritionLookup, // structured nutrition data (may be a non-LLM API)
}

extension AiTaskMeta on AiTask {
  String get label => switch (this) {
        AiTask.foodVision => 'Food photo analysis',
        AiTask.bodyAnalysis => 'Body area analysis',
        AiTask.workoutSuggestion => 'Workout suggestions',
        AiTask.mealPlanning => 'Meal planning',
        AiTask.chatCoach => 'AI coach chat',
        AiTask.nutritionLookup => 'Nutrition lookup',
      };

  String get description => switch (this) {
        AiTask.foodVision =>
          'Estimates calories & macros from a meal photo. Needs a vision model.',
        AiTask.bodyAnalysis =>
          'Reviews progress photos & target areas. Needs a vision model.',
        AiTask.workoutSuggestion =>
          'Builds and adapts workouts from goals & progress.',
        AiTask.mealPlanning => 'Generates day-by-day meal plans.',
        AiTask.chatCoach => 'Powers the in-app conversational coach.',
        AiTask.nutritionLookup =>
          'Resolves precise nutrition facts. Can use a dedicated nutrition API.',
      };

  bool get requiresVision =>
      this == AiTask.foodVision || this == AiTask.bodyAnalysis;
}

/// One configured provider (a vendor + credentials + model). Multiple may
/// exist; admin assigns each [AiTask] to one of these by [id].
class AiProvider {
  AiProvider({
    required this.id,
    required this.name,
    required this.vendor,
    this.apiKey = '',
    String? baseUrl,
    String? model,
    this.enabled = true,
  })  : baseUrl = baseUrl ?? vendor.defaultBaseUrl,
        model = model ?? vendor.defaultModel;

  final String id;
  final String name;
  final AiVendor vendor;
  final String apiKey;
  final String baseUrl;
  final String model;
  final bool enabled;

  bool get isConfigured => apiKey.isNotEmpty && model.isNotEmpty;

  AiProvider copyWith({
    String? name,
    AiVendor? vendor,
    String? apiKey,
    String? baseUrl,
    String? model,
    bool? enabled,
  }) =>
      AiProvider(
        id: id,
        name: name ?? this.name,
        vendor: vendor ?? this.vendor,
        apiKey: apiKey ?? this.apiKey,
        baseUrl: baseUrl ?? this.baseUrl,
        model: model ?? this.model,
        enabled: enabled ?? this.enabled,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'vendor': vendor.name,
        // NOTE: keys are NEVER persisted client-side in production — they live
        // in Supabase edge-function secrets. Stored here only for local admin
        // preview; see AiSettingsController docs.
        'apiKey': apiKey,
        'baseUrl': baseUrl,
        'model': model,
        'enabled': enabled,
      };

  factory AiProvider.fromMap(Map<String, dynamic> m) => AiProvider(
        id: m['id'],
        name: m['name'],
        vendor: AiVendor.values.byName(m['vendor']),
        apiKey: m['apiKey'] ?? '',
        baseUrl: m['baseUrl'],
        model: m['model'],
        enabled: m['enabled'] ?? true,
      );
}

/// The complete AI configuration: the set of providers + which provider
/// handles each task. Serializable so admin can export/import.
class AiConfig {
  const AiConfig({this.providers = const [], this.taskBindings = const {}});

  final List<AiProvider> providers;
  final Map<AiTask, String> taskBindings; // task -> provider id

  AiProvider? providerFor(AiTask task) {
    final id = taskBindings[task];
    if (id == null) return null;
    for (final p in providers) {
      if (p.id == id) return p;
    }
    return null;
  }

  AiConfig copyWith({
    List<AiProvider>? providers,
    Map<AiTask, String>? taskBindings,
  }) =>
      AiConfig(
        providers: providers ?? this.providers,
        taskBindings: taskBindings ?? this.taskBindings,
      );

  Map<String, dynamic> toMap() => {
        'providers': providers.map((p) => p.toMap()).toList(),
        'taskBindings':
            taskBindings.map((k, v) => MapEntry(k.name, v)),
      };

  factory AiConfig.fromMap(Map<String, dynamic> m) => AiConfig(
        providers: ((m['providers'] as List?) ?? [])
            .map((e) => AiProvider.fromMap(e as Map<String, dynamic>))
            .toList(),
        taskBindings: ((m['taskBindings'] as Map?) ?? {}).map(
          (k, v) => MapEntry(AiTask.values.byName(k as String), v as String),
        ),
      );

  String toJson() => jsonEncode(toMap());
  factory AiConfig.fromJson(String s) =>
      AiConfig.fromMap(jsonDecode(s) as Map<String, dynamic>);
}
