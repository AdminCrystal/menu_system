extends Node


var data: Dictionary

var fps_delay: int = 10



onready var FPSDisplay: Label = $FPSDisplay as Label




func _ready() -> void:
	var _error = (get_tree().get_root() as Viewport).connect("size_changed", \
		self, "adjust_screen_resolution")	


func apply_preferences() -> void:
	#will read preferences and apply these settings accordingly
	turn_on_vsync()
	
	#adjust_screen_size()
	adjust_fps_color()
	adjust_fps_display_location()
	adjust_fps_max()
	adjust_msaa()
	adjust_screen_resolution()
	
	
func adjust_fps_color() -> void:
	var fps_display: Label = ($FPSDisplay as Label)
	var color: Color
	match data.fps_color:
		"red":
			color = Color(255, 0, 0)
		"blue":
			color = Color(0, 0, 255)
		"green":
			color = Color(0, 255, 0)
	fps_display.add_color_override("font_color", color)
	

func adjust_fps_display_location() -> void:
	var fps_display: Label = ($FPSDisplay as Label)
		
	if data.fps_horizontal_location == "right":
		fps_display.align = HALIGN_RIGHT
	else:
		fps_display.align = HALIGN_LEFT
	if data.fps_vertical_location == "bottom":
		fps_display.valign = VALIGN_BOTTOM
	else:
		fps_display.valign = VALIGN_TOP


func adjust_fps_max() -> void:
	Engine.target_fps = data.max_fps
	
	
func adjust_msaa() -> void:
	(get_tree().get_root() as Viewport).set_msaa(int(data.msaa))
	
	
func adjust_screen_size() -> void:
	if data.window_type == "fullscreen":
		OS.window_fullscreen = true
		OS.window_borderless = false	
	# Borderless does not work perfectly and this is merely a workaround
	# Enable at your own risk
#	elif data.window_type == "borderless":
#		# 
#		OS.window_borderless = true
#		OS.window_fullscreen = false
#		OS.window_maximized = true
#		OS.window_size.y = OS.get_screen_size().y - 30
#		OS.window_position = Vector2(0,0)
	else:
		# if you want to specify exact dimensions here you go
		#OS.window_size = Vector2(data.window_size[0], data.window_size[1])
		OS.window_borderless = false
		OS.window_fullscreen = false
	

func adjust_screen_resolution() -> void:
	# if data.resolution is set to Native the resolution will auto adjust to
	# the windows current size
	var screen: Viewport = (get_tree().get_root() as Viewport)
	var resolution: Vector2
	match data.resolution:
		'2160p':
			resolution = Vector2(3840, 2160)
		'1440p':
			resolution = Vector2(2560, 1440)
		'1080p':
			resolution = Vector2(1920, 1080)
		'720p':
			resolution = Vector2(1280, 720)
		'480p':
			resolution = Vector2(720, 480)
		'360p':
			resolution = Vector2(480, 360)
		_:
			resolution = OS.get_window_size()
	
	if resolution.x > OS.get_window_size().x:
		screen.set_size(OS.get_window_size())
	elif resolution.y > OS.get_window_size().y:
		screen.set_size(OS.get_window_size())
	else:
		screen.set_size(resolution)
	

func calculate_volume(sound: float) -> float:
	var sound_volume: float = 26/25 * sound - 76
	return sound_volume


func create_preferences() -> void:
	var file: File = File.new()
	
	var keyboard_type: String = OS.get_latin_keyboard_variant()
	var controls_file
	if keyboard_type == "DVORAK":
		controls_file = "user://dvorak_controls.controls"
	else:
		controls_file = "user://standard_controls.controls"
		
	var _error = file.open("user://preferences.settings", File.WRITE)
	var save_dict: Dictionary = {
		"controls_file": controls_file,
		
		"do_display_fps": "Enabled",
		"vsync": "Enabled",
		"max_fps": 60,
		"fps_color": "red",
		"fps_horizontal_location": "left",
		"fps_vertical_location": "top",
		
		#music settings
		"is_music_muted": false,
		"is_game_muted": false,
		"master_volume_original": 50,
		"music_volume_original": 50,
		"player_volume_original": 50,
		"enemy_volume_original": 50,
		"item_volume_original": 50,
		"weather_volume_original": 50,
		
		#player settings
		"mouse_sensitivity": 50,
		"field_of_view": 90,
		
		#graphics settings
		"window_type": "windowed",
		"resolution": '1080p',
		"window_size": [1280, 720],
		"texture_quality": "High",
		"water_quality": "High",
		"shadow_quality": "High",
		
		"msaa": '0',
		"ssao": 0,
		"anisotropic_filtering": "Off",
		"motion_blur": false,
				
	}
	file.store_line(to_json(save_dict))
	file.close()
	save_dict.clear()
	

func display_fps() -> void:
	if data.do_display_fps == "Enabled":
		#fps_delay is a performance boost
		fps_delay -= 1
		if fps_delay == 0:
			FPSDisplay.text = str(Engine.get_frames_per_second())
			fps_delay = 10
	else:
		FPSDisplay.text = ""
		

func get_preferences() -> void:
	var file: File = File.new()
	if not file.file_exists("user://preferences.settings"):
		create_preferences()
	var _error := file.open("user://preferences.settings", File.READ)
	data = parse_json(file.get_line())	
	
	data.master_volume = calculate_volume(data.master_volume_original)
	data.music_volume = calculate_volume(data.music_volume_original)
	data.player_volume = calculate_volume(data.player_volume_original)
	data.enemy_volume = calculate_volume(data.enemy_volume_original)
	data.item_volume = calculate_volume(data.item_volume_original)
	data.weather_volume = calculate_volume(data.weather_volume_original)
	
			
func save_preferences() -> void:
	#changes all preferences
	var file: File = File.new()
	var _error = file.open("user://preferences.settings", File.WRITE)	
	file.store_line(to_json(data))
	file.close()


func turn_on_vsync() -> void:
	if data.vsync == "Disabled":
		OS.vsync_enabled = false
	else:
		OS.vsync_enabled = true
	
			
func update_sound_volume(group: String) -> void:
	get_tree().call_group(group, "update_volume")
			
					
	
			
			
			
