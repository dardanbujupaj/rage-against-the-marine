extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(OS.has_feature("debug"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$FPS.text = "FPS: %3d" % Performance.get_monitor(Performance.TIME_FPS)
