extends StaticBody2D

const WATER_LEVEL = 300.0

var noise = OpenSimplexNoise.new()

var time := 0.0
var state = State.FOLLOW

enum State {
	FOLLOW,
	RAIN_RISING,
	RAIN_FALLING,
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
	
	match state:
		State.FOLLOW:
			var offset := Vector2(noise.get_noise_1d(time), noise.get_noise_1d(-time))
			var target := offset * 200
			var mouse_distance := -get_local_mouse_position()
			target += (mouse_distance).normalized() / max(1.0, mouse_distance.length_squared() / 1000) * 20
			position = lerp(position, target, 5.0  * delta)
			# rotation = lerp_angle(rotation, position.angle_to(target), 5.0 * delta)
			
		State.RAIN_RISING:
			# rotation = lerp_angle(rotation, -PI / 2, 5.0  * delta)
			global_position.y = lerp(global_position.y, -150, 0.05)
			
			if global_position.y < -100:
				set_collision_layer_bit(0, true)
				global_position = Vector2(rand_range(0, get_viewport_rect().end.x), rand_range(-300, -1000))
				state = State.RAIN_FALLING
				print("fall")
		State.RAIN_FALLING:
			# rotation = lerp_angle(rotation, PI / 2, 5.0  * delta)
			var height_before := global_position.y
			
			global_position.y += 500 * delta
			
			if height_before < WATER_LEVEL and global_position.y >= WATER_LEVEL:
				SoundEngine.play_sound("SmallSplash" + str(randi() % 5 + 1))
			
			if global_position.y > 1000:
				queue_free()



func fish_rain() -> void:
	remove_from_group("available_fish")
	state = State.RAIN_RISING
