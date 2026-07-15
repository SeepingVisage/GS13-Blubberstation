#define MINIMUM_FATNESS_LEVEL 0

// using numbers here is probably a bad idea but I wanna experiment
#define FATTENING_TYPE_ITEM 1
#define FATTENING_TYPE_FOOD 2
#define FATTENING_TYPE_CHEM 3
#define FATTENING_TYPE_WEAPON 4
#define FATTENING_TYPE_MAGIC 5
#define FATTENING_TYPE_VIRUS 6
#define FATTENING_TYPE_NANITES 7
#define FATTENING_TYPE_ATMOS 8
#define FATTENING_TYPE_RADIATIONS 9
#define FATTENING_TYPE_MOBS 10
#define FATTENING_TYPE_WEIGHT_LOSS 11
/// This ignores prefs, please only use this for smites and other admin controlled instances.
#define FATTENING_TYPE_ALMIGHTY 2137	// papaja is inevitable

#define FATNESS_TO_WEIGHT_RATIO 0.25
#define MUSCLE_TO_WEIGHT_RATIO 0.5 // Muscle is heavier than fat.
#define POUNDS_TO_KG_RAITO 0.454 // This isn't exact, but we don't want super long numbers.

#define MUSCLE_TO_FATNESS_RATIO 2
#define MUSCLE_TO_FATNESS_RATIO_VORE 5

#define FATNESS_FROM_VORE 0.8
#define BASE_WEIGHT_VALUE 140

#define VORE_TRANSFER_PERMAFAT 0.2
#define VORE_TRANSFER_CALORITE_POISONING 0.1

#define ABSORB_TICKS_PER_STAGE_SMALL 8
#define ABSORB_TICKS_PER_STAGE_MEDIUM 16
#define ABSORB_TICKS_PER_STAGE_LARGE 32
#define ABSORB_TICKS_PER_STAGE_EXCESS 64
#define ABSORB_TICKS_PER_STAGE_EXTREME 124

#define ABSORB_WEIGHT_AMOUNT_SMALL 175
#define ABSORB_WEIGHT_AMOUNT_MEDIUM 600
#define ABSORB_WEIGHT_AMOUNT_LARGE 1200
#define ABSORB_WEIGHT_AMOUNT_EXCESS 2300


/// for interaction datums, defines an interaction which can ONLY be performed on ourselves
#define INTERACTION_ONLY_SELF "only_self"
