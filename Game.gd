tool
extends Node2D

const SEGMENTS = 48

onready var water := $Water



onready var distance_label := $CanvasLayer/VBoxContainer/Distance
onready var speed_label := $CanvasLayer/Debug/Speed
onready var fish_speed := $CanvasLayer/Debug/FishSpeed

onready var camera_position := $CameraPosition
onready var camera := $CameraPosition/Camera
onready var swarm_cam_tween := $Tween

var speed = 200.0
var distance = 0.0

var noise := OpenSimplexNoise.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	noise.period = 300.0
	update_water()
	update_speed()


func _process(delta: float) -> void:
	distance += delta * speed
	update_water(distance)
	
	update_labels()


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_pressed() and event.scancode == KEY_F:
		spawn_follower(Vector2())
	if event.is_pressed() and event.scancode == KEY_S:
		toggle_swarm_cam()
	if event.is_pressed() and event.scancode == KEY_K:
		$AnimationPlayer.play("awaken")


func update_water(offset: float = 0.0) -> void:
	if water == null:
		return
	var viewport_rect = get_viewport_rect()
	
	var poly := []
	for i in range(SEGMENTS + 1):
		var x = float(i) / SEGMENTS * viewport_rect.size.x
		var y = 300.0 + noise.get_noise_1d(x + offset) * 20.0
		poly.append(Vector2(x, y))
	
	poly.append_array([viewport_rect.end, Vector2(0, viewport_rect.size.y)])
	
	water.polygon = poly
	water.texture_offset.x = offset


var speed_increase = 20

func update_speed() -> void:
	speed += speed_increase
	speed_increase += 1
	get_tree().set_group("ships", "speed", speed)


func update_labels() -> void:
	if distance_label != null:
		distance_label.text = str(distance)
		speed_label.text = str(speed)
		fish_speed.text = str($Character.velocity.y)


func _on_Timer_timeout() -> void:
	update_speed()


func _on_ShipSpawnTimer_timeout() -> void:
	var ship = preload("res://Ship.tscn").instance()
	ship.speed = speed
	ship.position.y = 300.0
	ship.position.x = get_viewport().size.x * 1.5
	ship.connect("fish_freed", self, "_on_Ship_fish_freed")
	call_deferred("add_child", ship)


func spawn_follower(position: Vector2) -> void:
	var fish = preload("res://FishFollower.tscn").instance()
	fish.position = position - $Followers.position
	$Followers.call_deferred("add_child", fish)


func _on_Ship_fish_freed(pos: Vector2, amount: int) -> void:
	for _i in range(amount):
		spawn_follower(pos)


var swarm_cam = false

func toggle_swarm_cam() -> void:
	swarm_cam = !swarm_cam
	var target = $Followers.position if swarm_cam else Vector2(512, 300)
	var zoom = Vector2(0.3, 0.3) if swarm_cam else Vector2(1.0, 1.0)
	
	swarm_cam_tween.stop_all()
	swarm_cam_tween.interpolate_property(camera_position, "position", camera_position.position, target, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	swarm_cam_tween.interpolate_property(camera, "zoom", camera.zoom, zoom, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	swarm_cam_tween.start()
	

