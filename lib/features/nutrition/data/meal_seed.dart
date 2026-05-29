import '../domain/meal.dart';
import '../../onboarding/domain/user_profile.dart';

/// Pre-built meal plans for every supported diet type.
/// Macros satisfy: kcal ≈ protein*4 + carbs*4 + fat*9 (±50 kcal).
/// Daily totals land in the 1 300–1 700 kcal range (higher protein for
/// keto / paleo).  All constructors are const so the lists can live in
/// static const fields.
class MealSeed {
  MealSeed._();

  static const List<DietType> supportedDiets = [
    DietType.balanced,
    DietType.keto,
    DietType.vegetarian,
    DietType.vegan,
    DietType.glutenFree,
    DietType.paleo,
  ];

  static List<DayMealPlan> forDiet(DietType d) => switch (d) {
        DietType.balanced => balanced,
        DietType.keto => keto,
        DietType.vegetarian => vegetarian,
        DietType.vegan => vegan,
        DietType.glutenFree => glutenFree,
        DietType.paleo => paleo,
      };

  // ─────────────────────────────────────────────────────────────────────────
  // BALANCED  (target ~1 500 kcal/day, 30 % P / 40 % C / 30 % F)
  // ─────────────────────────────────────────────────────────────────────────
  static const List<DayMealPlan> balanced = [
    // Day 1
    DayMealPlan(day: 1, meals: [
      Meal(
        id: 'balanced_d1_breakfast',
        name: 'Greek Yogurt Parfait',
        type: MealType.breakfast,
        kcal: 340,
        protein: 22,
        carbs: 42,
        fat: 8,
        // 22*4 + 42*4 + 8*9 = 88+168+72 = 328  (Δ = 12 ≈ rounding)
        emoji: '🥛',
        description: 'Creamy Greek yogurt layered with granola and fresh berries.',
        ingredients: [
          '180 g low-fat Greek yogurt',
          '30 g granola',
          '80 g mixed berries',
          '1 tsp honey',
        ],
        steps: [
          'Spoon yogurt into a glass or bowl.',
          'Top with granola and berries.',
          'Drizzle honey over the top and serve immediately.',
        ],
        prepMinutes: 5,
        diets: [DietType.balanced, DietType.vegetarian, DietType.glutenFree],
      ),
      Meal(
        id: 'balanced_d1_lunch',
        name: 'Chicken & Quinoa Power Bowl',
        type: MealType.lunch,
        kcal: 490,
        protein: 42,
        carbs: 48,
        fat: 13,
        // 42*4 + 48*4 + 13*9 = 168+192+117 = 477 (Δ = 13)
        emoji: '🥗',
        description: 'Grilled chicken breast over fluffy quinoa with roasted veg.',
        ingredients: [
          '150 g grilled chicken breast',
          '90 g cooked quinoa',
          '80 g roasted bell peppers',
          '1 tbsp olive oil',
          'Lemon juice & herbs',
        ],
        steps: [
          'Season chicken with salt, pepper, and dried herbs; grill 6 min per side.',
          'Cook quinoa in chicken broth for extra flavour.',
          'Roast peppers at 200 °C for 20 min.',
          'Assemble bowl; drizzle with olive oil and lemon.',
        ],
        prepMinutes: 30,
        diets: [DietType.balanced, DietType.glutenFree, DietType.paleo],
      ),
      Meal(
        id: 'balanced_d1_dinner',
        name: 'Baked Salmon with Sweet Potato',
        type: MealType.dinner,
        kcal: 520,
        protein: 40,
        carbs: 38,
        fat: 20,
        // 40*4 + 38*4 + 20*9 = 160+152+180 = 492 (Δ = 28)
        emoji: '🐟',
        description: 'Herb-crusted salmon fillet with mashed sweet potato and steamed broccoli.',
        ingredients: [
          '180 g salmon fillet',
          '200 g sweet potato',
          '100 g broccoli florets',
          '1 tbsp olive oil',
          'Garlic & rosemary',
        ],
        steps: [
          'Preheat oven to 200 °C.',
          'Rub salmon with olive oil, garlic, and rosemary; bake 15 min.',
          'Boil sweet potato until tender; mash with a pinch of salt.',
          'Steam broccoli 5 min; plate everything together.',
        ],
        prepMinutes: 25,
        diets: [DietType.balanced, DietType.glutenFree, DietType.paleo],
      ),
      Meal(
        id: 'balanced_d1_snack',
        name: 'Apple & Almond Butter',
        type: MealType.snack,
        kcal: 210,
        protein: 4,
        carbs: 28,
        fat: 10,
        // 4*4 + 28*4 + 10*9 = 16+112+90 = 218 (Δ = 8)
        emoji: '🍎',
        description: 'Crisp apple slices with natural almond butter for a satisfying crunch.',
        ingredients: [
          '1 medium apple',
          '2 tbsp almond butter',
        ],
        steps: [
          'Core and slice the apple.',
          'Serve with almond butter for dipping.',
        ],
        prepMinutes: 3,
        diets: [DietType.balanced, DietType.vegetarian, DietType.vegan, DietType.glutenFree, DietType.paleo],
      ),
    ]),

    // Day 2
    DayMealPlan(day: 2, meals: [
      Meal(
        id: 'balanced_d2_breakfast',
        name: 'Avocado Toast with Poached Egg',
        type: MealType.breakfast,
        kcal: 370,
        protein: 18,
        carbs: 34,
        fat: 18,
        // 18*4 + 34*4 + 18*9 = 72+136+162 = 370 ✓
        emoji: '🥑',
        description: 'Whole-grain toast smeared with avocado and topped with a runny poached egg.',
        ingredients: [
          '2 slices whole-grain bread',
          '½ ripe avocado',
          '2 eggs',
          'Chilli flakes & sea salt',
        ],
        steps: [
          'Toast the bread until golden.',
          'Mash avocado with salt and chilli flakes; spread on toast.',
          'Poach eggs in simmering water for 3 min; place on top.',
        ],
        prepMinutes: 10,
        diets: [DietType.balanced, DietType.vegetarian],
      ),
      Meal(
        id: 'balanced_d2_lunch',
        name: 'Turkey & Veggie Wrap',
        type: MealType.lunch,
        kcal: 450,
        protein: 34,
        carbs: 44,
        fat: 14,
        // 34*4 + 44*4 + 14*9 = 136+176+126 = 438 (Δ = 12)
        emoji: '🌯',
        description: 'Sliced turkey breast, crispy veg, and hummus wrapped in a whole-wheat tortilla.',
        ingredients: [
          '1 whole-wheat tortilla',
          '100 g sliced turkey breast',
          '2 tbsp hummus',
          '50 g mixed salad leaves',
          'Sliced cucumber & tomato',
        ],
        steps: [
          'Warm tortilla in a dry pan for 30 seconds.',
          'Spread hummus evenly across the centre.',
          'Layer turkey and vegetables; roll tightly.',
          'Slice in half and serve.',
        ],
        prepMinutes: 8,
        diets: [DietType.balanced],
      ),
      Meal(
        id: 'balanced_d2_dinner',
        name: 'Lean Beef Stir-Fry',
        type: MealType.dinner,
        kcal: 480,
        protein: 36,
        carbs: 42,
        fat: 14,
        // 36*4 + 42*4 + 14*9 = 144+168+126 = 438 (Δ = 42)
        emoji: '🥩',
        description: 'Tender strips of lean beef wok-tossed with colourful vegetables and brown rice.',
        ingredients: [
          '150 g lean beef sirloin strips',
          '100 g cooked brown rice',
          '120 g stir-fry vegetables',
          '2 tbsp low-sodium soy sauce',
          '1 tsp sesame oil',
        ],
        steps: [
          'Heat wok on high; add sesame oil.',
          'Sear beef strips 2–3 min; remove.',
          'Stir-fry vegetables 4 min; return beef.',
          'Add soy sauce; toss and serve over rice.',
        ],
        prepMinutes: 20,
        diets: [DietType.balanced],
      ),
      Meal(
        id: 'balanced_d2_snack',
        name: 'Cottage Cheese & Pineapple',
        type: MealType.snack,
        kcal: 180,
        protein: 18,
        carbs: 20,
        fat: 3,
        // 18*4 + 20*4 + 3*9 = 72+80+27 = 179 (Δ = 1) ✓
        emoji: '🍍',
        description: 'High-protein cottage cheese with juicy pineapple chunks.',
        ingredients: [
          '150 g low-fat cottage cheese',
          '80 g fresh pineapple chunks',
        ],
        steps: [
          'Spoon cottage cheese into a bowl.',
          'Top with pineapple and serve chilled.',
        ],
        prepMinutes: 3,
        diets: [DietType.balanced, DietType.vegetarian, DietType.glutenFree],
      ),
    ]),

    // Day 3
    DayMealPlan(day: 3, meals: [
      Meal(
        id: 'balanced_d3_breakfast',
        name: 'Oat & Banana Smoothie Bowl',
        type: MealType.breakfast,
        kcal: 360,
        protein: 14,
        carbs: 58,
        fat: 8,
        // 14*4 + 58*4 + 8*9 = 56+232+72 = 360 ✓
        emoji: '🍌',
        description: 'Thick blended oat-banana base loaded with toppings.',
        ingredients: [
          '1 frozen banana',
          '40 g rolled oats',
          '150 ml almond milk',
          '1 tbsp chia seeds',
          '1 tbsp peanut butter',
        ],
        steps: [
          'Blend banana, oats, and almond milk until smooth.',
          'Pour into a bowl; add chia seeds.',
          'Dollop peanut butter on top and serve.',
        ],
        prepMinutes: 7,
        diets: [DietType.balanced, DietType.vegetarian, DietType.vegan],
      ),
      Meal(
        id: 'balanced_d3_lunch',
        name: 'Tuna Niçoise Salad',
        type: MealType.lunch,
        kcal: 430,
        protein: 36,
        carbs: 30,
        fat: 18,
        // 36*4 + 30*4 + 18*9 = 144+120+162 = 426 (Δ = 4) ✓
        emoji: '🥚',
        description: 'Classic French salad with tuna, egg, olives, and green beans.',
        ingredients: [
          '120 g canned tuna in water',
          '2 hard-boiled eggs',
          '80 g green beans',
          '8 black olives',
          '1 tbsp Dijon mustard dressing',
        ],
        steps: [
          'Blanch green beans 3 min; cool under cold water.',
          'Arrange tuna, eggs, beans, and olives on a plate.',
          'Drizzle mustard dressing over the top.',
        ],
        prepMinutes: 15,
        diets: [DietType.balanced, DietType.glutenFree, DietType.paleo],
      ),
      Meal(
        id: 'balanced_d3_dinner',
        name: 'Chicken Veggie Soup',
        type: MealType.dinner,
        kcal: 430,
        protein: 34,
        carbs: 40,
        fat: 12,
        // 34*4 + 40*4 + 12*9 = 136+160+108 = 404 (Δ = 26)
        emoji: '🍲',
        description: 'Hearty chicken and vegetable soup with noodles — comfort in a bowl.',
        ingredients: [
          '150 g chicken breast, diced',
          '80 g egg noodles',
          '100 g mixed root vegetables',
          '500 ml chicken broth',
          'Parsley & thyme',
        ],
        steps: [
          'Bring broth to a simmer; add chicken and vegetables.',
          'Cook 15 min until chicken is done.',
          'Add noodles; cook 5 min more.',
          'Season with salt, pepper, and fresh parsley.',
        ],
        prepMinutes: 25,
        diets: [DietType.balanced],
      ),
      Meal(
        id: 'balanced_d3_snack',
        name: 'Rice Cake with Nut Butter',
        type: MealType.snack,
        kcal: 200,
        protein: 5,
        carbs: 26,
        fat: 9,
        // 5*4 + 26*4 + 9*9 = 20+104+81 = 205 (Δ = 5) ✓
        emoji: '🫙',
        description: 'Light rice cakes spread with creamy cashew butter.',
        ingredients: [
          '2 plain rice cakes',
          '2 tbsp cashew butter',
        ],
        steps: [
          'Spread cashew butter generously on rice cakes.',
          'Enjoy as a quick afternoon snack.',
        ],
        prepMinutes: 2,
        diets: [DietType.balanced, DietType.vegetarian, DietType.vegan, DietType.glutenFree],
      ),
    ]),
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // KETO  (target ~1 600 kcal/day, 30 % P / 5 % C / 65 % F)
  // ─────────────────────────────────────────────────────────────────────────
  static const List<DayMealPlan> keto = [
    // Day 1
    DayMealPlan(day: 1, meals: [
      Meal(
        id: 'keto_d1_breakfast',
        name: 'Bacon & Egg Scramble',
        type: MealType.breakfast,
        kcal: 420,
        protein: 28,
        carbs: 3,
        fat: 34,
        // 28*4 + 3*4 + 34*9 = 112+12+306 = 430 (Δ = 10) ✓
        emoji: '🥓',
        description: 'Crispy bacon and fluffy eggs scrambled in butter — keto morning classic.',
        ingredients: [
          '3 rashers streaky bacon',
          '3 large eggs',
          '1 tbsp butter',
          'Chives & black pepper',
        ],
        steps: [
          'Fry bacon in a non-stick pan until crispy; set aside.',
          'Melt butter in the same pan over medium heat.',
          'Whisk eggs; pour in and scramble gently.',
          'Top with bacon and snipped chives.',
        ],
        prepMinutes: 10,
        diets: [DietType.keto, DietType.glutenFree, DietType.paleo],
      ),
      Meal(
        id: 'keto_d1_lunch',
        name: 'Cobb Salad',
        type: MealType.lunch,
        kcal: 520,
        protein: 38,
        carbs: 7,
        fat: 38,
        // 38*4 + 7*4 + 38*9 = 152+28+342 = 522 (Δ = 2) ✓
        emoji: '🥗',
        description: 'Classic cobb with grilled chicken, avocado, egg, bacon, and blue cheese.',
        ingredients: [
          '140 g grilled chicken',
          '½ avocado, diced',
          '2 hard-boiled eggs',
          '2 rashers bacon, crumbled',
          '20 g blue cheese',
        ],
        steps: [
          'Arrange salad greens in a wide bowl.',
          'Top in rows with chicken, avocado, egg, bacon, and cheese.',
          'Drizzle with olive oil and red-wine vinegar dressing.',
        ],
        prepMinutes: 15,
        diets: [DietType.keto, DietType.glutenFree],
      ),
      Meal(
        id: 'keto_d1_dinner',
        name: 'Butter-Basted Ribeye with Asparagus',
        type: MealType.dinner,
        kcal: 590,
        protein: 44,
        carbs: 5,
        fat: 44,
        // 44*4 + 5*4 + 44*9 = 176+20+396 = 592 (Δ = 2) ✓
        emoji: '🥩',
        description: 'Pan-seared ribeye finished in herb butter with roasted asparagus.',
        ingredients: [
          '220 g ribeye steak',
          '150 g asparagus spears',
          '2 tbsp butter',
          'Garlic, thyme & rosemary',
        ],
        steps: [
          'Season steak generously; sear in cast iron 3 min per side.',
          'Add butter, garlic, and herbs; baste steak for 2 min.',
          'Rest steak 5 min before slicing.',
          'Roast asparagus at 220 °C for 10 min.',
        ],
        prepMinutes: 20,
        diets: [DietType.keto, DietType.glutenFree, DietType.paleo],
      ),
      Meal(
        id: 'keto_d1_snack',
        name: 'Cheese & Pepperoni Bites',
        type: MealType.snack,
        kcal: 200,
        protein: 11,
        carbs: 2,
        fat: 17,
        // 11*4 + 2*4 + 17*9 = 44+8+153 = 205 (Δ = 5) ✓
        emoji: '🧀',
        description: 'Cubes of sharp cheddar paired with spicy pepperoni slices.',
        ingredients: [
          '40 g cheddar cheese',
          '30 g pepperoni slices',
        ],
        steps: [
          'Cube the cheese.',
          'Arrange with pepperoni on a small plate and serve.',
        ],
        prepMinutes: 2,
        diets: [DietType.keto, DietType.glutenFree],
      ),
    ]),

    // Day 2
    DayMealPlan(day: 2, meals: [
      Meal(
        id: 'keto_d2_breakfast',
        name: 'Smoked Salmon Avocado Bowl',
        type: MealType.breakfast,
        kcal: 430,
        protein: 26,
        carbs: 6,
        fat: 34,
        // 26*4 + 6*4 + 34*9 = 104+24+306 = 434 (Δ = 4) ✓
        emoji: '🍣',
        description: 'Silky smoked salmon over mashed avocado with capers and lemon.',
        ingredients: [
          '100 g smoked salmon',
          '1 ripe avocado',
          '1 tbsp capers',
          'Lemon juice & dill',
        ],
        steps: [
          'Halve and mash avocado with lemon juice; season.',
          'Spoon into a bowl; lay salmon on top.',
          'Scatter capers and fresh dill to finish.',
        ],
        prepMinutes: 8,
        diets: [DietType.keto, DietType.glutenFree, DietType.paleo],
      ),
      Meal(
        id: 'keto_d2_lunch',
        name: 'Lettuce-Wrapped Beef Tacos',
        type: MealType.lunch,
        kcal: 510,
        protein: 36,
        carbs: 8,
        fat: 37,
        // 36*4 + 8*4 + 37*9 = 144+32+333 = 509 (Δ = 1) ✓
        emoji: '🌮',
        description: 'Seasoned ground beef in crisp butter-lettuce cups with guac and sour cream.',
        ingredients: [
          '180 g lean ground beef',
          '4 butter-lettuce leaves',
          '3 tbsp guacamole',
          '2 tbsp sour cream',
          'Cumin, chilli & lime',
        ],
        steps: [
          'Cook beef in a pan with cumin and chilli until browned.',
          'Season with salt, pepper, and lime juice.',
          'Spoon into lettuce cups; top with guac and sour cream.',
        ],
        prepMinutes: 15,
        diets: [DietType.keto, DietType.glutenFree],
      ),
      Meal(
        id: 'keto_d2_dinner',
        name: 'Creamy Chicken Thigh Skillet',
        type: MealType.dinner,
        kcal: 570,
        protein: 40,
        carbs: 7,
        fat: 42,
        // 40*4 + 7*4 + 42*9 = 160+28+378 = 566 (Δ = 4) ✓
        emoji: '🍗',
        description: 'Juicy chicken thighs braised in a garlic-Parmesan cream sauce.',
        ingredients: [
          '200 g bone-in chicken thighs',
          '100 ml heavy cream',
          '2 cloves garlic',
          '20 g Parmesan, grated',
          'Spinach & sun-dried tomatoes',
        ],
        steps: [
          'Sear chicken thighs skin-side down until golden, 5 min.',
          'Flip; add garlic, cream, and Parmesan.',
          'Simmer covered 20 min until cooked through.',
          'Stir in spinach for last 2 min.',
        ],
        prepMinutes: 30,
        diets: [DietType.keto, DietType.glutenFree],
      ),
      Meal(
        id: 'keto_d2_snack',
        name: 'Macadamia Nuts',
        type: MealType.snack,
        kcal: 200,
        protein: 2,
        carbs: 4,
        fat: 21,
        // 2*4 + 4*4 + 21*9 = 8+16+189 = 213 (Δ = 13)
        emoji: '🥜',
        description: 'A small handful of rich, buttery macadamia nuts — pure keto fuel.',
        ingredients: [
          '30 g macadamia nuts',
        ],
        steps: [
          'Measure 30 g into a small bowl.',
          'Enjoy as a slow, satisfying snack.',
        ],
        prepMinutes: 1,
        diets: [DietType.keto, DietType.vegan, DietType.vegetarian, DietType.glutenFree, DietType.paleo],
      ),
    ]),

    // Day 3
    DayMealPlan(day: 3, meals: [
      Meal(
        id: 'keto_d3_breakfast',
        name: 'Keto Almond-Flour Pancakes',
        type: MealType.breakfast,
        kcal: 400,
        protein: 20,
        carbs: 8,
        fat: 34,
        // 20*4 + 8*4 + 34*9 = 80+32+306 = 418 (Δ = 18)
        emoji: '🥞',
        description: 'Fluffy pancakes made with almond flour, served with butter and berries.',
        ingredients: [
          '80 g almond flour',
          '3 eggs',
          '2 tbsp cream cheese',
          '1 tbsp butter for frying',
          '30 g fresh blueberries',
        ],
        steps: [
          'Blend almond flour, eggs, and cream cheese until smooth.',
          'Pour small rounds into a buttered pan over medium heat.',
          'Cook 2 min per side until set and golden.',
          'Top with blueberries and a pat of butter.',
        ],
        prepMinutes: 15,
        diets: [DietType.keto, DietType.vegetarian, DietType.glutenFree],
      ),
      Meal(
        id: 'keto_d3_lunch',
        name: 'Egg Salad Stuffed Peppers',
        type: MealType.lunch,
        kcal: 480,
        protein: 22,
        carbs: 9,
        fat: 40,
        // 22*4 + 9*4 + 40*9 = 88+36+360 = 484 (Δ = 4) ✓
        emoji: '🫑',
        description: 'Creamy egg salad piled into sweet mini bell peppers.',
        ingredients: [
          '4 hard-boiled eggs',
          '3 tbsp mayonnaise',
          '1 tsp Dijon mustard',
          '3 mini bell peppers, halved',
          'Paprika & chives',
        ],
        steps: [
          'Chop eggs; mix with mayo, mustard, salt, and pepper.',
          'Halve and deseed mini peppers.',
          'Fill peppers with egg salad; dust with paprika.',
        ],
        prepMinutes: 12,
        diets: [DietType.keto, DietType.vegetarian, DietType.glutenFree],
      ),
      Meal(
        id: 'keto_d3_dinner',
        name: 'Pesto Zoodles with Shrimp',
        type: MealType.dinner,
        kcal: 490,
        protein: 38,
        carbs: 10,
        fat: 34,
        // 38*4 + 10*4 + 34*9 = 152+40+306 = 498 (Δ = 8) ✓
        emoji: '🍤',
        description: 'Zucchini noodles tossed in homemade basil pesto with juicy pan-fried shrimp.',
        ingredients: [
          '200 g zucchini noodles',
          '180 g large shrimp, peeled',
          '3 tbsp basil pesto',
          '1 tbsp olive oil',
          'Cherry tomatoes & lemon',
        ],
        steps: [
          'Sauté shrimp in olive oil 2 min per side; set aside.',
          'Add zoodles to pan; toss 2 min.',
          'Stir in pesto off the heat; top with shrimp.',
          'Garnish with cherry tomatoes and lemon zest.',
        ],
        prepMinutes: 15,
        diets: [DietType.keto, DietType.glutenFree, DietType.paleo],
      ),
      Meal(
        id: 'keto_d3_snack',
        name: 'Celery with Cream Cheese',
        type: MealType.snack,
        kcal: 140,
        protein: 3,
        carbs: 4,
        fat: 13,
        // 3*4 + 4*4 + 13*9 = 12+16+117 = 145 (Δ = 5) ✓
        emoji: '🥬',
        description: 'Crisp celery sticks filled with whipped cream cheese.',
        ingredients: [
          '3 celery stalks',
          '3 tbsp cream cheese',
        ],
        steps: [
          'Cut celery into 8 cm sticks.',
          'Fill the groove with cream cheese and enjoy.',
        ],
        prepMinutes: 3,
        diets: [DietType.keto, DietType.vegetarian, DietType.glutenFree],
      ),
    ]),
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // VEGETARIAN  (target ~1 500 kcal/day, 20 % P / 55 % C / 25 % F)
  // ─────────────────────────────────────────────────────────────────────────
  static const List<DayMealPlan> vegetarian = [
    // Day 1
    DayMealPlan(day: 1, meals: [
      Meal(
        id: 'veg_d1_breakfast',
        name: 'Spinach & Feta Omelette',
        type: MealType.breakfast,
        kcal: 330,
        protein: 22,
        carbs: 6,
        fat: 24,
        // 22*4 + 6*4 + 24*9 = 88+24+216 = 328 (Δ = 2) ✓
        emoji: '🍳',
        description: 'Fluffy three-egg omelette stuffed with wilted spinach and tangy feta.',
        ingredients: [
          '3 eggs',
          '40 g baby spinach',
          '30 g feta cheese, crumbled',
          '1 tsp olive oil',
          'Nutmeg & black pepper',
        ],
        steps: [
          'Whisk eggs with a pinch of nutmeg and pepper.',
          'Sauté spinach in olive oil 1 min; set aside.',
          'Pour eggs into pan; cook edges then fold with spinach and feta inside.',
        ],
        prepMinutes: 10,
        diets: [DietType.vegetarian, DietType.glutenFree, DietType.keto],
      ),
      Meal(
        id: 'veg_d1_lunch',
        name: 'Caprese Pasta Salad',
        type: MealType.lunch,
        kcal: 470,
        protein: 18,
        carbs: 58,
        fat: 18,
        // 18*4 + 58*4 + 18*9 = 72+232+162 = 466 (Δ = 4) ✓
        emoji: '🍝',
        description: 'Penne with cherry tomatoes, fresh mozzarella, basil, and a balsamic glaze.',
        ingredients: [
          '80 g whole-wheat penne, dry',
          '100 g cherry tomatoes',
          '60 g fresh mozzarella',
          '1 tbsp balsamic glaze',
          'Fresh basil',
        ],
        steps: [
          'Cook penne per packet instructions; drain and cool.',
          'Halve tomatoes; tear mozzarella.',
          'Toss everything with balsamic glaze and basil.',
        ],
        prepMinutes: 20,
        diets: [DietType.vegetarian],
      ),
      Meal(
        id: 'veg_d1_dinner',
        name: 'Lentil Dahl with Basmati Rice',
        type: MealType.dinner,
        kcal: 490,
        protein: 22,
        carbs: 74,
        fat: 10,
        // 22*4 + 74*4 + 10*9 = 88+296+90 = 474 (Δ = 16)
        emoji: '🫘',
        description: 'Rich, spiced red-lentil dahl served over fluffy basmati rice.',
        ingredients: [
          '100 g red lentils, dry',
          '80 g basmati rice, dry',
          '200 ml coconut milk (light)',
          '1 tsp turmeric, cumin & garam masala',
          '1 tbsp coconut oil',
        ],
        steps: [
          'Rinse lentils; simmer in 400 ml water with spices 20 min.',
          'Stir in coconut milk; cook 5 min more.',
          'Cook rice separately; serve dahl over rice.',
        ],
        prepMinutes: 30,
        diets: [DietType.vegetarian, DietType.vegan, DietType.glutenFree],
      ),
      Meal(
        id: 'veg_d1_snack',
        name: 'Hummus & Veggie Sticks',
        type: MealType.snack,
        kcal: 190,
        protein: 7,
        carbs: 22,
        fat: 8,
        // 7*4 + 22*4 + 8*9 = 28+88+72 = 188 (Δ = 2) ✓
        emoji: '🫛',
        description: 'Velvety hummus with colourful carrot, cucumber, and pepper dippers.',
        ingredients: [
          '4 tbsp hummus',
          '1 medium carrot, cut into sticks',
          '½ cucumber, sliced',
          '½ red pepper, sliced',
        ],
        steps: [
          'Spoon hummus into a small bowl.',
          'Arrange vegetable sticks around it and serve.',
        ],
        prepMinutes: 5,
        diets: [DietType.vegetarian, DietType.vegan, DietType.glutenFree, DietType.balanced],
      ),
    ]),

    // Day 2
    DayMealPlan(day: 2, meals: [
      Meal(
        id: 'veg_d2_breakfast',
        name: 'Banana Oat Pancakes',
        type: MealType.breakfast,
        kcal: 350,
        protein: 14,
        carbs: 54,
        fat: 8,
        // 14*4 + 54*4 + 8*9 = 56+216+72 = 344 (Δ = 6) ✓
        emoji: '🥞',
        description: 'Two-ingredient banana-oat pancakes — naturally sweet and satisfying.',
        ingredients: [
          '2 ripe bananas',
          '80 g rolled oats',
          '2 eggs',
          '½ tsp cinnamon',
        ],
        steps: [
          'Mash bananas; mix in oats, eggs, and cinnamon.',
          'Cook small rounds in a non-stick pan 2 min per side.',
          'Serve with a drizzle of maple syrup if desired.',
        ],
        prepMinutes: 12,
        diets: [DietType.vegetarian, DietType.glutenFree],
      ),
      Meal(
        id: 'veg_d2_lunch',
        name: 'Black Bean Quesadillas',
        type: MealType.lunch,
        kcal: 460,
        protein: 20,
        carbs: 56,
        fat: 16,
        // 20*4 + 56*4 + 16*9 = 80+224+144 = 448 (Δ = 12)
        emoji: '🫔',
        description: 'Crispy whole-wheat tortillas stuffed with spiced black beans and melted cheese.',
        ingredients: [
          '2 whole-wheat tortillas',
          '120 g canned black beans, drained',
          '50 g cheddar cheese, grated',
          '2 tbsp salsa',
          'Cumin & smoked paprika',
        ],
        steps: [
          'Season beans with cumin and paprika.',
          'Layer beans and cheese on one tortilla; fold in half.',
          'Pan-fry 2 min per side until golden; slice and serve with salsa.',
        ],
        prepMinutes: 12,
        diets: [DietType.vegetarian],
      ),
      Meal(
        id: 'veg_d2_dinner',
        name: 'Vegetable Tikka Masala',
        type: MealType.dinner,
        kcal: 480,
        protein: 16,
        carbs: 60,
        fat: 18,
        // 16*4 + 60*4 + 18*9 = 64+240+162 = 466 (Δ = 14)
        emoji: '🍛',
        description: 'Creamy tomato-based curry packed with cauliflower, paneer, and peas.',
        ingredients: [
          '100 g paneer, cubed',
          '150 g cauliflower florets',
          '80 g frozen peas',
          '150 ml tikka masala sauce',
          '80 g cooked basmati rice',
        ],
        steps: [
          'Pan-fry paneer until golden; remove.',
          'Add cauliflower to sauce; simmer 15 min.',
          'Add peas and paneer; cook 5 min more.',
          'Serve over basmati rice.',
        ],
        prepMinutes: 25,
        diets: [DietType.vegetarian, DietType.glutenFree],
      ),
      Meal(
        id: 'veg_d2_snack',
        name: 'String Cheese & Grapes',
        type: MealType.snack,
        kcal: 190,
        protein: 10,
        carbs: 22,
        fat: 7,
        // 10*4 + 22*4 + 7*9 = 40+88+63 = 191 (Δ = 1) ✓
        emoji: '🍇',
        description: 'Peelable string cheese alongside a small bunch of sweet grapes.',
        ingredients: [
          '1 stick mozzarella string cheese',
          '80 g seedless grapes',
        ],
        steps: [
          'Peel string cheese into strips.',
          'Pair with washed grapes as a light snack.',
        ],
        prepMinutes: 2,
        diets: [DietType.vegetarian, DietType.glutenFree, DietType.balanced],
      ),
    ]),

    // Day 3
    DayMealPlan(day: 3, meals: [
      Meal(
        id: 'veg_d3_breakfast',
        name: 'Overnight Chia Oats',
        type: MealType.breakfast,
        kcal: 360,
        protein: 14,
        carbs: 50,
        fat: 11,
        // 14*4 + 50*4 + 11*9 = 56+200+99 = 355 (Δ = 5) ✓
        emoji: '🥣',
        description: 'Creamy oats soaked overnight with chia seeds, topped with mango.',
        ingredients: [
          '50 g rolled oats',
          '2 tbsp chia seeds',
          '200 ml oat milk',
          '80 g diced mango',
          '1 tsp maple syrup',
        ],
        steps: [
          'Mix oats, chia seeds, oat milk, and maple syrup in a jar.',
          'Refrigerate overnight.',
          'Top with fresh mango before serving.',
        ],
        prepMinutes: 5,
        diets: [DietType.vegetarian, DietType.vegan, DietType.glutenFree],
      ),
      Meal(
        id: 'veg_d3_lunch',
        name: 'Margherita Flatbread',
        type: MealType.lunch,
        kcal: 430,
        protein: 18,
        carbs: 54,
        fat: 15,
        // 18*4 + 54*4 + 15*9 = 72+216+135 = 423 (Δ = 7) ✓
        emoji: '🍕',
        description: 'Wholemeal flatbread with tomato sauce, fresh mozzarella, and basil.',
        ingredients: [
          '1 wholemeal flatbread',
          '3 tbsp passata',
          '60 g fresh mozzarella',
          '5 cherry tomatoes',
          'Fresh basil & olive oil',
        ],
        steps: [
          'Spread passata on flatbread.',
          'Top with torn mozzarella and halved tomatoes.',
          'Grill at 220 °C for 8 min; finish with fresh basil.',
        ],
        prepMinutes: 12,
        diets: [DietType.vegetarian],
      ),
      Meal(
        id: 'veg_d3_dinner',
        name: 'Ricotta-Stuffed Bell Peppers',
        type: MealType.dinner,
        kcal: 470,
        protein: 22,
        carbs: 46,
        fat: 20,
        // 22*4 + 46*4 + 20*9 = 88+184+180 = 452 (Δ = 18)
        emoji: '🫑',
        description: 'Oven-roasted bell peppers filled with ricotta, spinach, and herbed quinoa.',
        ingredients: [
          '2 large bell peppers',
          '80 g cooked quinoa',
          '100 g ricotta',
          '40 g baby spinach',
          'Oregano & Parmesan',
        ],
        steps: [
          'Halve peppers; brush with olive oil; roast 10 min at 200 °C.',
          'Mix ricotta, quinoa, and wilted spinach; season well.',
          'Fill peppers; top with Parmesan; bake 15 min more.',
        ],
        prepMinutes: 30,
        diets: [DietType.vegetarian, DietType.glutenFree],
      ),
      Meal(
        id: 'veg_d3_snack',
        name: 'Peanut Butter Banana Bites',
        type: MealType.snack,
        kcal: 200,
        protein: 5,
        carbs: 28,
        fat: 9,
        // 5*4 + 28*4 + 9*9 = 20+112+81 = 213 (Δ = 13)
        emoji: '🍌',
        description: 'Banana rounds spread with peanut butter for a quick energy hit.',
        ingredients: [
          '1 medium banana',
          '1½ tbsp peanut butter',
        ],
        steps: [
          'Slice banana into rounds.',
          'Top each slice with a small dollop of peanut butter.',
        ],
        prepMinutes: 3,
        diets: [DietType.vegetarian, DietType.vegan, DietType.balanced, DietType.glutenFree],
      ),
    ]),
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // VEGAN  (target ~1 450 kcal/day, 20 % P / 55 % C / 25 % F, no animal products)
  // ─────────────────────────────────────────────────────────────────────────
  static const List<DayMealPlan> vegan = [
    // Day 1
    DayMealPlan(day: 1, meals: [
      Meal(
        id: 'vegan_d1_breakfast',
        name: 'Mango Green Smoothie',
        type: MealType.breakfast,
        kcal: 320,
        protein: 10,
        carbs: 56,
        fat: 6,
        // 10*4 + 56*4 + 6*9 = 40+224+54 = 318 (Δ = 2) ✓
        emoji: '🥭',
        description: 'Tropical green smoothie blended with mango, spinach, and hemp seeds.',
        ingredients: [
          '150 g frozen mango',
          '40 g baby spinach',
          '250 ml oat milk',
          '2 tbsp hemp seeds',
          '½ banana',
        ],
        steps: [
          'Add all ingredients to a blender.',
          'Blend until completely smooth.',
          'Pour into a tall glass and enjoy immediately.',
        ],
        prepMinutes: 5,
        diets: [DietType.vegan, DietType.vegetarian, DietType.glutenFree],
      ),
      Meal(
        id: 'vegan_d1_lunch',
        name: 'Chickpea & Avocado Toast',
        type: MealType.lunch,
        kcal: 440,
        protein: 18,
        carbs: 52,
        fat: 17,
        // 18*4 + 52*4 + 17*9 = 72+208+153 = 433 (Δ = 7) ✓
        emoji: '🥑',
        description: 'Sourdough toast topped with smashed avocado and spiced roasted chickpeas.',
        ingredients: [
          '2 slices sourdough bread',
          '½ avocado',
          '80 g canned chickpeas, drained',
          '1 tsp smoked paprika',
          'Lemon juice & micro herbs',
        ],
        steps: [
          'Roast chickpeas with paprika and olive oil at 200 °C for 20 min.',
          'Toast sourdough; smash avocado with lemon juice.',
          'Spread avocado on toast; top with chickpeas.',
        ],
        prepMinutes: 25,
        diets: [DietType.vegan, DietType.vegetarian],
      ),
      Meal(
        id: 'vegan_d1_dinner',
        name: 'Thai Peanut Noodle Bowl',
        type: MealType.dinner,
        kcal: 520,
        protein: 20,
        carbs: 66,
        fat: 18,
        // 20*4 + 66*4 + 18*9 = 80+264+162 = 506 (Δ = 14)
        emoji: '🍜',
        description: 'Rice noodles tossed in a creamy peanut sauce with edamame and shredded carrot.',
        ingredients: [
          '80 g rice noodles, dry',
          '80 g shelled edamame',
          '1 medium carrot, shredded',
          '3 tbsp peanut butter',
          'Soy sauce, lime & ginger',
        ],
        steps: [
          'Cook noodles per packet; rinse under cold water.',
          'Whisk peanut butter, soy sauce, lime, and ginger into a sauce.',
          'Toss noodles, edamame, and carrot in sauce.',
          'Garnish with chopped peanuts and lime wedge.',
        ],
        prepMinutes: 15,
        diets: [DietType.vegan, DietType.vegetarian],
      ),
      Meal(
        id: 'vegan_d1_snack',
        name: 'Date & Walnut Energy Balls',
        type: MealType.snack,
        kcal: 200,
        protein: 4,
        carbs: 28,
        fat: 9,
        // 4*4 + 28*4 + 9*9 = 16+112+81 = 209 (Δ = 9) ✓
        emoji: '⚡',
        description: 'No-bake energy balls rolled from dates, walnuts, and cocoa powder.',
        ingredients: [
          '4 Medjool dates, pitted',
          '30 g walnuts',
          '1 tbsp cocoa powder',
          'Pinch of sea salt',
        ],
        steps: [
          'Blitz all ingredients in a food processor until combined.',
          'Roll into 4 balls; refrigerate 20 min before eating.',
        ],
        prepMinutes: 10,
        diets: [DietType.vegan, DietType.vegetarian, DietType.glutenFree, DietType.paleo],
      ),
    ]),

    // Day 2
    DayMealPlan(day: 2, meals: [
      Meal(
        id: 'vegan_d2_breakfast',
        name: 'Tofu Scramble on Rye',
        type: MealType.breakfast,
        kcal: 350,
        protein: 22,
        carbs: 34,
        fat: 13,
        // 22*4 + 34*4 + 13*9 = 88+136+117 = 341 (Δ = 9) ✓
        emoji: '🧆',
        description: 'Turmeric-spiced tofu scramble piled on hearty rye toast.',
        ingredients: [
          '150 g firm tofu, crumbled',
          '2 slices rye bread',
          '½ tsp turmeric',
          '1 tbsp nutritional yeast',
          'Cherry tomatoes & chives',
        ],
        steps: [
          'Crumble tofu into a pan over medium heat.',
          'Add turmeric, nutritional yeast, salt, and pepper; cook 5 min.',
          'Toast rye bread; pile scramble on top with tomatoes.',
        ],
        prepMinutes: 12,
        diets: [DietType.vegan, DietType.vegetarian],
      ),
      Meal(
        id: 'vegan_d2_lunch',
        name: 'Roasted Veggie Buddha Bowl',
        type: MealType.lunch,
        kcal: 460,
        protein: 16,
        carbs: 58,
        fat: 17,
        // 16*4 + 58*4 + 17*9 = 64+232+153 = 449 (Δ = 11)
        emoji: '🥙',
        description: 'Roasted sweet potato and broccoli over brown rice with tahini drizzle.',
        ingredients: [
          '150 g sweet potato, cubed',
          '100 g broccoli florets',
          '80 g cooked brown rice',
          '2 tbsp tahini',
          'Lemon juice & cumin',
        ],
        steps: [
          'Roast sweet potato and broccoli with cumin at 200 °C for 25 min.',
          'Whisk tahini with lemon juice and a splash of water.',
          'Assemble bowl with rice; top with veg and drizzle tahini.',
        ],
        prepMinutes: 30,
        diets: [DietType.vegan, DietType.vegetarian, DietType.glutenFree],
      ),
      Meal(
        id: 'vegan_d2_dinner',
        name: 'Black Bean Tacos',
        type: MealType.dinner,
        kcal: 480,
        protein: 18,
        carbs: 68,
        fat: 14,
        // 18*4 + 68*4 + 14*9 = 72+272+126 = 470 (Δ = 10) ✓
        emoji: '🌮',
        description: 'Corn tortillas filled with spiced black beans, pickled red onion, and avocado.',
        ingredients: [
          '3 small corn tortillas',
          '150 g canned black beans',
          '½ avocado, sliced',
          '2 tbsp pickled red onion',
          'Lime juice & coriander',
        ],
        steps: [
          'Warm beans with cumin and lime juice in a small pan.',
          'Warm tortillas in a dry pan 30 sec per side.',
          'Fill with beans, avocado, and pickled onion; top with coriander.',
        ],
        prepMinutes: 12,
        diets: [DietType.vegan, DietType.vegetarian, DietType.glutenFree],
      ),
      Meal(
        id: 'vegan_d2_snack',
        name: 'Edamame with Sea Salt',
        type: MealType.snack,
        kcal: 160,
        protein: 12,
        carbs: 14,
        fat: 5,
        // 12*4 + 14*4 + 5*9 = 48+56+45 = 149 (Δ = 11)
        emoji: '🫛',
        description: 'Steamed edamame pods generously sprinkled with flaky sea salt.',
        ingredients: [
          '120 g frozen edamame pods',
          '½ tsp flaky sea salt',
        ],
        steps: [
          'Steam edamame 4 min from frozen.',
          'Toss with sea salt and serve warm.',
        ],
        prepMinutes: 5,
        diets: [DietType.vegan, DietType.vegetarian, DietType.glutenFree, DietType.balanced],
      ),
    ]),

    // Day 3
    DayMealPlan(day: 3, meals: [
      Meal(
        id: 'vegan_d3_breakfast',
        name: 'Acai Smoothie Bowl',
        type: MealType.breakfast,
        kcal: 380,
        protein: 9,
        carbs: 62,
        fat: 11,
        // 9*4 + 62*4 + 11*9 = 36+248+99 = 383 (Δ = 3) ✓
        emoji: '🫐',
        description: 'Thick acai blend topped with granola, banana, and coconut flakes.',
        ingredients: [
          '100 g frozen acai pulp',
          '1 frozen banana',
          '100 ml coconut milk (light)',
          '30 g granola',
          '1 tbsp coconut flakes',
        ],
        steps: [
          'Blend acai, banana, and coconut milk until thick.',
          'Pour into a bowl; top with granola and coconut flakes.',
          'Serve immediately.',
        ],
        prepMinutes: 7,
        diets: [DietType.vegan, DietType.vegetarian, DietType.glutenFree],
      ),
      Meal(
        id: 'vegan_d3_lunch',
        name: 'Lemon Herb Falafel Wrap',
        type: MealType.lunch,
        kcal: 450,
        protein: 16,
        carbs: 58,
        fat: 17,
        // 16*4 + 58*4 + 17*9 = 64+232+153 = 449 (Δ = 1) ✓
        emoji: '🧆',
        description: 'Herb falafel balls wrapped in a soft flatbread with tahini and salad.',
        ingredients: [
          '4 baked falafel balls',
          '1 whole-wheat flatbread',
          '2 tbsp tahini',
          '40 g mixed salad leaves',
          'Cucumber, tomato & lemon',
        ],
        steps: [
          'Warm falafel in oven at 180 °C for 8 min.',
          'Warm flatbread in a dry pan.',
          'Spread tahini; layer salad and falafel; roll tightly.',
        ],
        prepMinutes: 12,
        diets: [DietType.vegan, DietType.vegetarian],
      ),
      Meal(
        id: 'vegan_d3_dinner',
        name: 'Mushroom & Lentil Bolognese',
        type: MealType.dinner,
        kcal: 480,
        protein: 22,
        carbs: 68,
        fat: 9,
        // 22*4 + 68*4 + 9*9 = 88+272+81 = 441 (Δ = 39)
        emoji: '🍝',
        description: 'Hearty mushroom-lentil ragu over whole-wheat spaghetti.',
        ingredients: [
          '80 g whole-wheat spaghetti, dry',
          '100 g brown lentils, cooked',
          '150 g mushrooms, finely chopped',
          '150 g tomato passata',
          'Garlic, thyme & bay leaf',
        ],
        steps: [
          'Sauté mushrooms and garlic in olive oil until golden.',
          'Add lentils, passata, and herbs; simmer 20 min.',
          'Cook spaghetti; toss with sauce.',
        ],
        prepMinutes: 30,
        diets: [DietType.vegan, DietType.vegetarian],
      ),
      Meal(
        id: 'vegan_d3_snack',
        name: 'Sliced Mango with Chilli Lime',
        type: MealType.snack,
        kcal: 120,
        protein: 1,
        carbs: 29,
        fat: 1,
        // 1*4 + 29*4 + 1*9 = 4+116+9 = 129 (Δ = 9) ✓
        emoji: '🥭',
        description: 'Fresh mango slices dusted with chilli powder and a squeeze of lime.',
        ingredients: [
          '1 medium ripe mango',
          '¼ tsp chilli powder',
          'Juice of ½ lime',
        ],
        steps: [
          'Peel and slice mango.',
          'Dust with chilli powder and drizzle with lime juice.',
        ],
        prepMinutes: 5,
        diets: [DietType.vegan, DietType.vegetarian, DietType.glutenFree, DietType.balanced, DietType.paleo],
      ),
    ]),
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // GLUTEN-FREE  (target ~1 500 kcal/day, no wheat/barley/rye)
  // ─────────────────────────────────────────────────────────────────────────
  static const List<DayMealPlan> glutenFree = [
    // Day 1
    DayMealPlan(day: 1, meals: [
      Meal(
        id: 'gf_d1_breakfast',
        name: 'Rice Porridge with Berries',
        type: MealType.breakfast,
        kcal: 330,
        protein: 8,
        carbs: 60,
        fat: 6,
        // 8*4 + 60*4 + 6*9 = 32+240+54 = 326 (Δ = 4) ✓
        emoji: '🍚',
        description: 'Creamy rice porridge cooked in almond milk and topped with mixed berries.',
        ingredients: [
          '60 g white rice',
          '300 ml almond milk',
          '80 g mixed berries',
          '1 tsp honey',
          '½ tsp vanilla extract',
        ],
        steps: [
          'Simmer rice in almond milk with vanilla, stirring often, 20 min.',
          'Sweeten with honey; top with fresh berries.',
        ],
        prepMinutes: 22,
        diets: [DietType.glutenFree, DietType.vegetarian, DietType.vegan],
      ),
      Meal(
        id: 'gf_d1_lunch',
        name: 'Grilled Chicken Caesar Salad (GF)',
        type: MealType.lunch,
        kcal: 420,
        protein: 38,
        carbs: 14,
        fat: 24,
        // 38*4 + 14*4 + 24*9 = 152+56+216 = 424 (Δ = 4) ✓
        emoji: '🥗',
        description: 'Classic Caesar with grilled chicken, GF croutons, and Parmesan.',
        ingredients: [
          '150 g grilled chicken breast',
          '80 g romaine lettuce',
          '20 g Parmesan shavings',
          '2 tbsp GF Caesar dressing',
          '1 slice GF bread, cubed & toasted',
        ],
        steps: [
          'Grill chicken 6 min per side; slice thinly.',
          'Toss romaine with Caesar dressing.',
          'Top with chicken, Parmesan, and GF croutons.',
        ],
        prepMinutes: 20,
        diets: [DietType.glutenFree, DietType.balanced],
      ),
      Meal(
        id: 'gf_d1_dinner',
        name: 'Baked Cod with Herbed Potato Mash',
        type: MealType.dinner,
        kcal: 510,
        protein: 38,
        carbs: 46,
        fat: 16,
        // 38*4 + 46*4 + 16*9 = 152+184+144 = 480 (Δ = 30)
        emoji: '🐟',
        description: 'Flaky herb-topped cod fillet with creamy potato mash and green beans.',
        ingredients: [
          '180 g cod fillet',
          '200 g floury potatoes',
          '100 g green beans',
          '2 tbsp olive oil',
          'Parsley, lemon & garlic',
        ],
        steps: [
          'Rub cod with olive oil, garlic, and parsley; bake at 200 °C, 18 min.',
          'Boil potatoes; mash with olive oil and season well.',
          'Steam beans 4 min; serve alongside.',
        ],
        prepMinutes: 30,
        diets: [DietType.glutenFree, DietType.balanced, DietType.paleo],
      ),
      Meal(
        id: 'gf_d1_snack',
        name: 'Seed Mix & Dried Apricots',
        type: MealType.snack,
        kcal: 210,
        protein: 6,
        carbs: 22,
        fat: 11,
        // 6*4 + 22*4 + 11*9 = 24+88+99 = 211 (Δ = 1) ✓
        emoji: '🌻',
        description: 'A trail mix of pumpkin seeds, sunflower seeds, and tangy dried apricots.',
        ingredients: [
          '20 g pumpkin seeds',
          '15 g sunflower seeds',
          '30 g dried apricots',
        ],
        steps: [
          'Mix seeds and apricots in a small bag or bowl.',
          'Enjoy as an energising on-the-go snack.',
        ],
        prepMinutes: 2,
        diets: [DietType.glutenFree, DietType.vegan, DietType.vegetarian, DietType.balanced, DietType.paleo],
      ),
    ]),

    // Day 2
    DayMealPlan(day: 2, meals: [
      Meal(
        id: 'gf_d2_breakfast',
        name: 'Sweet Potato Breakfast Hash',
        type: MealType.breakfast,
        kcal: 380,
        protein: 20,
        carbs: 36,
        fat: 17,
        // 20*4 + 36*4 + 17*9 = 80+144+153 = 377 (Δ = 3) ✓
        emoji: '🍠',
        description: 'Golden sweet potato hash with eggs, peppers, and turkey sausage.',
        ingredients: [
          '150 g sweet potato, diced',
          '2 eggs',
          '60 g diced bell pepper',
          '50 g GF turkey sausage',
          '1 tbsp olive oil',
        ],
        steps: [
          'Fry sweet potato in olive oil 8 min until crispy.',
          'Add pepper and crumbled sausage; cook 4 min.',
          'Create wells; crack in eggs; cover and cook 3 min.',
        ],
        prepMinutes: 18,
        diets: [DietType.glutenFree, DietType.balanced, DietType.paleo],
      ),
      Meal(
        id: 'gf_d2_lunch',
        name: 'Mexican Rice Bowl',
        type: MealType.lunch,
        kcal: 470,
        protein: 26,
        carbs: 58,
        fat: 13,
        // 26*4 + 58*4 + 13*9 = 104+232+117 = 453 (Δ = 17)
        emoji: '🍚',
        description: 'Cilantro-lime rice topped with seasoned ground beef, pico, and avocado.',
        ingredients: [
          '90 g cooked long-grain rice',
          '120 g lean ground beef',
          '3 tbsp pico de gallo',
          '¼ avocado, sliced',
          'Lime juice & cumin',
        ],
        steps: [
          'Brown beef with cumin and salt; drain excess fat.',
          'Toss rice with lime juice and chopped cilantro.',
          'Bowl up rice; top with beef, pico, and avocado.',
        ],
        prepMinutes: 20,
        diets: [DietType.glutenFree, DietType.balanced],
      ),
      Meal(
        id: 'gf_d2_dinner',
        name: 'Baked Chicken with Roasted Ratatouille',
        type: MealType.dinner,
        kcal: 490,
        protein: 40,
        carbs: 32,
        fat: 20,
        // 40*4 + 32*4 + 20*9 = 160+128+180 = 468 (Δ = 22)
        emoji: '🍗',
        description: 'Succulent chicken breast baked atop a colourful Provençal vegetable medley.',
        ingredients: [
          '180 g chicken breast',
          '100 g zucchini, sliced',
          '100 g eggplant, cubed',
          '80 g cherry tomatoes',
          '2 tbsp olive oil & herbs de Provence',
        ],
        steps: [
          'Toss vegetables with olive oil and herbs; spread in a baking dish.',
          'Place chicken on top; season; roast at 200 °C for 25 min.',
          'Rest 5 min before serving.',
        ],
        prepMinutes: 30,
        diets: [DietType.glutenFree, DietType.balanced, DietType.paleo],
      ),
      Meal(
        id: 'gf_d2_snack',
        name: 'Corn Tortilla Chips & Guacamole',
        type: MealType.snack,
        kcal: 200,
        protein: 3,
        carbs: 22,
        fat: 12,
        // 3*4 + 22*4 + 12*9 = 12+88+108 = 208 (Δ = 8) ✓
        emoji: '🥑',
        description: 'Crunchy certified-GF corn chips with fresh chunky guacamole.',
        ingredients: [
          '30 g GF corn tortilla chips',
          '4 tbsp guacamole',
        ],
        steps: [
          'Scoop guacamole into a small bowl.',
          'Serve with chips for dipping.',
        ],
        prepMinutes: 3,
        diets: [DietType.glutenFree, DietType.vegan, DietType.vegetarian],
      ),
    ]),

    // Day 3
    DayMealPlan(day: 3, meals: [
      Meal(
        id: 'gf_d3_breakfast',
        name: 'Buckwheat Crêpes with Berries',
        type: MealType.breakfast,
        kcal: 340,
        protein: 12,
        carbs: 48,
        fat: 11,
        // 12*4 + 48*4 + 11*9 = 48+192+99 = 339 (Δ = 1) ✓
        emoji: '🫓',
        description: 'Thin, lacy buckwheat crêpes filled with Greek yogurt and fresh berries.',
        ingredients: [
          '60 g buckwheat flour',
          '1 egg',
          '180 ml milk',
          '100 g Greek yogurt',
          '80 g mixed berries',
        ],
        steps: [
          'Whisk buckwheat flour, egg, and milk into a thin batter.',
          'Cook thin crêpes in a lightly buttered pan.',
          'Fill with Greek yogurt and berries; fold and serve.',
        ],
        prepMinutes: 18,
        diets: [DietType.glutenFree, DietType.vegetarian],
      ),
      Meal(
        id: 'gf_d3_lunch',
        name: 'Shrimp & Avocado Lettuce Cups',
        type: MealType.lunch,
        kcal: 390,
        protein: 30,
        carbs: 18,
        fat: 22,
        // 30*4 + 18*4 + 22*9 = 120+72+198 = 390 ✓
        emoji: '🍤',
        description: 'Chilled poached shrimp, avocado, and mango in crisp iceberg cups.',
        ingredients: [
          '180 g cooked shrimp',
          '½ avocado, diced',
          '60 g fresh mango, diced',
          '4 iceberg lettuce leaves',
          'Lime juice & coriander',
        ],
        steps: [
          'Mix shrimp, avocado, and mango with lime juice.',
          'Spoon into lettuce cups.',
          'Top with fresh coriander and serve chilled.',
        ],
        prepMinutes: 10,
        diets: [DietType.glutenFree, DietType.balanced, DietType.paleo],
      ),
      Meal(
        id: 'gf_d3_dinner',
        name: 'Pork Tenderloin with Polenta',
        type: MealType.dinner,
        kcal: 530,
        protein: 40,
        carbs: 46,
        fat: 18,
        // 40*4 + 46*4 + 18*9 = 160+184+162 = 506 (Δ = 24)
        emoji: '🍖',
        description: 'Herb-marinated pork tenderloin sliced over creamy Parmesan polenta.',
        ingredients: [
          '180 g pork tenderloin',
          '80 g instant polenta',
          '20 g Parmesan, grated',
          '200 ml chicken broth',
          'Rosemary, garlic & olive oil',
        ],
        steps: [
          'Marinate pork with rosemary, garlic, and olive oil 10 min.',
          'Sear and roast at 200 °C for 20 min; rest 5 min.',
          'Cook polenta in broth; stir in Parmesan.',
          'Slice pork; serve over polenta.',
        ],
        prepMinutes: 35,
        diets: [DietType.glutenFree, DietType.balanced],
      ),
      Meal(
        id: 'gf_d3_snack',
        name: 'Yogurt with Honey & Almonds',
        type: MealType.snack,
        kcal: 200,
        protein: 10,
        carbs: 18,
        fat: 9,
        // 10*4 + 18*4 + 9*9 = 40+72+81 = 193 (Δ = 7) ✓
        emoji: '🍯',
        description: 'Thick Greek yogurt drizzled with raw honey and topped with toasted almonds.',
        ingredients: [
          '150 g Greek yogurt',
          '1 tbsp honey',
          '15 g toasted almonds',
        ],
        steps: [
          'Spoon yogurt into a bowl.',
          'Drizzle with honey; scatter almonds on top.',
        ],
        prepMinutes: 3,
        diets: [DietType.glutenFree, DietType.vegetarian, DietType.balanced],
      ),
    ]),
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // PALEO  (target ~1 600 kcal/day, 30 % P / 35 % C / 35 % F; no grains/dairy/legumes)
  // ─────────────────────────────────────────────────────────────────────────
  static const List<DayMealPlan> paleo = [
    // Day 1
    DayMealPlan(day: 1, meals: [
      Meal(
        id: 'paleo_d1_breakfast',
        name: 'Egg & Veggie Muffins',
        type: MealType.breakfast,
        kcal: 360,
        protein: 26,
        carbs: 10,
        fat: 24,
        // 26*4 + 10*4 + 24*9 = 104+40+216 = 360 ✓
        emoji: '🥚',
        description: 'Baked egg muffins packed with spinach, mushrooms, and sun-dried tomatoes.',
        ingredients: [
          '4 large eggs',
          '40 g baby spinach',
          '60 g mushrooms, sliced',
          '30 g sun-dried tomatoes',
          '1 tbsp olive oil',
        ],
        steps: [
          'Preheat oven to 180 °C; grease a muffin tin.',
          'Sauté spinach and mushrooms in olive oil 2 min.',
          'Whisk eggs; fold in vegetables and tomatoes; pour into tins.',
          'Bake 18 min until just set.',
        ],
        prepMinutes: 25,
        diets: [DietType.paleo, DietType.glutenFree, DietType.keto],
      ),
      Meal(
        id: 'paleo_d1_lunch',
        name: 'Turkey Lettuce Wraps with Mango Salsa',
        type: MealType.lunch,
        kcal: 430,
        protein: 36,
        carbs: 28,
        fat: 18,
        // 36*4 + 28*4 + 18*9 = 144+112+162 = 418 (Δ = 12)
        emoji: '🌮',
        description: 'Ground turkey spiced with cumin and lime, wrapped in crisp romaine with mango salsa.',
        ingredients: [
          '180 g lean ground turkey',
          '4 romaine lettuce leaves',
          '80 g fresh mango salsa',
          '1 tsp cumin',
          'Lime & coriander',
        ],
        steps: [
          'Brown turkey with cumin, salt, and lime juice; drain.',
          'Spoon into lettuce leaves.',
          'Top with mango salsa and fresh coriander.',
        ],
        prepMinutes: 15,
        diets: [DietType.paleo, DietType.glutenFree, DietType.balanced],
      ),
      Meal(
        id: 'paleo_d1_dinner',
        name: 'Grilled Lamb Chops with Root Veg',
        type: MealType.dinner,
        kcal: 570,
        protein: 42,
        carbs: 30,
        fat: 30,
        // 42*4 + 30*4 + 30*9 = 168+120+270 = 558 (Δ = 12)
        emoji: '🍖',
        description: 'Rosemary-marinated lamb chops with roasted parsnip and carrot.',
        ingredients: [
          '200 g lamb chops (2 cutlets)',
          '100 g parsnip, chunked',
          '100 g carrot, chunked',
          '2 tbsp olive oil',
          'Rosemary, garlic & thyme',
        ],
        steps: [
          'Marinate lamb with rosemary, garlic, and olive oil 15 min.',
          'Toss root veg in oil; roast at 200 °C for 30 min.',
          'Grill lamb 4 min per side; rest 3 min before serving.',
        ],
        prepMinutes: 35,
        diets: [DietType.paleo, DietType.glutenFree],
      ),
      Meal(
        id: 'paleo_d1_snack',
        name: 'Beef Jerky & Orange Segments',
        type: MealType.snack,
        kcal: 190,
        protein: 16,
        carbs: 18,
        fat: 5,
        // 16*4 + 18*4 + 5*9 = 64+72+45 = 181 (Δ = 9) ✓
        emoji: '🍊',
        description: 'Sugar-free beef jerky paired with sweet, juicy orange segments.',
        ingredients: [
          '30 g GF beef jerky',
          '1 medium orange, segmented',
        ],
        steps: [
          'Peel and segment orange.',
          'Serve alongside jerky as a balanced paleo snack.',
        ],
        prepMinutes: 3,
        diets: [DietType.paleo, DietType.glutenFree, DietType.balanced],
      ),
    ]),

    // Day 2
    DayMealPlan(day: 2, meals: [
      Meal(
        id: 'paleo_d2_breakfast',
        name: 'Sweet Potato & Chorizo Hash',
        type: MealType.breakfast,
        kcal: 420,
        protein: 22,
        carbs: 34,
        fat: 22,
        // 22*4 + 34*4 + 22*9 = 88+136+198 = 422 (Δ = 2) ✓
        emoji: '🍠',
        description: 'Hearty sweet potato hash with paleo chorizo and fried eggs.',
        ingredients: [
          '150 g sweet potato, diced',
          '60 g paleo chorizo, sliced',
          '2 eggs',
          '1 tbsp coconut oil',
          'Smoked paprika & oregano',
        ],
        steps: [
          'Fry sweet potato in coconut oil 8 min; add chorizo.',
          'Cook 4 min until chorizo browns; push aside.',
          'Fry eggs in the pan to desired doneness; serve together.',
        ],
        prepMinutes: 18,
        diets: [DietType.paleo, DietType.glutenFree],
      ),
      Meal(
        id: 'paleo_d2_lunch',
        name: 'Tuna-Stuffed Avocado',
        type: MealType.lunch,
        kcal: 440,
        protein: 30,
        carbs: 14,
        fat: 30,
        // 30*4 + 14*4 + 30*9 = 120+56+270 = 446 (Δ = 6) ✓
        emoji: '🥑',
        description: 'Halved avocado filled with wild-caught tuna, celery, and lemon aioli.',
        ingredients: [
          '1 large avocado',
          '120 g canned tuna in water',
          '1 celery stalk, finely diced',
          '2 tbsp paleo mayo',
          'Lemon juice & dill',
        ],
        steps: [
          'Halve and pit avocado.',
          'Mix tuna with celery, mayo, lemon, and dill.',
          'Spoon tuna salad into avocado halves and serve.',
        ],
        prepMinutes: 8,
        diets: [DietType.paleo, DietType.glutenFree, DietType.keto],
      ),
      Meal(
        id: 'paleo_d2_dinner',
        name: 'Zucchini Noodle Bolognese',
        type: MealType.dinner,
        kcal: 510,
        protein: 38,
        carbs: 24,
        fat: 28,
        // 38*4 + 24*4 + 28*9 = 152+96+252 = 500 (Δ = 10) ✓
        emoji: '🥩',
        description: 'Rich slow-cooked beef ragu over spiralised zucchini noodles.',
        ingredients: [
          '180 g lean ground beef',
          '200 g zucchini noodles',
          '150 g crushed tomatoes',
          '1 onion, finely diced',
          'Garlic, bay leaf & oregano',
        ],
        steps: [
          'Brown beef with onion and garlic.',
          'Add crushed tomatoes, bay leaf, and oregano; simmer 25 min.',
          'Toss zucchini noodles in pan 2 min; top with ragu.',
        ],
        prepMinutes: 35,
        diets: [DietType.paleo, DietType.glutenFree, DietType.keto],
      ),
      Meal(
        id: 'paleo_d2_snack',
        name: 'Coconut Almond Energy Balls',
        type: MealType.snack,
        kcal: 200,
        protein: 5,
        carbs: 14,
        fat: 14,
        // 5*4 + 14*4 + 14*9 = 20+56+126 = 202 (Δ = 2) ✓
        emoji: '🥥',
        description: 'Coconut and almond no-bake balls sweetened only with dates.',
        ingredients: [
          '30 g almond butter',
          '20 g desiccated coconut',
          '2 Medjool dates, pitted',
          '15 g flaxseed meal',
        ],
        steps: [
          'Blend all ingredients in a food processor until it forms a dough.',
          'Roll into 4 balls; refrigerate 15 min.',
        ],
        prepMinutes: 10,
        diets: [DietType.paleo, DietType.vegan, DietType.vegetarian, DietType.glutenFree],
      ),
    ]),

    // Day 3
    DayMealPlan(day: 3, meals: [
      Meal(
        id: 'paleo_d3_breakfast',
        name: 'Primal Smoothie Bowl',
        type: MealType.breakfast,
        kcal: 370,
        protein: 18,
        carbs: 38,
        fat: 16,
        // 18*4 + 38*4 + 16*9 = 72+152+144 = 368 (Δ = 2) ✓
        emoji: '🫐',
        description: 'Thick berry smoothie bowl topped with walnuts, coconut flakes, and banana.',
        ingredients: [
          '150 g frozen mixed berries',
          '2 tbsp almond butter',
          '100 ml coconut milk (full fat)',
          '20 g walnuts',
          '1 tbsp coconut flakes',
        ],
        steps: [
          'Blend berries, almond butter, and coconut milk until thick.',
          'Pour into a bowl.',
          'Top with walnuts and coconut flakes; serve immediately.',
        ],
        prepMinutes: 7,
        diets: [DietType.paleo, DietType.vegan, DietType.vegetarian, DietType.glutenFree],
      ),
      Meal(
        id: 'paleo_d3_lunch',
        name: 'Smoked Mackerel & Beet Salad',
        type: MealType.lunch,
        kcal: 430,
        protein: 28,
        carbs: 24,
        fat: 24,
        // 28*4 + 24*4 + 24*9 = 112+96+216 = 424 (Δ = 6) ✓
        emoji: '🐟',
        description: 'Flaky smoked mackerel over roasted beet and watercress with horseradish dressing.',
        ingredients: [
          '120 g smoked mackerel',
          '150 g roasted beetroot, sliced',
          '40 g watercress',
          '1 tbsp olive oil',
          '1 tsp grated horseradish',
        ],
        steps: [
          'Arrange watercress and beetroot on a plate.',
          'Flake mackerel on top.',
          'Whisk olive oil with horseradish and lemon; drizzle over.',
        ],
        prepMinutes: 10,
        diets: [DietType.paleo, DietType.glutenFree],
      ),
      Meal(
        id: 'paleo_d3_dinner',
        name: 'Chicken Thighs with Cauliflower Mash',
        type: MealType.dinner,
        kcal: 530,
        protein: 40,
        carbs: 18,
        fat: 32,
        // 40*4 + 18*4 + 32*9 = 160+72+288 = 520 (Δ = 10) ✓
        emoji: '🍗',
        description: 'Crispy-skinned chicken thighs over velvety cauliflower mash with braised greens.',
        ingredients: [
          '200 g chicken thighs, bone-in',
          '200 g cauliflower florets',
          '80 g kale, de-stemmed',
          '2 tbsp ghee',
          'Garlic, lemon & thyme',
        ],
        steps: [
          'Season thighs; sear skin-down in ghee 6 min; flip and roast at 200 °C 20 min.',
          'Steam cauliflower; blend with ghee and garlic until silky.',
          'Sauté kale with lemon juice 3 min; plate everything together.',
        ],
        prepMinutes: 35,
        diets: [DietType.paleo, DietType.glutenFree, DietType.keto],
      ),
      Meal(
        id: 'paleo_d3_snack',
        name: 'Guacamole & Cucumber Rounds',
        type: MealType.snack,
        kcal: 170,
        protein: 3,
        carbs: 10,
        fat: 14,
        // 3*4 + 10*4 + 14*9 = 12+40+126 = 178 (Δ = 8) ✓
        emoji: '🥒',
        description: 'Fresh guacamole piled onto thick cucumber slices for a cool, creamy crunch.',
        ingredients: [
          '1 medium cucumber, sliced',
          '4 tbsp guacamole',
          'Lime juice & chilli flakes',
        ],
        steps: [
          'Slice cucumber into rounds about 1 cm thick.',
          'Top each slice with guacamole; dust with chilli flakes.',
        ],
        prepMinutes: 5,
        diets: [DietType.paleo, DietType.vegan, DietType.vegetarian, DietType.glutenFree, DietType.keto],
      ),
    ]),
  ];
}
