tool
extends Node2D

const SEGMENTS = 20

onready var water := $Water

var noise := OpenSimplexNoise.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	noise.period = 1.0
	update_water()
	

var pos = 0.0

func _process(delta: float) -> void:
	pos += delta
	update_water(pos)

func update_water(offset: float = 0.0) -> void:
	if water == null:
		return
	var viewport_rect = get_viewport_rect()
	
	var poly := []
	for i in range(SEGMENTS + 1):
		var x = float(i) / SEGMENTS
		var y = 300.0 + noise.get_noise_1d(x + offset) * 20.0
		poly.append(Vector2(x * viewport_rect.size.x, y))
	
	poly.append_array([viewport_rect.end, Vector2(0, viewport_rect.size.y)])
	
	water.polygon = poly
