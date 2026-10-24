/obj/vehicle/ridden/wheelchair/motorized/mobility_scooter
	name = "mobility scooter"
	desc = "A cart you can use to hold groceries, or ride in."
	icon = 'modular_gs/icons/obj/vehicles.dmi'
	icon_state = "mobility_full"
	var/obj/item/mod/core/cell_holder = new /obj/item/mod/core/

/datum/storage/mobility_scooter
	max_slots = 3
	max_specific_storage = WEIGHT_CLASS_SMALL
	silent = FALSE

/obj/vehicle/ridden/wheelchair/motorized/mobility_scooter/Initialize(mapload)
	. = ..()
	create_storage(storage_type = /datum/storage/mobility_scooter)

/obj/vehicle/ridden/wheelchair/motorized/mobility_scooter/add_component_parts()
	// Add tier 1 stock parts so that non-crafted wheelchairs aren't empty
	component_parts += GLOB.stock_part_datums[/datum/stock_part/capacitor]
	component_parts += GLOB.stock_part_datums[/datum/stock_part/servo]
	component_parts += GLOB.stock_part_datums[/datum/stock_part/servo]
	power_cell = new /obj/item/stock_parts/power_store/cell(cell_holder)

/obj/vehicle/ridden/wheelchair/motorized/mobility_scooter/refresh_parts()
	speed = 1 // Should never be under 1
	for(var/datum/stock_part/servo/servo in component_parts)
		speed += servo.tier
	var/chair_icon = "mobility_full"//[speed > delay_multiplier ? "_fast" : ""]"
	// if(icon_state != chair_icon)
	// 	overlay_icon = chair_icon + "_overlay"
	overlay_icon = "mobility_nochair"

	icon_state = chair_icon

	for(var/datum/stock_part/capacitor/capacitor in component_parts)
		power_efficiency = capacitor.tier

/obj/vehicle/ridden/wheelchair/motorized/mobility_scooter/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	if(.)
		return

	if(!panel_open || user.combat_mode)
		return NONE

	if(istype(tool, /obj/item/stock_parts/power_store/cell))
		if(power_cell)
			to_chat(user, span_warning("There is a power cell already installed."))
			return ITEM_INTERACT_BLOCKING

		tool.forceMove(cell_holder)
		power_cell = tool
		to_chat(user, span_notice("You install the [tool]."))
		refresh_parts()
		return ITEM_INTERACT_SUCCESS

	if(!istype(tool, /obj/item/stock_parts))
		return NONE

	var/datum/stock_part/newstockpart = GLOB.stock_part_datums_per_object[tool.type]
	if(isnull(newstockpart))
		CRASH("No corresponding datum/stock_part for [newstockpart.type]")

	var/replacement_occured = FALSE
	for(var/datum/stock_part/oldstockpart in component_parts)
		var/type_to_check
		for(var/pathtype in required_parts)
			if(ispath(oldstockpart.type, pathtype))
				type_to_check = pathtype
				break

		if(!istype(newstockpart, type_to_check) || !istype(oldstockpart, type_to_check) || newstockpart.tier <= oldstockpart.tier)
			continue

		// delete the part in the users hand and add the datum part to the component_list
		qdel(tool)
		component_parts += newstockpart
		// create an new instance of the old datum stock part physical type & put it in the users hand
		var/obj/item/stock_parts/part = new oldstockpart.physical_object_type
		user.put_in_hands(part)
		component_parts -= oldstockpart
		// user message
		user.visible_message(span_notice("[user] replaces [oldstockpart.name()] with [newstockpart.name()] in [src]."), span_notice("You replace [oldstockpart.name()] with [newstockpart.name()]."))
		replacement_occured = TRUE
		break

	refresh_parts()
	return replacement_occured ? ITEM_INTERACT_SUCCESS : ITEM_INTERACT_BLOCKING

/obj/vehicle/ridden/wheelchair/motorized/mobility_scooter/attach_bomb()
	return FALSE

/obj/vehicle/ridden/wheelchair/motorized/mobility_scooter/get_cell()
	var/obj/item/stock_parts/power_store/cell = get_charge_source()
	if(!istype(cell))
		return null
	return cell

/obj/vehicle/ridden/wheelchair/motorized/mobility_scooter/proc/get_charge_source()
	return cell_holder?.charge_source()

/obj/vehicle/ridden/wheelchair/motorized/mobility_scooter/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	for(var/mob/living/buckled_mob as anything in buckled_mobs)
		buckled_mob.pixel_y = 3
