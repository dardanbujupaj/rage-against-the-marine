extends PopupPanel

onready var screenshake = $VBoxContainer/Screenshake/Screenshake
onready var sound = $VBoxContainer/SoundVolume/Sound
onready var music = $VBoxContainer/MusicVolume/Music
onready var main = $VBoxContainer/MainVolume/Main


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screenshake.value = Settings.screenshake_intensity
	sound.value = Settings.sound_volume
	music.value = Settings.music_volume
	main.value = Settings.main_volume


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Main_value_changed(value: float) -> void:
	Settings.main_volume = value
	if visible:
		SoundEngine.play_sound("UIClick")


func _on_Sound_value_changed(value: float) -> void:
	Settings.sound_volume = value
	if visible:
		SoundEngine.play_sound("UIClick")


func _on_Music_value_changed(value: float) -> void:
	Settings.music_volume = value
	

func _on_Screenshake_value_changed(value: float) -> void:
	Settings.screenshake_intensity = value
	if visible:
		get_tree().call_group("shake_cameras", "add_trauma", 1.0)


#func _on_Close_pressed() -> void:
#	SceneLoader.goto_scene("res://scenes/title_screen/TitleScreen.tscn")


func _on_Button_pressed() -> void:
	SoundEngine.play_sound("UIClick")


func _on_Button_mouse_entered() -> void:
	SoundEngine.play_sound("UIHover")


func _on_Delete_Savegame_pressed() -> void:
	#SaveGame.reset()
	pass


func _on_Close_pressed() -> void:
	Settings.persist_data()
	hide()


func _on_Font_item_selected(index: int) -> void:
	var new_font = $VBoxContainer/HBoxContainer2/Font.get_item_text(index)
	Settings.font = new_font
