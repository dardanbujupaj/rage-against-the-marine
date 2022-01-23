extends "res://util/PersistentProperties.gd"

var font: String = "ChelseaMarket-Regular" setget _set_font, _get_font

var main_volume: float = 1 setget _set_main_volume
var sound_volume: float = 1 setget _set_sound_volume
var music_volume: float = 1 setget _set_music_volume

var screenshake_intensity: float = 1.0


func _init():
	# override filename
	filepath = 'user://settings.json'


# set soundeffect volume on AudioServer
func _set_sound_volume(new_value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Sound"),
		linear2db(new_value)
	)
	sound_volume = new_value

# set music volume on AudioServer
func _set_music_volume(new_value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"), 
		linear2db(new_value)
	)
	music_volume = new_value

# set master volume on AudioServer
func _set_main_volume(new_value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"), 
		linear2db(new_value)
	)
	main_volume = new_value

func _set_font(new_font: String) -> void:
	print(new_font)
	var font := preload("res://default_theme.tres").default_font as DynamicFont
	font.set_deferred("font_data", load("res://fonts/" + new_font + ".ttf"))
	
	#font = new_font
func _get_font() -> String:
	var font := preload("res://default_theme.tres").default_font as DynamicFont
	var font_path := font.font_data.font_path
	return font_path.get_file().trim_suffix("." + font_path.get_extension())
