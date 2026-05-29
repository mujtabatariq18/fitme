import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/fit_card.dart';
import '../../admin/application/ai_config_controller.dart';
import '../../admin/domain/ai_provider_config.dart';
import '../../onboarding/application/profile_controller.dart';
import '../data/coach_seed.dart';
import '../domain/coach_tip.dart';

class _Msg {
  const _Msg(this.text, {this.fromUser = false});
  final String text;
  final bool fromUser;
}

class CoachScreen extends ConsumerStatefulWidget {
  const CoachScreen({super.key});

  @override
  ConsumerState<CoachScreen> createState() => _CoachScreenState();
}

class _CoachScreenState extends ConsumerState<CoachScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  final List<_Msg> _messages = [
    const _Msg(
        "Hi! I'm your FitMe coach. Ask me anything, or tap a suggestion below. 💪"),
  ];

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(_Msg(text, fromUser: true));
      _messages.add(_Msg(_answerFor(text)));
    });
    _input.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: Motion.base, curve: Motion.emphasized);
      }
    });
  }

  /// Offline answer: best matching canned prompt, else a goal-aware tip.
  String _answerFor(String q) {
    final ql = q.toLowerCase();
    CoachPrompt? best;
    var bestScore = 0;
    for (final p in CoachSeed.prompts) {
      final words = p.question.toLowerCase().split(RegExp(r'\W+'));
      final score = words.where((w) => w.length > 3 && ql.contains(w)).length;
      if (score > bestScore) {
        bestScore = score;
        best = p;
      }
    }
    if (best != null && bestScore > 0) return best.answer;
    final goal = ref.read(profileProvider).goal;
    final tips = CoachSeed.forGoal(goal);
    return tips.isEmpty
        ? "Great question! Stay consistent, prioritise protein and sleep, and you'll get there."
        : '${tips.first.title}: ${tips.first.body}';
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final aiProvider = ref.watch(aiConfigProvider).providerFor(AiTask.chatCoach);
    final tips = CoachSeed.forGoal(profile.goal).take(5).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('AI Coach')),
      body: Column(
        children: [
          _AiBanner(provider: aiProvider),
          Expanded(
            child: ListView(
              controller: _scroll,
              padding: const EdgeInsets.all(Insets.screenH),
              children: [
                Text('Today for you',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: Insets.sm),
                SizedBox(
                  height: 132,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: tips.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: Insets.sm),
                    itemBuilder: (_, i) => _TipCard(tip: tips[i]),
                  ),
                ),
                const SizedBox(height: Insets.lg),
                ..._messages.map((m) => _Bubble(msg: m)),
              ],
            ),
          ),
          // Suggestions
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: Insets.screenH),
              children: [
                for (final p in CoachSeed.prompts.take(8))
                  Padding(
                    padding: const EdgeInsets.only(right: Insets.sm),
                    child: ActionChip(
                      label: Text(p.question),
                      backgroundColor: AppColors.pinkTint,
                      side: BorderSide.none,
                      labelStyle: const TextStyle(
                          color: AppColors.deepMagenta, fontSize: 12),
                      onPressed: () => _send(p.question),
                    ),
                  ),
              ],
            ),
          ),
          _Composer(controller: _input, onSend: _send),
        ],
      ),
    );
  }
}

class _AiBanner extends StatelessWidget {
  const _AiBanner({required this.provider});
  final AiProvider? provider;

  @override
  Widget build(BuildContext context) {
    final live = provider != null && provider!.isConfigured;
    return Container(
      width: double.infinity,
      color: (live ? AppColors.success : AppColors.warning)
          .withValues(alpha: 0.12),
      padding: const EdgeInsets.symmetric(
          horizontal: Insets.screenH, vertical: Insets.sm),
      child: Row(
        children: [
          Icon(live ? Icons.bolt_rounded : Icons.info_outline_rounded,
              size: 16,
              color: live ? AppColors.success : AppColors.warning),
          const SizedBox(width: Insets.sm),
          Expanded(
            child: Text(
              live
                  ? 'Live AI coach · ${provider!.model}'
                  : 'Using built-in guidance — add an AI provider in Admin → AI Settings for live chat.',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip});
  final CoachTip tip;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: FitCard(
        padding: const EdgeInsets.all(Insets.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(tip.category.emoji),
              const SizedBox(width: 6),
              Text(tip.category.label,
                  style: Theme.of(context).textTheme.labelMedium),
            ]),
            const SizedBox(height: 4),
            Text(tip.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 2),
            Expanded(
              child: Text(tip.body,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.msg});
  final _Msg msg;

  @override
  Widget build(BuildContext context) {
    final fit = context.fit;
    return Align(
      alignment: msg.fromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: Insets.sm),
        padding: const EdgeInsets.symmetric(
            horizontal: Insets.lg, vertical: Insets.md),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: msg.fromUser ? AppColors.pink : fit.surface,
          borderRadius: BorderRadius.circular(Radii.lg),
          border: msg.fromUser ? null : Border.all(color: fit.border),
        ),
        child: Text(
          msg.text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: msg.fromUser ? Colors.white : fit.textPrimary),
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({required this.controller, required this.onSend});
  final TextEditingController controller;
  final ValueChanged<String> onSend;

  @override
  Widget build(BuildContext context) {
    final fit = context.fit;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            Insets.screenH, Insets.sm, Insets.screenH, Insets.sm),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                onSubmitted: onSend,
                decoration: InputDecoration(
                  hintText: 'Ask your coach…',
                  filled: true,
                  fillColor: fit.surfaceAlt,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: Insets.lg, vertical: Insets.md),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Radii.pill),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: Insets.sm),
            GestureDetector(
              onTap: () => onSend(controller.text),
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                    color: AppColors.pink, shape: BoxShape.circle),
                child: const Icon(Icons.send_rounded, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
