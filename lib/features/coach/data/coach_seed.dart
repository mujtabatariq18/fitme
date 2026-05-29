import '../domain/coach_tip.dart';
import '../../onboarding/domain/user_profile.dart';

/// Seed data for coaching tips and FAQ prompts.
class CoachSeed {
  CoachSeed._();

  // ── Tips ──────────────────────────────────────────────────────────────────

  static const List<CoachTip> tips = [
    // ── Nutrition tips ──────────────────────────────────────────────────────
    CoachTip(
      id: 'tip_protein_every_meal',
      title: 'Anchor every meal with protein',
      body:
          'Include at least 20–30 g of protein at each meal to maximise muscle '
          'protein synthesis and keep hunger in check throughout the day.',
      category: TipCategory.nutrition,
    ),
    CoachTip(
      id: 'tip_calorie_deficit',
      title: 'Eat in a moderate deficit',
      body:
          'A deficit of 300–500 kcal per day produces steady fat loss of '
          '0.3–0.5 kg per week while preserving muscle mass.',
      category: TipCategory.nutrition,
      forGoal: FitnessGoal.loseWeight,
    ),
    CoachTip(
      id: 'tip_bulk_surplus',
      title: 'Eat in a lean surplus',
      body:
          'Aim for +200–300 kcal above maintenance to gain muscle without '
          'excessive fat. Track weekly weight to stay on target.',
      category: TipCategory.nutrition,
      forGoal: FitnessGoal.buildMuscle,
    ),
    CoachTip(
      id: 'tip_eat_vegetables',
      title: 'Fill half your plate with vegetables',
      body:
          'Non-starchy vegetables add volume and fibre for very few calories, '
          'keeping you full and supporting gut health.',
      category: TipCategory.nutrition,
    ),
    CoachTip(
      id: 'tip_dont_skip_breakfast',
      title: 'Front-load calories earlier in the day',
      body:
          'Research shows eating more earlier and less at night improves '
          'insulin sensitivity and reduces total daily calorie intake.',
      category: TipCategory.nutrition,
      forGoal: FitnessGoal.loseWeight,
    ),
    CoachTip(
      id: 'tip_toned_carb_timing',
      title: 'Time carbs around your workouts',
      body:
          'Eat complex carbs 1–2 hours before training for energy, and fast '
          'carbs + protein within 45 minutes post-workout to aid recovery.',
      category: TipCategory.nutrition,
      forGoal: FitnessGoal.getToned,
    ),
    CoachTip(
      id: 'tip_meal_prep',
      title: 'Prep meals on Sunday',
      body:
          'Batch-cooking grains, proteins and vegetables for the week removes '
          'decision fatigue and makes hitting your macros far easier.',
      category: TipCategory.nutrition,
    ),
    CoachTip(
      id: 'tip_read_labels',
      title: 'Check serving sizes on labels',
      body:
          'Nutrition labels often list a portion that is half the package. '
          'Always multiply by the number of servings you actually eat.',
      category: TipCategory.nutrition,
    ),
    CoachTip(
      id: 'tip_health_omega3',
      title: 'Add oily fish twice a week',
      body:
          'Salmon, mackerel and sardines supply omega-3 fatty acids that '
          'reduce inflammation and support heart and brain health.',
      category: TipCategory.nutrition,
      forGoal: FitnessGoal.improveHealth,
    ),

    // ── Training tips ────────────────────────────────────────────────────────
    CoachTip(
      id: 'tip_progressive_overload',
      title: 'Add a little more each week',
      body:
          'Progressive overload — increasing reps, sets or load by 2–5 % '
          'weekly — is the single most reliable driver of muscle and strength gains.',
      category: TipCategory.training,
      forGoal: FitnessGoal.buildMuscle,
    ),
    CoachTip(
      id: 'tip_compound_lifts',
      title: 'Prioritise compound movements',
      body:
          'Squats, deadlifts, bench press and rows recruit multiple muscle '
          'groups at once, giving you more strength and hypertrophy per set.',
      category: TipCategory.training,
    ),
    CoachTip(
      id: 'tip_cardio_fat_loss',
      title: 'Add 150 min of cardio per week',
      body:
          'Three to five sessions of moderate-intensity cardio per week '
          'accelerates the calorie deficit and improves cardiovascular health.',
      category: TipCategory.training,
      forGoal: FitnessGoal.loseWeight,
    ),
    CoachTip(
      id: 'tip_toned_resistance',
      title: 'Lift weights to look toned',
      body:
          '"Toning" is simply building muscle while reducing body fat — '
          'resistance training 3–4 times a week is the most effective path.',
      category: TipCategory.training,
      forGoal: FitnessGoal.getToned,
    ),
    CoachTip(
      id: 'tip_train_consistency',
      title: 'Consistency beats intensity',
      body:
          'Showing up three times a week every week for a year outperforms '
          'heroic six-day stints followed by long breaks.',
      category: TipCategory.training,
    ),
    CoachTip(
      id: 'tip_warm_up',
      title: 'Never skip your warm-up',
      body:
          'Five minutes of dynamic movement (leg swings, arm circles, light '
          'cardio) raises core temperature and reduces injury risk by up to 50 %.',
      category: TipCategory.training,
    ),
    CoachTip(
      id: 'tip_maintain_activity',
      title: 'Move more, even on rest days',
      body:
          'Walking 8,000–10,000 steps per day boosts NEAT (non-exercise '
          'activity thermogenesis) and burns an extra 200–400 kcal without gym time.',
      category: TipCategory.training,
      forGoal: FitnessGoal.maintain,
    ),
    CoachTip(
      id: 'tip_health_hiit',
      title: 'Include one HIIT session per week',
      body:
          'High-intensity interval training improves VO2 max, blood pressure '
          'and insulin sensitivity more efficiently than steady-state cardio alone.',
      category: TipCategory.training,
      forGoal: FitnessGoal.improveHealth,
    ),
    CoachTip(
      id: 'tip_rep_ranges',
      title: 'Mix rep ranges for full development',
      body:
          'Heavy sets of 3–5 reps build maximal strength; moderate sets of '
          '6–12 reps maximise hypertrophy; higher reps build endurance — include all three.',
      category: TipCategory.training,
      forGoal: FitnessGoal.buildMuscle,
    ),
    CoachTip(
      id: 'tip_maintain_strength',
      title: 'Lift twice a week to maintain muscle',
      body:
          'Research confirms that two resistance sessions per week is the '
          'minimum dose to preserve muscle mass and strength long-term.',
      category: TipCategory.training,
      forGoal: FitnessGoal.maintain,
    ),

    // ── Recovery tips ────────────────────────────────────────────────────────
    CoachTip(
      id: 'tip_sleep_quality',
      title: '7–9 hours of sleep is non-negotiable',
      body:
          'Sleep is when growth hormone peaks and muscle repair happens. '
          'Chronic under-sleep raises cortisol and drives fat storage.',
      category: TipCategory.recovery,
    ),
    CoachTip(
      id: 'tip_deload_week',
      title: 'Take a deload every 4–6 weeks',
      body:
          'Reducing training volume by 40–50 % for one week lets connective '
          'tissue recover and often results in a performance jump the following week.',
      category: TipCategory.recovery,
      forGoal: FitnessGoal.buildMuscle,
    ),
    CoachTip(
      id: 'tip_active_recovery',
      title: 'Walk or stretch on rest days',
      body:
          'Light movement on rest days increases blood flow to sore muscles, '
          'clearing lactate and reducing DOMS faster than complete inactivity.',
      category: TipCategory.recovery,
    ),
    CoachTip(
      id: 'tip_post_workout_nutrition',
      title: 'Eat within 2 hours post-workout',
      body:
          'Consuming 20–40 g protein and carbohydrates within 2 hours of '
          'training accelerates muscle glycogen resynthesis and repair.',
      category: TipCategory.recovery,
    ),
    CoachTip(
      id: 'tip_manage_stress',
      title: 'Manage stress to protect your results',
      body:
          'Chronically elevated cortisol breaks down muscle tissue and '
          'promotes abdominal fat storage — managing stress is part of your training plan.',
      category: TipCategory.recovery,
      forGoal: FitnessGoal.improveHealth,
    ),
    CoachTip(
      id: 'tip_foam_rolling',
      title: 'Foam roll before and after workouts',
      body:
          'Self-myofascial release improves range of motion and reduces '
          'post-exercise soreness, helping you train harder in subsequent sessions.',
      category: TipCategory.recovery,
    ),

    // ── Mindset tips ─────────────────────────────────────────────────────────
    CoachTip(
      id: 'tip_track_progress',
      title: 'Track to stay accountable',
      body:
          'Studies show people who log food and workouts lose twice as much '
          'weight and build more muscle than those who rely on memory alone.',
      category: TipCategory.mindset,
      forGoal: FitnessGoal.loseWeight,
    ),
    CoachTip(
      id: 'tip_set_process_goals',
      title: 'Set process goals, not just outcome goals',
      body:
          'Instead of "lose 10 kg," aim for "work out three times this week." '
          'Process goals are fully within your control and build lasting habits.',
      category: TipCategory.mindset,
    ),
    CoachTip(
      id: 'tip_identity_shift',
      title: 'Act like the person you want to become',
      body:
          'Every healthy choice is a vote for your new identity. Saying '
          '"I am someone who moves daily" is more motivating than "I am trying to."',
      category: TipCategory.mindset,
    ),
    CoachTip(
      id: 'tip_self_compassion',
      title: 'One bad day cannot derail you',
      body:
          'Missing a workout or overeating once has negligible long-term '
          'impact. Consistency over weeks and months is what drives results.',
      category: TipCategory.mindset,
    ),
    CoachTip(
      id: 'tip_visualise_success',
      title: 'Visualise your workout before you start',
      body:
          'Spending two minutes mentally rehearsing your session improves '
          'focus, technique and the likelihood you will complete it.',
      category: TipCategory.mindset,
      forGoal: FitnessGoal.getToned,
    ),
    CoachTip(
      id: 'tip_celebrate_small_wins',
      title: 'Celebrate every small win',
      body:
          'Logging a win — a new PR, a week of clean eating — releases '
          'dopamine and reinforces the behaviours that lead to long-term success.',
      category: TipCategory.mindset,
      forGoal: FitnessGoal.maintain,
    ),

    // ── Hydration tips ───────────────────────────────────────────────────────
    CoachTip(
      id: 'tip_daily_water_target',
      title: 'Aim for 35 ml of water per kg of bodyweight',
      body:
          'A 75 kg person needs roughly 2.6 L daily at rest. Add 500 ml '
          'for every hour of exercise, more in hot weather.',
      category: TipCategory.hydration,
    ),
    CoachTip(
      id: 'tip_drink_before_meals',
      title: 'Drink water before every meal',
      body:
          'Drinking 500 ml of water 30 minutes before eating reduces calorie '
          'intake by up to 13 % in studies — a simple and free weight-loss tool.',
      category: TipCategory.hydration,
      forGoal: FitnessGoal.loseWeight,
    ),
    CoachTip(
      id: 'tip_electrolytes',
      title: 'Replace electrolytes after intense sweating',
      body:
          'Sodium, potassium and magnesium are lost in sweat. Replenishing '
          'them prevents cramps, fatigue and performance drops.',
      category: TipCategory.hydration,
      forGoal: FitnessGoal.buildMuscle,
    ),
    CoachTip(
      id: 'tip_morning_water',
      title: 'Start the day with 500 ml of water',
      body:
          'You lose water during sleep via respiration. Rehydrating first '
          'thing improves alertness, digestion and morning workout performance.',
      category: TipCategory.hydration,
    ),
    CoachTip(
      id: 'tip_urine_colour',
      title: 'Use urine colour as your hydration gauge',
      body:
          'Pale straw yellow means you are well hydrated. Dark yellow or '
          'amber is a signal to drink more water immediately.',
      category: TipCategory.hydration,
    ),
    CoachTip(
      id: 'tip_limit_alcohol',
      title: 'Limit alcohol — it blocks fat burning',
      body:
          'The liver prioritises metabolising alcohol above everything else, '
          'pausing fat oxidation for hours and adding empty calories.',
      category: TipCategory.hydration,
      forGoal: FitnessGoal.loseWeight,
    ),
    CoachTip(
      id: 'tip_health_green_tea',
      title: 'Swap one coffee for green tea',
      body:
          'Green tea provides a gentler caffeine hit alongside EGCG antioxidants '
          'that support metabolic health and reduce oxidative stress.',
      category: TipCategory.hydration,
      forGoal: FitnessGoal.improveHealth,
    ),
  ];

  // ── Prompts ───────────────────────────────────────────────────────────────

  static const List<CoachPrompt> prompts = [
    CoachPrompt(
      question: 'How much protein do I need?',
      answer:
          'For most active people, 1.6–2.2 g of protein per kg of bodyweight '
          'per day is the evidence-based range for supporting muscle repair and '
          'growth. If you are in a calorie deficit, stay at the higher end '
          '(2.0–2.4 g/kg) to preserve muscle mass while losing fat.',
    ),
    CoachPrompt(
      question: 'Why am I not losing weight?',
      answer:
          'The most common reason is underestimating calorie intake — '
          'research shows people misreport by 20–50 %. Try weighing food with '
          'a scale for one week. Other culprits include not enough sleep, '
          'high stress (elevated cortisol), and "eating back" exercise '
          'calories that were already counted.',
    ),
    CoachPrompt(
      question: 'How many rest days do I need?',
      answer:
          'Most people benefit from 1–2 full rest days per week, with active '
          'recovery (walking, yoga, stretching) on the others. Beginners need '
          'more recovery time; advanced lifters can train more frequently by '
          'rotating which muscle groups are trained each session.',
    ),
    CoachPrompt(
      question: 'Is cardio or weights better for fat loss?',
      answer:
          'Both are effective, but resistance training has the edge long-term '
          'because it builds muscle that raises your resting metabolic rate. '
          'Cardio burns more calories during the session itself. The optimal '
          'approach is to combine both — lift 3 days per week and add '
          '2–3 cardio sessions for maximum fat loss and body composition.',
    ),
    CoachPrompt(
      question: 'How much water should I drink per day?',
      answer:
          'A practical starting point is 35 ml per kg of bodyweight — about '
          '2.5 L for a 70 kg person. Add approximately 500 ml for each hour '
          'of exercise. Pale yellow urine is the best real-time indicator '
          'that you are adequately hydrated.',
    ),
    CoachPrompt(
      question: 'What should I eat before a workout?',
      answer:
          'Eat a balanced meal with complex carbohydrates and moderate protein '
          '1.5–2 hours before training (e.g. oats with Greek yogurt). If '
          'training within 30–60 minutes, a small fast-digesting snack like '
          'a banana or rice cake with peanut butter works well.',
    ),
    CoachPrompt(
      question: 'How long before I see results?',
      answer:
          'Expect to feel better within 1–2 weeks (improved energy, sleep, '
          'mood). Visible body composition changes typically take 4–8 weeks '
          'of consistent training and nutrition. Significant transformation '
          'requires 3–6 months. Progress photos every two weeks are more '
          'reliable than daily scale readings.',
    ),
    CoachPrompt(
      question: 'Can I target fat loss in a specific area?',
      answer:
          'Spot reduction is a myth — the body loses fat systemically, not '
          'from whatever area you are training. However, building muscle in a '
          'specific area (e.g. glutes, abs) while reducing overall body fat '
          'will dramatically change how that area looks.',
    ),
    CoachPrompt(
      question: 'How important is sleep for fitness?',
      answer:
          'Critical. During deep sleep, the body releases the majority of its '
          'daily growth hormone, repairs muscle tissue and consolidates motor '
          'learning from training. Sleeping less than 6 hours a night has been '
          'shown to reduce muscle gain and increase fat retention even when '
          'calorie intake and exercise are identical.',
    ),
    CoachPrompt(
      question: 'Should I train when I am sore?',
      answer:
          'Mild DOMS (delayed onset muscle soreness) is not a reason to rest '
          'completely — light training on a different muscle group actually '
          'increases blood flow and speeds up recovery. If the soreness is '
          'severe, sharp, or affects joint movement, take an extra rest day '
          'and focus on mobility work instead.',
    ),
    CoachPrompt(
      question: 'What is the best diet for building muscle?',
      answer:
          'No single diet is required — total protein and calorie intake '
          'matter most. Aim for a 200–300 kcal surplus above maintenance, '
          '1.6–2.2 g/kg protein, and prioritise whole-food carbohydrates to '
          'fuel training. Creatine monohydrate (3–5 g/day) is the only '
          'supplement with strong evidence for enhancing muscle growth.',
    ),
    CoachPrompt(
      question: 'How do I break through a weight-loss plateau?',
      answer:
          'Plateaus occur because your body adapts — your TDEE decreases as '
          'you get lighter. Try a diet break at maintenance for 1–2 weeks to '
          'normalise hormones, then return to a deficit. Simultaneously, '
          'increase NEAT (daily steps), reassess your calorie tracking '
          'accuracy, and consider adding or changing your cardio modality.',
    ),
  ];

  // ── Helper ────────────────────────────────────────────────────────────────

  /// Returns tips that are either goal-specific for [g] or universal (forGoal == null).
  static List<CoachTip> forGoal(FitnessGoal g) =>
      tips.where((t) => t.forGoal == null || t.forGoal == g).toList();
}
