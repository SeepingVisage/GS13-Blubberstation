/obj/vehicle/ridden/wheelchair/motorized/motorized_bed
	buckle_lying = 90
	buckle_dir = SOUTH
	icon = 'icons/obj/medical/medical_bed.dmi'
	icon_state = "med_down"
	base_icon_state = "med"

/obj/vehicle/ridden/wheelchair/motorized/motorized_bed/make_ridable()
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/wheelchair/hand)
	//necessary because adding the element sets buckle_lying to 0 again
	buckle_lying = 90
	buckle_dir = SOUTH

/obj/vehicle/ridden/wheelchair/motorized/motorized_bed/Initialize(mapload)
	. = ..()
	var/datum/component/simple_rotation = src.GetComponent(/datum/component/simple_rotation)
	simple_rotation.Destroy()
	icon_state = "med_down"

/obj/vehicle/ridden/wheelchair/motorized/motorized_bed/refresh_parts()
	speed = 1 // Should never be under 1
	for(var/datum/stock_part/servo/servo in component_parts)
		speed += servo.tier
	for(var/datum/stock_part/capacitor/capacitor in component_parts)
		power_efficiency = capacitor.tier
