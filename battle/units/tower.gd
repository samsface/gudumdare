extends UnitRanged

@export var shooting := true

var messages = [
	"worm dominance!",
	"the early bird gets the BURN",
	"birds? more like... NERDS!",
	"prepare for your demise!",
	"get wormed!",
	"down with the gestapo!",
	"birds suck!!",
	"Wormdemic is here!!",
	"I'll DUNE you!!",
	"wiggle or be wiggled!",
	"don't step on me!",
	"spread your wings and DIE!",
	"we'll put you in the ground!!",
	"taste dirt suckers!",
	"they call us the reign worms!",
	"Tweeting is for losers!",
	"bird is no longer the word",
	"spread your wings and learn to die",
	"who's on top of the food chain now?",
	"Twitter is dead anyways",
]

func _ready() -> void:
	if not is_foe:
		if Game.game.has_upgrade("More Health 1"):
			health += 100
		if Game.game.has_upgrade("More Health 2"):
			health += 200
		shooting = Game.game.has_upgrade("Tower Shoots")
		spawn()
	super()

func process_movement(delta):
	if shooting:
		super.process_movement(delta)

func spawn():
	%Healthbar.visible = false
	$Model/AnimationPlayer.play("spawn")
	await $Model/AnimationPlayer.animation_finished
	await get_tree().create_timer(1.0).timeout
	talk(messages.pick_random())

func hit(damage):
	super.hit(damage)
	if not is_foe and health <= 0:
		$Model/AnimationPlayer.play("dead")

func die_animation():
	if is_foe:
		super.die_animation()

func talk(message: String):
	$Model/AnimationPlayer.play("scream")
	%Speech.text = message
	await get_tree().create_timer(0.2).timeout
	%SpeechBubble.visible = true
	await get_tree().create_timer(2.0).timeout
	%SpeechBubble.visible = false
	
func hide_player():
	$Model/AnimationPlayer.play("hidden")
