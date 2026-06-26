
/obj/item/pen/calorite
	name = "calorite pen"
	desc = "A novelty pen with the tip made out of calorite, made to celebrate the success of Nutri-Tech! GATO is not liable for any mishandlings of this novelty item."
	icon = 'modular_gs/icons/obj/caloritepen.dmi'
	icon_state = "caloritepen"

/obj/item/pen/calorite/attack(mob/living/carbon/target, mob/living/user)
    . = ..()

    if(!istype(target))
        return

    target.adjust_calorite_poisoning(0.01)

    to_chat(user, span_notice("You prick [target] with the concealed injector."))
    if(target != user)
        to_chat(target, span_warning("You feel a tiny prick."))
