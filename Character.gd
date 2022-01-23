extends KinematicBody2D


const WATER_LEVEL = 300

const IDLE_BOUYANCY = 400
const SINKING_BOUYANCY = 700
const JUMP_BOUYANCY = 1000
const JUMP_GRAVITY = 400
const FLOAT_GRAVITY = 700
const FALL_GRAVITY = 800

const MAX_VELOCITY_Y = 500


var velocity = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func is_in_water() -> bool:
	return position.y > WATER_LEVEL


func _process(delta: float) -> void:
	$Label.text = str(velocity.y)
	rotation = velocity.y / MAX_VELOCITY_Y


var last_in_water = false

func _physics_process(delta: float) -> void:
	
	# dive into water
	if not last_in_water and is_in_water():
		SoundEngine.play_sound("CharacterSplash", velocity.y / MAX_VELOCITY_Y)
		AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Music"), 0, true)
	# jump out of water
	if last_in_water and not is_in_water():
		AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Music"), 0, false)
	
	last_in_water = is_in_water()
	
	
	
	if is_in_water():
		if Input.is_action_pressed("jump"):
			velocity.y -= JUMP_BOUYANCY * delta
		else:
			if velocity.y > 0:
				velocity.y -= SINKING_BOUYANCY * delta
			else:
				velocity.y -= IDLE_BOUYANCY * delta
	else:
		if Input.is_action_pressed("jump"):
			velocity.y += JUMP_GRAVITY * delta
		else:
			if velocity.y < 0:
				velocity.y += FLOAT_GRAVITY * delta
			else:
				velocity.y += FALL_GRAVITY * delta
	
	# give a boost when starting to jump
	if abs(300.0 - position.y) < 10.0 and abs(velocity.y) < 10.0:
		velocity.y -= 50.0
	
	velocity.y = clamp(velocity.y, -MAX_VELOCITY_Y, MAX_VELOCITY_Y)
	velocity = move_and_slide(velocity)
