extends Sprite


var speed = 50.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	
	speed = rand_range(25.0, 75)
	texture = texture.duplicate()
	texture.noise = texture.noise.duplicate()
	texture.noise.seed = randi()


func _process(delta: float) -> void:
	position.x -= delta * speed
	
	if global_position.x < -128:
		position = Vector2(0.0, rand_range(-50.0, 50.0))
		speed = rand_range(25.0, 75)
