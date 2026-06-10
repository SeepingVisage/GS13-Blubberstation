/datum/quirk_constant_data/cosglow
	associated_typepath = /datum/quirk/cosglow
	customization_options = list(
		/datum/preference/color/cosglow_glow_color,
		/datum/preference/numeric/cosglow_thickness,
	)

/datum/preference/color/cosglow_glow_color
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "cosglow_glow_color"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/color/cosglow_glow_color/create_default_value()
	return "#14FF67"

/datum/preference/color/cosglow_glow_color/apply_to_human()
	return

/datum/preference/numeric/cosglow_thickness
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "cosglow_thickness"
	savefile_identifier = PREFERENCE_CHARACTER
	minimum = COSGLOW_THICKNESS_MIN
	maximum = COSGLOW_THICKNESS_MAX
	step = 0.5

/datum/preference/numeric/cosglow_thickness/apply_to_human()
	return

/datum/preference/numeric/cosglow_thickness/create_default_value()
	return COSGLOW_THICKNESS_DEFAULT
