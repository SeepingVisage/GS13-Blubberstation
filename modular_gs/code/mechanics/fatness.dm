/**
* Adjusts the fatness level of the parent mob.
*
* * adjustment_amount - adjusts how much weight is gained or loss. Positive numbers add weight.
* * type_of_fattening - what type of fattening is being used. Look at the traits in fatness.dm for valid options.
* * ignore_rate - do we want to ignore the mob's weight gain/loss rate? This is only here for niche uses.
*
* * returns the amount of BFI applied onto target
*/
/mob/living/carbon/proc/adjust_fatness(adjustment_amount, type_of_fattening = FATTENING_TYPE_ITEM, ignore_rate = FALSE)
	if(!adjustment_amount || !type_of_fattening)
		return FALSE

	if(!HAS_TRAIT(src, TRAIT_UNIVERSAL_GAINER) && client?.prefs)
		if(!check_weight_prefs(type_of_fattening))
			return FALSE

	var/amount_to_change = adjustment_amount

	var/gain_rate = get_weight_gain_rate()
	var/lose_rate = get_weight_loss_rate()

	if(!ignore_rate)
		if(adjustment_amount > 0)
			amount_to_change = amount_to_change * gain_rate
		else
			amount_to_change = amount_to_change * lose_rate

	if(fatness_real + amount_to_change < 0)
		amount_to_change = -fatness_real

	fatness_real += amount_to_change
	fatness_real = max(fatness_real, 0) //It would be a little silly if someone got negative fat. This is now redundant, but I'll leave this here for safety sake

	if(max_weight && !HAS_TRAIT(src, TRAIT_UNIVERSAL_GAINER))
		fatness_real = min(fatness_real, (max_weight - 1))

	calculate_fatness()

	return amount_to_change

/mob/living/carbon/proc/adjust_perma(adjustment_amount, type_of_fattening = FATTENING_TYPE_ITEM, ignore_rate = FALSE)
	if(isnull(client))
		return FALSE
	if(type_of_fattening != FATTENING_TYPE_ALMIGHTY && !client.prefs.read_preference(/datum/preference/toggle/weight_gain_permanent))
		return FALSE

	if(!adjustment_amount || !type_of_fattening)
		return FALSE

	if(!HAS_TRAIT(src, TRAIT_UNIVERSAL_GAINER) && client?.prefs)
		if(!check_weight_prefs(type_of_fattening))
			return FALSE

	var/amount_to_change = adjustment_amount

	var/gain_rate = get_weight_gain_rate()
	var/lose_rate = get_weight_loss_rate()

	if(!ignore_rate)
		if(adjustment_amount > 0)
			amount_to_change = amount_to_change * gain_rate
		else
			amount_to_change = amount_to_change * lose_rate

	if(fatness_perma + amount_to_change < 0)
		amount_to_change = -fatness_perma

	fatness_perma += amount_to_change
	fatness_perma = max(fatness_perma, 0)

	if(max_weight && !HAS_TRAIT(src, TRAIT_UNIVERSAL_GAINER))
		fatness_perma = min(fatness_perma, (max_weight - 1))

	return amount_to_change

/// Remove all of the real fatness from a mob.
/mob/living/carbon/proc/fully_heal_fatness(remove_perma = FALSE, custom_remove_text, custom_perma_remove_text)
	var/regular_remove_text = "You feel much lighter."
	var/perma_remove_text = "The weight that you've held onto for so long, just vanishes away."

	if(custom_remove_text)
		regular_remove_text = custom_remove_text
	if(custom_perma_remove_text)
		perma_remove_text = perma_remove_text

	fatness = 0
	fatness_real = 0

	if(regular_remove_text)
		to_chat(src, span_boldnicegreen(regular_remove_text))

	if(remove_perma)
		fatness_perma = 0
		if(perma_remove_text)
			to_chat(src, span_boldnicegreen(perma_remove_text))

/// Virtual sin forgiveness
/mob/living/carbon/proc/fully_heal_fatness_shitpost(remove_perma = FALSE)
	var/regular_text = "I absolve you of your sins, you have been forgvien"
	var/perma_text = ""

	if(remove_perma)
		perma_text = regular_text
		regular_text = ""

	fully_heal_fatness(remove_perma, regular_text, perma_text)

/// Checks the parent mob's prefs to see if they can be fattened by the fattening_type
/mob/living/carbon/proc/check_weight_prefs(type_of_fattening = FATTENING_TYPE_ITEM)
	if(HAS_TRAIT(src, TRAIT_UNIVERSAL_GAINER))
		return TRUE

	if(!client?.prefs || !type_of_fattening)
		return FALSE

	switch(type_of_fattening)
		if(FATTENING_TYPE_ITEM)
			if(!client?.prefs?.read_preference(/datum/preference/toggle/weight_gain_items))
				return FALSE

		if(FATTENING_TYPE_FOOD)
			if(!client?.prefs?.read_preference(/datum/preference/toggle/weight_gain_food))
				return FALSE

		if(FATTENING_TYPE_CHEM)
			if(!client?.prefs?.read_preference(/datum/preference/toggle/weight_gain_chems))
				return FALSE

		if(FATTENING_TYPE_WEAPON)
			if(!client?.prefs?.read_preference(/datum/preference/toggle/weight_gain_weapons))
				return FALSE

		if(FATTENING_TYPE_MAGIC)
			if(!client?.prefs?.read_preference(/datum/preference/toggle/weight_gain_magic))
				return FALSE

		if(FATTENING_TYPE_VIRUS)
			if(!client?.prefs?.read_preference(/datum/preference/toggle/weight_gain_viruses))
				return FALSE

		if(FATTENING_TYPE_NANITES)
			if(!client?.prefs?.read_preference(/datum/preference/toggle/weight_gain_nanites))
				return FALSE

		if(FATTENING_TYPE_ATMOS)
			if(!client?.prefs?.read_preference(/datum/preference/toggle/weight_gain_atmos))
				return FALSE

		if(FATTENING_TYPE_MOBS)
			if(!client?.prefs?.read_preference(/datum/preference/toggle/weight_gain_mobs))
				return FALSE

		if(FATTENING_TYPE_WEIGHT_LOSS)
			if(HAS_TRAIT(src, TRAIT_WEIGHT_LOSS_IMMUNE))
				return FALSE

	return TRUE

/mob/living/carbon/proc/perma_apply()
	fatness = fatness + fatness_perma	// we're adding it to fatness rather than fatness_real because here we SHOULD be after the hiders were applied
	if(max_weight && !HAS_TRAIT(src, TRAIT_UNIVERSAL_GAINER))
		fatness = min(fatness, (max_weight - 1))

/// Handles calculating our resulting `fatness` from our `fatness_real`, `fatness_perma` as well as any hiders we may have
/mob/living/carbon/human/proc/calculate_fatness()
	fatness = fatness_real
	hiders_apply()
	perma_apply()
	xwg_resize()

/proc/get_fatness_level_name(fatness_amount)
	if(fatness_amount < FATNESS_LEVEL_FAT)
		return "Normal"
	if(fatness_amount < FATNESS_LEVEL_FATTER)
		return "Fat"
	if(fatness_amount < FATNESS_LEVEL_VERYFAT)
		return "Fatter"
	if(fatness_amount < FATNESS_LEVEL_OBESE)
		return "Very Fat"
	if(fatness_amount < FATNESS_LEVEL_MORBIDLY_OBESE)
		return "Obese"
	if(fatness_amount < FATNESS_LEVEL_EXTREMELY_OBESE)
		return "Very Obese"
	if(fatness_amount < FATNESS_LEVEL_BARELYMOBILE)
		return "Extremely Obese"
	if(fatness_amount < FATNESS_LEVEL_IMMOBILE)
		return "Barely Mobile"
	if(fatness_amount < FATNESS_LEVEL_BLOB)
		return "Immobile"

	return "Blob"

/// Finds what the next fatness level for the parent mob would be based off of fatness_real.
/mob/living/carbon/proc/get_next_fatness_level()
	if(fatness_real < FATNESS_LEVEL_FAT)
		return FATNESS_LEVEL_FAT
	if(fatness_real < FATNESS_LEVEL_FATTER)
		return FATNESS_LEVEL_FATTER
	if(fatness_real < FATNESS_LEVEL_VERYFAT)
		return FATNESS_LEVEL_VERYFAT
	if(fatness_real < FATNESS_LEVEL_OBESE)
		return FATNESS_LEVEL_OBESE
	if(fatness_real < FATNESS_LEVEL_MORBIDLY_OBESE)
		return FATNESS_LEVEL_MORBIDLY_OBESE
	if(fatness_real < FATNESS_LEVEL_EXTREMELY_OBESE)
		return FATNESS_LEVEL_EXTREMELY_OBESE
	if(fatness_real < FATNESS_LEVEL_BARELYMOBILE)
		return FATNESS_LEVEL_BARELYMOBILE
	if(fatness_real < FATNESS_LEVEL_IMMOBILE)
		return FATNESS_LEVEL_IMMOBILE
	if(fatness_real < FATNESS_LEVEL_BLOB)
		return FATNESS_LEVEL_BLOB

	return FATNESS_LEVEL_BLOB

/// How much real fatness does the current mob have to gain until they reach the next level? Return FALSE if they are maxed out.
/mob/living/carbon/proc/fatness_until_next_level()
	var/needed_fatness = get_next_fatness_level() - fatness_real
	needed_fatness = max(needed_fatness, 0)

	return needed_fatness

/mob/living/carbon/proc/applyFatnessDamage(amount)
	if(!client?.prefs?.read_preference(/datum/preference/toggle/weight_gain_weapons)) // If we can't fatten them through weapons, apply stamina damage
		adjust_stamina_loss(amount)
		return TRUE

	var/fat_to_add = ((amount * CONFIG_GET(number/damage_multiplier)) * FAT_DAMAGE_TO_FATNESS)
	adjust_fatness(fat_to_add, FATTENING_TYPE_WEAPON)
	return fat_to_add

/mob/living/carbon/proc/applyPermaFatnessDamage(amount)
	if (isnull(client))
		return

	if (!client.prefs.read_preference(/datum/preference/toggle/weight_gain_permanent)) // If we cant apply permafat, apply regular fat
		return applyFatnessDamage(amount)

	var/fat_to_add = ((amount * CONFIG_GET(number/damage_multiplier)) * PERMA_FAT_DAMAGE_TO_FATNESS)
	adjust_perma(fat_to_add, FATTENING_TYPE_WEAPON)
	return fat_to_add

/mob/living/carbon/apply_damage(
	damage = 0,
	damagetype = BRUTE,
	def_zone = null,
	blocked = 0,
	forced = FALSE,
	spread_damage = FALSE,
	wound_bonus = 0,
	exposed_wound_bonus = 0,
	sharpness = NONE,
	attack_direction = null,
	attacking_item,
	wound_clothing = TRUE,
)
	if (damagetype == FAT)
		applyFatnessDamage(damage)
	if (damagetype == PERMA_FAT)
		applyPermaFatnessDamage(damage)

	. = ..()
