/obj/vehicle/ridden/wheelchair/motorized/mobility_scooter
	name = "mobility scooter"
	desc = "A cart you can use to hold groceries, or ride in."
	icon = 'modular_gs/icons/obj/vehicles.dmi'
	icon_state = "mobility_full"

/datum/storage/mobility_scooter
	max_slots = 3
	max_specific_storage = WEIGHT_CLASS_SMALL
	silent = FALSE

/obj/vehicle/ridden/wheelchair/motorized/mobility_scooter/Initialize(mapload)
	. = ..()
	create_storage(storage_type = /datum/storage/mobility_scooter)

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

/obj/vehicle/ridden/wheelchair/motorized/mobility_scooter/attach_bomb()
	return FALSE

/obj/vehicle/ridden/wheelchair/motorized/mobility_scooter/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	for(var/mob/living/buckled_mob as anything in buckled_mobs)
		buckled_mob.pixel_y = 3
