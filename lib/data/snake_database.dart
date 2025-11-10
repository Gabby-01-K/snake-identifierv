// lib/data/snake_database.dart

import '../models/snake_info.dart';

// FIRST AID TEXT
// Generic first aid for any venomous snake.
const String venomousFirstAid = """
1. CALL EMERGENCY SERVICES (112 OR LOCAL EQUIVALENT) IMMEDIATELY.
2. Stay calm and move away from the snake.
3. Keep the bite area still and position it below the level of the heart.
4. Remove any tight clothing or jewelry near the bite, as the area may swell.
5. Wash the wound gently with soap and water.
6. Do NOT apply a tourniquet.
7. Do NOT cut the wound or attempt to suck out the venom.
8. Do NOT apply ice or heat.
9. Await emergency services.
""";

// First aid for non-venomous bites.
const String nonVenomousFirstAid = """
1. Wash the wound thoroughly with soap and water.
2. Apply an antiseptic ointment and a clean bandage.
3. Watch for signs of infection (redness, swelling, pain).
4. Tetanus shot may be recommended if you are not up to date.
""";

// SNAKE DATABASE
// This is the map that links the model's output name to the new info.

final Map<String, SnakeInfo> snakeDatabase = {
  'agkistrodon-contortrix': SnakeInfo(
    breedName: 'agkistrodon-contortrix', // Copperhead
    isVenomous: true,
    details: 'Venomous. Found in Eastern North America. Bites are painful but rarely fatal to healthy adults.',
    firstAid: venomousFirstAid,
    // wikiPage: https://en.wikipedia.org/wiki/Eastern_copperhead,
  ),

  'agkistrodon-piscivorus': SnakeInfo(
    breedName: 'agkistrodon-piscivorus', // Cottonmouth / Water Moccasin
    isVenomous: true, // venomous pit viper
    details: 'Venomous. Semi-aquatic pit viper (cottonmouth). Can deliver painful and potentially serious bites.',
    firstAid: venomousFirstAid, // treat as venomous bite
  ),

  'coluber-constrictor': SnakeInfo(
    breedName: 'coluber-constrictor', // Eastern Racer
    isVenomous: false,
    details: 'Non-Venomous. Fast, active racer; harmless to humans.',
    firstAid: nonVenomousFirstAid,
  ),

  'crotalus-atrox': SnakeInfo(
    breedName: 'crotalus-atrox', // Western Diamondback Rattlesnake
    isVenomous: true,
    details: 'Highly Venomous. Found in the Southwestern US and Mexico. This is a dangerous snake.',
    firstAid: venomousFirstAid,
  ),

  'crotalus-horridus': SnakeInfo(
    breedName: 'crotalus-horridus', // Timber Rattlesnake
    isVenomous: true,
    details: 'Highly Venomous. Found in the Eastern US. Medical attention is required immediately.',
    firstAid: venomousFirstAid,
  ),

  'crotalus-ruber': SnakeInfo(
    breedName: 'crotalus-ruber', // Red Diamond Rattlesnake
    isVenomous: true,
    details: 'Highly Venomous. Red diamond rattlesnake found in southern California and Baja California.',
    firstAid: venomousFirstAid,
  ),

  'crotalus-scutulatus': SnakeInfo(
    breedName: 'crotalus-scutulatus', // Mojave / Mohave Rattlesnake
    isVenomous: true,
    details: 'Highly Venomous. Mojave rattlesnake with potent neurotoxic-hemotoxic venom.',
    firstAid: venomousFirstAid,
  ),

  'crotalus-viridis': SnakeInfo(
    breedName: 'crotalus-viridis', // Prairie Rattlesnake
    isVenomous: true,
    details: 'Venomous. Prairie rattlesnake; venomous and should be treated as dangerous.',
    firstAid: venomousFirstAid,
  ),

  'diadophis-punctatus': SnakeInfo(
    breedName: 'diadophis-punctatus', // Ring-necked Snake
    isVenomous: false, // mild venom for prey; not dangerous to humans
    details: 'Non-Venomous to humans. Small ring-necked snake with mild venom used on prey; fangs too small to harm people.',
    firstAid: nonVenomousFirstAid,
  ),

  'haldea-striatula': SnakeInfo(
    breedName: 'haldea-striatula', // Rough Earth Snake
    isVenomous: false,
    details: 'Non-Venomous. Small, fossorial rough earth snake; harmless to people.',
    firstAid: nonVenomousFirstAid,
  ),

  'heterodon-platirhinos': SnakeInfo(
    breedName: 'heterodon-platirhinos', // Eastern Hognose Snake
    isVenomous: false, // mildly venomous to amphibians; not dangerous to humans
    details: 'Mildly venomous to amphibian prey but not considered dangerous to humans; famous for dramatic defensive displays.',
    firstAid: nonVenomousFirstAid,
  ),

  'lampropeltis-californiae': SnakeInfo(
    breedName: 'lampropeltis-californiae', // California Kingsnake
    isVenomous: false,
    details: 'Non-Venomous. Constrictor; commonly kept as a pet and beneficial for rodent control.',
    firstAid: nonVenomousFirstAid,
  ),

  'lampropeltis-triangulum': SnakeInfo(
    breedName: 'lampropeltis-triangulum', // Milk Snake
    isVenomous: false,
    details: 'Non-Venomous. Harmless to humans. Often confused with the venomous Coral Snake (Red on Yellow, Kill a Fellow; Red on Black, Friend of Jack).',
    firstAid: nonVenomousFirstAid,
  ),

  'masticophis-flagellum': SnakeInfo(
    breedName: 'masticophis-flagellum', // Coachwhip
    isVenomous: false,
    details: 'Non-Venomous. Fast, slender coachwhip; not dangerous to people.',
    firstAid: nonVenomousFirstAid,
  ),

  'natrix-natrix': SnakeInfo(
    breedName: 'natrix-natrix', // Grass Snake (Eurasian)
    isVenomous: false,
    details: 'Non-Venomous. Eurasian grass/water snake; harmless to humans.',
    firstAid: nonVenomousFirstAid,
  ),

  'nerodia-erythrogaster': SnakeInfo(
    breedName: 'nerodia-erythrogaster', // Plain-bellied Water Snake
    isVenomous: false,
    details: 'Non-Venomous. Semi-aquatic water snake; often mistaken for venomous species.',
    firstAid: nonVenomousFirstAid,
  ),

  'nerodia-fasciata': SnakeInfo(
    breedName: 'nerodia-fasciata', // Banded Water Snake
    isVenomous: false,
    details: 'Non-Venomous. Banded water snake; defensive but not venomous.',
    firstAid: nonVenomousFirstAid,
  ),

  'nerodia-rhombifer': SnakeInfo(
    breedName: 'nerodia-rhombifer', // Diamondback Water Snake
    isVenomous: false,
    details: 'Non-Venomous. Diamondback water snake; harmless to humans.',
    firstAid: nonVenomousFirstAid,
  ),

  'nerodia-sipedon': SnakeInfo(
    breedName: 'nerodia-sipedon', // Northern / Common Watersnake
    isVenomous: false,
    details: 'Non-Venomous. Frequently mistaken for cottonmouths; will bite but not venomous.',
    firstAid: nonVenomousFirstAid,
  ),

  'opheodrys-aestivus': SnakeInfo(
    breedName: 'opheodrys-aestivus', // Rough Green Snake
    isVenomous: false,
    details: 'Non-Venomous. Docile, arboreal rough green snake; harmless to people.',
    firstAid: nonVenomousFirstAid,
  ),

  'pantherophis-alleghaniensis': SnakeInfo(
    breedName: 'pantherophis-alleghaniensis', // Eastern Rat Snake
    isVenomous: false,
    details: 'Non-Venomous. Powerful constrictor; beneficial for rodent control.',
    firstAid: nonVenomousFirstAid,
  ),

  'pantherophis-emoryi': SnakeInfo(
    breedName: 'pantherophis-emoryi', // Great Plains Rat Snake
    isVenomous: false,
    details: 'Non-Venomous. Great Plains rat snake; constrictor and harmless to humans.',
    firstAid: nonVenomousFirstAid,
  ),

  'pantherophis-guttatus': SnakeInfo(
    breedName: 'pantherophis-guttatus', // Corn Snake
    isVenomous: false,
    details: 'Non-Venomous. Corn snake; common pet and non-dangerous.',
    firstAid: nonVenomousFirstAid,
  ),

  'pantherophis-obsoletus': SnakeInfo(
    breedName: 'pantherophis-obsoletus', // Black Rat Snake
    isVenomous: false,
    details: 'Non-Venomous. A powerful constrictor. Very beneficial for controlling rodent populations.',
    firstAid: nonVenomousFirstAid,
  ),

  'pantherophis-spiloides': SnakeInfo(
    breedName: 'pantherophis-spiloides', // (note: comment previously said Ring-necked Snake)
    isVenomous: false, // kept as non-venomous in app; existing comment retained
    details: 'Non-Venomous (to humans). Existing app text retained.',
    firstAid: nonVenomousFirstAid,
  ),

  'pantherophis-vulpinus': SnakeInfo(
    breedName: 'pantherophis-vulpinus', // Fox Snake
    isVenomous: false,
    details: 'Non-Venomous. Fox snake; beneficial predator of rodents.',
    firstAid: nonVenomousFirstAid,
  ),

  'pituophis-catenifer': SnakeInfo(
    breedName: 'pituophis-catenifer', // Gopher Snake
    isVenomous: false,
    details: 'Non-Venomous. Gopher snake; often mistaken for rattlesnakes but harmless.',
    firstAid: nonVenomousFirstAid,
  ),

  'rhinocheilus-lecontei': SnakeInfo(
    breedName: 'rhinocheilus-lecontei', // Long-nosed Snake
    isVenomous: false,
    details: 'Non-Venomous. Long-nosed snake; harmless to humans.',
    firstAid: nonVenomousFirstAid,
  ),

  'storeria-dekayi': SnakeInfo(
    breedName: 'storeria-dekayi', // DeKay's Brown Snake
    isVenomous: false,
    details: 'Non-Venomous. Small, harmless brown snake commonly found in gardens.',
    firstAid: nonVenomousFirstAid,
  ),

  'storeria-occipitomaculata': SnakeInfo(
    breedName: 'storeria-occipitomaculata', // Redbelly Snake
    isVenomous: false,
    details: 'Non-Venomous. Small red-bellied snake; harmless to people.',
    firstAid: nonVenomousFirstAid,
  ),

  'thamnophis-elegans': SnakeInfo(
    breedName: 'thamnophis-elegans', // Western Terrestrial Garter Snake
    isVenomous: false, // mildly venomous to prey; not dangerous to humans
    details: 'Mildly venomous to prey but not harmful to humans; garter snake species.',
    firstAid: nonVenomousFirstAid,
  ),

  'thamnophis-marcianus': SnakeInfo(
    breedName: 'thamnophis-marcianus', // Checkered Garter Snake
    isVenomous: false, // mild venom for prey; not medically significant
    details: 'Mildly venomous to prey; not considered dangerous to people.',
    firstAid: nonVenomousFirstAid,
  ),

  'thamnophis-proximus': SnakeInfo(
    breedName: 'thamnophis-proximus', // Western Ribbon Snake
    isVenomous: false,
    details: 'Non-Venomous to humans. Ribbon/garter snake with mild venom for prey only.',
    firstAid: nonVenomousFirstAid,
  ),

  'thamnophis-radix': SnakeInfo(
    breedName: 'thamnophis-radix', // Plains Garter Snake
    isVenomous: false, // mild venom not toxic to humans
    details: 'Mildly venomous to prey; venom not toxic to humans. Plains garter snake.',
    firstAid: nonVenomousFirstAid,
  ),
};