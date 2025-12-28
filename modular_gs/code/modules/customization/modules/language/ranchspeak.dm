/datum/language/ranchspeak
	name = "Ranch Speak"
	desc = "A pidgin commonly spoken by ranchers and livestock out in the open plains of\
	common space that helps them communicate."
	key = "R"
	flags = TONGUELESS_SPEECH
	space_chance = 50
	additional_syllable_low = 0
	additional_syllable_high = 0
	// Animal sounds and southern slang!
	syllables = list (
		list(
			"moo", "low", "bok", "woof", "bark", "gawk", "grr", "growl", "neigh", "bleat",
			"cackle", "huff", "cock", "a", "doodle", "doo", "baa", "oink", "squeal",
			"snort", "grumble", "hiss", "mew", "nya",
		),
		list(
			"y'all", "dang", "south", "cream", "gravy", "dairy", "biscuit",
			"yee", "haw", "yodel", "soo", "wee", "bacon", "hanker", "fixin'", "blaze", "tea",
		)
	)
	icon_state = "animal"
	default_priority = 60
	default_name_syllable_min = 1
	default_name_syllable_max = 2
