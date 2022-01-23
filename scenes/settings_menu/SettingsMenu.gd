extends PopupPanel

onready var screenshake = $VBoxContainer/Screenshake/Screenshake
onready var sound = $VBoxContainer/SoundVolume/Sound
onready var music = $VBoxContainer/MusicVolume/Music
onready var main = $VBoxContainer/MainVolume/Main
onready var font = $VBoxContainer/HBoxContainer2/Font
onready var font_size = $VBoxContainer/HBoxContainer3/FontSize


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
	hide()


func _on_Font_item_selected(index: int) -> void:
	var new_font = $VBoxContainer/HBoxContainer2/Font.get_item_text(index)
	Settings.font = new_font


func _on_FontSize_value_changed(value: float) -> void:
	Settings.font_size = value


func _on_SettingsMenu_about_to_show() -> void:
	screenshake.value = Settings.screenshake_intensity
	sound.value = Settings.sound_volume
	music.value = Settings.music_volume
	main.value = Settings.main_volume
	
	for i in range(font.get_item_count()):
		if font.get_item_text(i) == Settings.font:
			font.select(i)
			break
			
	font_size.value = Settings.font_size




func _on_SettingsMenu_popup_hide() -> void:
	Settings.persist_data()
