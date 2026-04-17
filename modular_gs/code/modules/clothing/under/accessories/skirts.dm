// Accessories that mostly or entirely cover a shirt.
/obj/item/clothing/accessory/skirt
	name = "long skirt"
	desc = "An attachable skirt. At this point does it qualify as a dress?"
	icon = 'icons/map_icons/clothing/under/dress.dmi'
	icon_state = "/obj/item/clothing/under/dress/skirt/skyrat/long"
	post_init_icon_state = "long_skirt"
	inhand_icon_state = "blackskirt"
	lefthand_file = 'icons/mob/inhands/clothing/suits_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing/suits_righthand.dmi'
	minimize_when_attached = FALSE
	attachment_slot = NONE
	greyscale_config = /datum/greyscale_config/long_skirt
	greyscale_config_worn = /datum/greyscale_config/long_skirt/worn
	greyscale_colors = "#3a3c45"
	flags_1 = IS_PLAYER_COLORABLE_1
