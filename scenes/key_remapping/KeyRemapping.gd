extends PopupPanel


onready var action_list = $VBoxContainer2/ActionList


# Set all Actions to default mapping (from project settings)
func _on_Reset_pressed() -> void:
	InputMap.load_from_globals()
	
	# update all buttons
	for list_item in action_list.get_children():
		list_item.update_button()


func _on_Close_pressed() -> void:
	Keymap.persist_data()
	hide()



func _on_Button_mouse_entered() -> void:
	SoundEngine.play_sound("UIHover")


func _on_Button_pressed() -> void:
	SoundEngine.play_sound("UIClick")
