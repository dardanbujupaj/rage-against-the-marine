extends Area2D

signal fish_freed(position, amount) 

var speed = 0.0


var noise := OpenSimplexNoise.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	noise.seed = randi()
	noise.period = 256.0


func _physics_process(delta: float) -> void:
	position.x -= speed * delta
	var next_y = 280.0 + noise.get_noise_1d(position.x) * 30
	rotation = (position.y - next_y) / 10
	position.y = next_y
	
	if position.x < -100.0:
		queue_free()
	




func _on_Ship_body_entered(body: Node) -> void:
	
	var impact = (abs(body.velocity.y) / body.MAX_VELOCITY_Y) if body is RigidBody2D else 0.5
	var explosion = preload("res://Explosion.tscn").instance()
	explosion.scale *= impact * 2
	add_child(explosion)
	
	get_tree().call_group("shake_cameras", "add_trauma", impact)
	SoundEngine.play_sound("Explosion", impact)
	
	explosion.global_position = body.global_position
	emit_signal("fish_freed", position, int(impact * 5))
	


func _on_AnimationTimer_timeout() -> void:
	$Ship.play("fish")


func _on_Ship_animation_finished() -> void:
	$Ship.play("default")
