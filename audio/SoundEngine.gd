extends Node

const POOL_SIZE = 8

const sounds = {
	
	
	"UIHover": {
		"stream": preload("res://audio/effects/UI_Click_Metallic_mono.wav"),
		"volume": 0
		},
	"UIClick": {
		"stream":preload("res://audio/effects/UI_Click_Distinct_mono.wav"),
		"volume": 0
		},
	
	"SmallSplash1": {
		"stream": preload("res://audio/effects/SPLASH_Small_01_mono.wav"),
		"volume": 0
		},
	"SmallSplash2": {
		"stream": preload("res://audio/effects/SPLASH_Small_02_mono.wav"),
		"volume": 0
		},
	"SmallSplash3": {
		"stream": preload("res://audio/effects/SPLASH_Small_03_mono.wav"),
		"volume": 0
		},
	"SmallSplash4": {
		"stream": preload("res://audio/effects/SPLASH_Small_04_mono.wav"),
		"volume": 0
		},
	"SmallSplash5": {
		"stream": preload("res://audio/effects/SPLASH_Small_05_mono.wav"),
		"volume": 0
		},
	"CharacterSplash": {
		"stream": preload("res://audio/effects/SPLASH_Ground_01_mono.wav"),
		"volume": 0
		},
	"Explosion": {
		"stream": preload("res://audio/effects/EXPLOSION_Short_Kickback_Crackle_stereo.wav"),
		"volume": 0
		},
	"TutorialSuccess": {
		"stream": preload("res://audio/effects/MUSIC_EFFECT_Bell_Voice_Positive_07_stereo.wav"),
		"volume": 0
		},
#	"Jupiter": {
#		"stream": preload("res://Sounds/Jupiter1.wav"),
#		"volume": 0
#		},
#	"Whoosh": {
#		"stream": preload("res://Sounds/woosh.wav"),
#		"volume": 20
#		},
	}


# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	for i in range(POOL_SIZE):
		var player = AudioStreamPlayer.new()
		player.bus = "Sound"
		add_child(player)


func _get_idle_player():
	for player in get_children():
		if not (player as AudioStreamPlayer).playing:
			return player

func play_sound(sound_name: String, intensity: float = 1.0):
	var audio_player: AudioStreamPlayer = _get_idle_player()
	if audio_player != null:
		var sound = sounds[sound_name]
		audio_player.stream = sound["stream"]
		audio_player.volume_db = linear2db(db2linear(sound["volume"]) * intensity)
		audio_player.play()
