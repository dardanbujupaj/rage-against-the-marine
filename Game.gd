extends Node2D

const SEGMENTS := 48
const WATER_HEIGHT := 300.0
const WATER_OFFSET := 300.0 # to make sure water fills camera area

onready var water := $Water
onready var character := $Character



onready var distance_label := $CanvasLayer/VBoxContainer/Distance
onready var speed_label := $CanvasLayer/Debug/Speed
onready var fish_speed := $CanvasLayer/Debug/FishSpeed

onready var tutorial_panel := $Menu/Tutorial
onready var tutorial_text := $Menu/Tutorial/TutorialText

onready var camera_position := $CameraPosition
onready var camera := $CameraPosition/Camera
onready var swarm_cam_tween := $Tween

var speed = 200.0
var distance = 0.0

var speed_increase = 20

var swarm_cam = true

var noise := OpenSimplexNoise.new()

var tutorial_state = TutorialState.INACTIVE

enum TutorialState {
	INACTIVE,
	START,
	JUMP,
	SHIP,
	ACTIONS,
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	noise.period = 300.0
	update_water()
	update_speed()
	get_tree().paused = true


func _process(delta: float) -> void:
	distance += delta * speed
	update_water(distance)
	update_labels()
	
	process_state()


func _unhandled_key_input(event: InputEventKey) -> void:
	if OS.has_feature("debug"):
		if event.is_pressed() and event.scancode == KEY_F:
			spawn_follower(Vector2())
		if event.is_pressed() and event.scancode == KEY_K:
			$AnimationPlayer.play("awaken")
		
	if event.is_action("toggle_swarm_cam") and event.is_pressed():
		toggle_swarm_cam()
	


func start() -> void:
	get_tree().paused = false
	tutorial_state = TutorialState.START
	
	# hide all menus
	for menu in $Menu.get_children():
		menu.hide()
	
	# remove all fishes
	for fish in $Followers.get_children():
		fish.free()
	
	toggle_swarm_cam()


func process_state() -> void:
	match tutorial_state:
		TutorialState.START:
			tutorial_panel.show()
			tutorial_state = TutorialState.JUMP
			tutorial_text.bbcode_text = "Press [u]%s[/u] to jump.\nThe longer you press the higher the jump!" % str(Keymap.input_to_text(Keymap.input_for_action("jump")))
		TutorialState.JUMP:
			if character.position.y < 0:
				tutorial_state = TutorialState.SHIP
				$ShipSpawnTimer.start()
				tutorial_text.bbcode_text = "[u]Free fishes[/u] by [u]hitting ships[/u] from above or below.\n The faster the better!"
		TutorialState.SHIP:
			if $Followers.get_child_count() > 10:
				tutorial_state = TutorialState.ACTIONS
				tutorial_text.bbcode_text = "Freed fishes can help you attack ships.\nPress [u]%s[/u] oder the [u]button top left[/u] to use 'Fish Rain'" % str(Keymap.input_to_text(Keymap.input_for_action("swarm_action_1")))


func update_water(offset: float = 0.0) -> void:
	if water == null:
		return
	var viewport_rect = get_viewport_rect()
	
	var poly := []
	for i in range(SEGMENTS + 1):
		var x = float(i) / SEGMENTS * viewport_rect.size.x
		var y = WATER_HEIGHT + noise.get_noise_1d(x + offset) * 20.0
		poly.append(Vector2(x, y))
	
	poly.append_array([
		Vector2(viewport_rect.end.x + WATER_OFFSET, WATER_HEIGHT),
		viewport_rect.end + Vector2(WATER_OFFSET, WATER_OFFSET),
		Vector2(-WATER_OFFSET, viewport_rect.size.y),
		Vector2(-WATER_OFFSET, WATER_HEIGHT)
		])
	
	water.polygon = poly
	water.texture_offset.x = offset



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


func toggle_swarm_cam() -> void:
	swarm_cam = !swarm_cam
	var target = $Followers.position if swarm_cam else Vector2(512, 300)
	var zoom = Vector2(0.3, 0.3) if swarm_cam else Vector2(1.0, 1.0)
	
	swarm_cam_tween.stop_all()
	swarm_cam_tween.interpolate_property(camera_position, "position", camera_position.position, target, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	swarm_cam_tween.interpolate_property(camera, "zoom", camera.zoom, zoom, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	swarm_cam_tween.start()
	



func _on_Button_pressed() -> void:
	SoundEngine.play_sound("UIClick")


func _on_Button_mouse_entered() -> void:
	SoundEngine.play_sound("UIHover")


func _on_Settings_pressed() -> void:
	$Menu/SettingsMenu.popup_centered()


func _on_Keymap_pressed() -> void:
	$Menu/KeyRemapping.popup_centered()


func _on_Start_pressed() -> void:
	start()
