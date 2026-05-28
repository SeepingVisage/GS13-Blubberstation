/mob/living/proc/adjust_burpslurring_effect(amount, down_to = 0, up_to = INFINITY)
	if(!isnum(amount))
		CRASH("adjust_gassy_effect: called with an invalid amount. (Got: [amount])")

	var/datum/status_effect/burpslurring/burpslur = has_status_effect(/datum/status_effect/burpslurring)
	if(burpslur)
		burpslur.set_gassy_value(clamp(burpslur.gassy_value + amount, down_to, up_to))
	else if(amount > 0)
		apply_status_effect(/datum/status_effect/burpslurring, amount)

/**
 * The burpslur status effect.
 * Slowly decreases over time, causing effects based on gassy_value value.
 */
/datum/status_effect/burpslurring
	id = "burpslur"
	tick_interval = 2 SECONDS
	status_type = STATUS_EFFECT_REPLACE
	remove_on_fullheal = TRUE
	alert_type = null
	/// The level of drunkness we are currently at.
	var/gassy_value = 0

/datum/status_effect/burpslurring/on_creation(mob/living/new_owner, gassy_value = 0)
	. = ..()
	set_gassy_value(gassy_value)

/datum/status_effect/burpslurring/get_examine_text()
	// Dead people don't look drunk
	if(owner.stat == DEAD || HAS_TRAIT(owner, TRAIT_FAKEDEATH))
		return null

	// .01s are used in case the drunk value ends up to be a small decimal.
	switch(gassy_value)
		if(11 to 21)
			return span_warning("[owner.p_They()] [owner.p_are()] mildly gassy.")
		if(21.01 to 41)
			return span_warning("[owner.p_They()] [owner.p_are()] gassy.")
		if(41.01 to 51)
			return span_warning("[owner.p_They()] [owner.p_are()] quite gassy and [owner.p_their()] belches uncontrollably.")
		if(51.01 to 61)
			return span_warning("[owner.p_They()] [owner.p_are()] very gassy and [owner.p_their()] gut churning, with the smell of belches.")
		if(61.01 to 91)
			return span_warning("[owner.p_They()] look[owner.p_s()] like a gassy mess.")
		if(91.01 to INFINITY)
			return span_warning("[owner.p_They()] [owner.p_are()] a bubblegutted, belching wreck.")

	return null

/// Sets the drunk value to set_to, deleting if the value drops to 0 or lower
/datum/status_effect/burpslurring/proc/set_gassy_value(set_to)
	if(!isnum(set_to))
		CRASH("[type] - invalid value passed to set_gassy_value. (Got: [set_to])")
	gassy_value = set_to
	if(gassy_value <= 0)
		qdel(src)

/datum/status_effect/burpslurring/tick(seconds_between_ticks)
	// Drunk value does not decrease while dead or in stasis
	if(owner.stat == DEAD || HAS_TRAIT(owner, TRAIT_STASIS))
		return

	// Every tick, the drunk value decrases by
	// 0.001 + 4% the current gassy_value
	// (until it reaches 0 and terminates)
	set_gassy_value(gassy_value - (gassy_value * 0.04 + 0.001)) // SKYRAT EDIT CHANGE - ALCOHOL_PROCESSING - ORIGINAL: set_drunk_value(gassy_value - (0.01 + gassy_value * 0.04)
	if(QDELETED(src))
		return

	on_tick_effects()

/datum/status_effect/burpslurring/proc/on_tick_effects()
	owner.adjust_burpslurring(4 SECONDS)
	// owner.adjust_timed_status_effect(4 SECONDS, /datum/status_effect/speech/slurring/burp, max_duration = 20 SECONDS)
	// if(gassy_value >= 43.4)
	// 	if(prob(clamp(gassy_value - 8, 0, 100)))
	// 		owner.adjust_timed_status_effect(4 SECONDS, /datum/status_effect/speech/slurring/burp, max_duration = 20 SECONDS)
	// 	if(prob(10))
	// 		owner.adjust_confusion(4 SECONDS)

	// // Over 61, we start to get blurred vision
	// if(gassy_value >= 63.4)
	// 	owner.set_dizzy_if_lower(45 SECONDS)
	// 	if(prob(15))
	// 		owner.adjust_eye_blur_up_to(4 SECONDS, 20 SECONDS)

	// // Over 71, we will constantly have blurry eyes, we might vomit
	// if(gassy_value >= 73.4)
	// 	owner.set_eye_blur_if_lower(20 SECONDS)
	// 	if(prob(3))
	// 		owner.adjust_confusion(15 SECONDS)
	// 		if(iscarbon(owner))
	// 			var/mob/living/carbon/carbon_owner = owner
	// 			carbon_owner.vomit() // Vomiting clears toxloss - consider this a blessing

/datum/status_effect/speech/slurring/burp
	id = "burp_slurring"
	common_prob = -1
	uncommon_prob = -1
	replacement_prob = 5
	doubletext_prob = 0
	text_modification_file = "gs_slurring_burp_text.json"

/datum/status_effect/speech/slurring/burp/handle_message(datum/source, list/message_args)
	var/current_gassiness = owner.get_gassy_amount()
	// These numbers are arbitarily picked
	// Common replacements start at about 20, and maxes out at about 85
	common_prob = clamp((current_gassiness * 0.8) - 16, 4, 50)
	// Uncommon replacements (burping) start at 50 and max out at 110 (when you are dying)
	uncommon_prob = clamp((current_gassiness * 0.3) - 10, 0, 12)
	return ..()
