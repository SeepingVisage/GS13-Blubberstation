#define adjust_burpslurring(duration) adjust_timed_status_effect(duration, /datum/status_effect/speech/slurring/burp)
#define adjust_burpslurring_up_to(duration, up_to) adjust_timed_status_effect(duration, /datum/status_effect/speech/slurring/burp, up_to)
#define set_burpslurring(duration) set_timed_status_effect(duration, /datum/status_effect/speech/slurring/burp)
#define set_burpslurring_if_lower(duration) set_timed_status_effect(duration, /datum/status_effect/speech/slurring/burp, TRUE)
