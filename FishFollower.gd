extends Node2D

var noise = OpenSimplexNoise.new()

var time := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	noise.seed = randi()
	noise.period = 10.0
	scale *= rand_range(0.5, 2.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	var offset = Vector2(noise.get_noise_1d(time), noise.get_noise_1d(-time))
	var target = offset * 200
	var mouse_distance = target - get_local_mouse_position()
	target += (mouse_distance).normalized() / max(0.001, mouse_distance.length_squared()) * 100
	position = lerp(position, target, 5 * delta)
