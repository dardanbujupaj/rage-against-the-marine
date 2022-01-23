extends Node2D

const WATER_LEVEL = 300.0

var noise = OpenSimplexNoise.new()

var time := 0.0
var state = State.FOLLOW

enum State {
	FOLLOW,
	RAIN,
	TORNADO,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	noise.seed = randi()
	noise.period = 10.0
	scale *= rand_range(0.5, 2.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	var target: Vector2
	match state:
		State.FOLLOW:
			var offset := Vector2(noise.get_noise_1d(time), noise.get_noise_1d(-time))
			target = offset * 200
			var mouse_distance := -get_local_mouse_position()
			target += (mouse_distance).normalized() / max(1.0, mouse_distance.length_squared() / 1000) * 20

	var position_before := position
	position = lerp(position, target, 5 * delta)
	
	if position_before.y < WATER_LEVEL and position.y >= WATER_LEVEL:
		SoundEngine.play_sound("SmallSplash" + str(randi() % 5 + 1))



func fish_rain() -> void:
	
	pass
