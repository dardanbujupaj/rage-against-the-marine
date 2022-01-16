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
	position.y = 280.0 + noise.get_noise_1d(position.x) * 30
	
	if position.x < -100.0:
		queue_free()
	




func _on_Ship_body_entered(body: Node) -> void:
	emit_signal("fish_freed", position, 1 + randi() % 5)
	
