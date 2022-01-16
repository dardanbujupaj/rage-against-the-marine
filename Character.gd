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

func _physics_process(delta: float) -> void:
	if is_in_water():
		if Input.is_action_pressed("up"):
			velocity.y -= JUMP_BOUYANCY * delta
		else:
			if velocity.y > 0:
				velocity.y -= SINKING_BOUYANCY * delta
			else:
				velocity.y -= IDLE_BOUYANCY * delta
	else:
		if Input.is_action_pressed("up"):
			velocity.y += JUMP_GRAVITY * delta
		else:
			if velocity.y < 0:
				velocity.y += FLOAT_GRAVITY * delta
			else:
				velocity.y += FALL_GRAVITY * delta
	
	velocity.y = clamp(velocity.y, -MAX_VELOCITY_Y, MAX_VELOCITY_Y)
	velocity = move_and_slide(velocity)
