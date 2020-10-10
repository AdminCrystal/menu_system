extends Node


var controls: Dictionary
	
func change_control(key: String, value: String, controls_file: String) -> void:
	var file: File = File.new()
	var _error
	
	if controls.empty():
		if not file.file_exists(controls_file):
			#gets current controls file
			_error = file.open("user://preferences.settings", File.READ)
			controls = parse_json(file.get_line())
			file.close()
			
			#opens that file and copys its json
			_error = file.open(controls.controls_file, File.READ)
			controls = parse_json(file.get_line())
			file.close()
			
			#creates new customControls file
			_error = file.open(controls_file, File.WRITE)
		else:	
			#opens custom controls file and copys its json	
			_error = file.open(controls_file, File.READ)
			controls = parse_json(file.get_line())
		file.close()
	
	controls[key] = value
	
	_error = file.open(controls_file, File.WRITE)
	file.store_line(to_json(controls))
	file.close()
	
	
#recreates fresh dvorak controls when they open the game
func create_dvorak_controls() -> void:
	var file: File = File.new()
	#if not saveControls.file_exists("user://preferences.settings"):
	var _error = file.open("user://dvorak_controls.controls", File.WRITE)
	var save_dict: Dictionary = {
		#Defaults
		"move_forward": "Comma",
		"move_left": "a",
		"move_backward": "o",
		"move_right": "e",
		"jump": "Space",
		"open_menu": "Escape",
		"interact": "Period",
		
		"up_arrow": "Up",
		"left_arrow": "Left",
		"down_arrow": "Down",
		"right_arrow": "Right",
		#End Defaults
		
		
		#Mouse actions
		"left_click": "LeftClick",
		"right_click": "RightClick",
		"scroll_up": "ScrollWheelUp",
		"scroll_down": "ScrollWheelDown",
		"scroll_left": "ScrollWheelLeft",
		"scroll_right": "ScrollWheelRight",
		#End Mouse Actions
		

		#Row 0 (function keys)
		"f1": "F1",
		"f2": "F2",
		"f3": "F3",
		"f4": "F4",
		"f5": "F5",
		"f6": "F6",
		"f7": "F7",
		#WARNING
		#f8 closes editor
		#"f8": "F8",
		"f9": "F9",
		"f10": "F10",
		"f11": "F11",
		"f12": "F12",
		"insert": "Insert",
		"delete": "Delete",
		#End Row 0 (function keys)


		#WARNING 
		#MISSING TILDE
		#Row 1
		"hotbar1": "1",
		"hotbar2": "2",
		"hotbar3": "3",
		"hotbar4": "4",
		"hotbar5": "5",
		"hotbar6": "6",
		"hotbar7": "7",
		"hotbar8": "8",
		"hotbar9": "9",
		"hotbar0": "0",
		"minus": "BraceLeft",
		"equals": "BraceRight",
		"backspace": "BackSpace",
		#End Row 1
		
		
		#Row 2
		"tab": "Tab",
		"q": "Apostrophe",
		"w": "Comma",
		"e": "Period",
		"r": "p",
		"t": "y",
		"y": "f",
		"u": "g",
		"i": "c",
		"o": "r",
		"p": "l",
		"left_brace": "Slash",
		"right_brace": "Equal",
		"backslash": "BackSlash",
		#End Row 2
		
		
		#Row 3
		"caps_lock": "Capslock",
		"a": "a",
		"s": "o",
		"d": "e",
		"f": "u",
		"g": "i",
		"h": "d",
		"j": "h",
		"k": "t",
		"l": "n",
		"semicolon": "s",
		"apostrophe": "Minus",
		"enter": "Enter",
		#End Row 3
		
		
		#Row 4
		"shift": "Shift",
		"z": "SemiColon",
		"x": "q",
		"c": "j",
		"v": "k",
		"b": "x",
		"n": "b",
		"m": "m",
		"comma": "w",
		"period": "v",
		"forward_slash": "z",
		#End Row 4
		
		
		#Row 5
		"ctrl": "Control",
		"alt": "Alt",
		"space": "Space",
		#End Row 5
		
		
		#Special keys (right side of keyboard)
		"home": "Home",
		#WARNING
		#Print screen input might be undetectable for users
		#"print_screen": "Print",
		"volume_mute": "VolumeMute",
		"volume_down": "VolumeDown",
		"volume_up": "VolumeUp",
		
		"page_up": "PageUp",
		#WARNING
		#asterisk and plus may be undetectable
		#"asterisk": "Asterisk",
		#"plus": "Plus",
		
		"page_down": "PageDown",
		"end": "End",
		
	}
	file.store_line(to_json(save_dict))
	file.close()
	
	# verifies keys are same
	if OS.is_debug_build():
		for key in save_dict.keys():
			EDITOR_ONLY_SCRIPT.dvorak_controls_key_verification += key
	save_dict.clear()
	
	

# recreates fresh standard controls every time they open the game
func create_standard_controls() -> void:
	var save_dict: Dictionary = {
		"move_forward": "w",
		"move_left": "a",
		"move_backward": "s",
		"move_right": "d",
		"jump": "Space",
		"open_menu": "Escape",
		"interact": "e",
		
		"up_arrow": "Up",
		"left_arrow": "Left",
		"down_arrow": "Down",
		"right_arrow": "Right",
		#End Defaults
		
	
		#Mouse actions
		"left_click": "LeftClick",
		"right_click": "RightClick",
		"scroll_up": "ScrollWheelUp",
		"scroll_down": "ScrollWheelDown",
		"scroll_left": "ScrollWheelLeft",
		"scroll_right": "ScrollWheelRight",
		#End Mouse Actions
		

		#Row 0 (function keys)
		"f1": "F1",
		"f2": "F2",
		"f3": "F3",
		"f4": "F4",
		"f5": "F5",
		"f6": "F6",
		"f7": "F7",
		#WARNING
		#f8 closes editor
		#"f8": "F8",
		"f9": "F9",
		"f10": "F10",
		"f11": "F11",
		"f12": "F12",
		"insert": "Insert",
		"delete": "Delete",
		#End Row 0 (function keys)


		#WARNING 
		#MISSING TILDE
		#Row 1
		"hotbar1": "1",
		"hotbar2": "2",
		"hotbar3": "3",
		"hotbar4": "4",
		"hotbar5": "5",
		"hotbar6": "6",
		"hotbar7": "7",
		"hotbar8": "8",
		"hotbar9": "9",
		"hotbar0": "0",
		"minus": "Minus",
		"equals": "Equal",
		"backspace": "BackSpace",
		#End Row 1
		
		
		#Row 2
		"tab": "Tab",
		"q": "q",
		"w": "w",
		"e": "e",
		"r": "r",
		"t": "t",
		"y": "y",
		"u": "u",
		"i": "i",
		"o": "o",
		"p": "p",
		"left_brace": "BraceLeft",
		"right_brace": "BraceRight",
		"backslash": "BackSlash",
		#End Row 2
		
		
		#Row 3
		"caps_lock": "Capslock",
		"a": "a",
		"s": "s",
		"d": "d",
		"f": "f",
		"g": "g",
		"h": "h",
		"j": "j",
		"k": "k",
		"l": "l",
		"semicolon": "SemiColon",
		"apostrophe": "Apostrophe",
		"enter": "Enter",
		#End Row 3
		
		
		#Row 4
		"shift": "Shift",
		"z": "z",
		"x": "x",
		"c": "c",
		"v": "v",
		"b": "b",
		"n": "n",
		"m": "m",
		"comma": "Comma",
		"period": "Period",
		"forward_slash": "Slash",
		#End Row 4
		
		
		#Row 5
		"ctrl": "Control",
		"alt": "Alt",
		"space": "Space",
		#End Row 5
		
		
		#Special keys (right side of keyboard)
		"home": "Home",
		#WARNING
		#Print screen input might be undetectable for users
		#"printScreen": "Print",
		"volume_mute": "VolumeMute",
		"volume_down": "VolumeDown",
		"volume_up": "VolumeUp",
		
		"page_up": "PageUp",
		#WARNING
		#asterisk and plus may be undetectable
		#"asterisk": "Asterisk",
		#"plus": "Plus",
		
		"page_down": "PageDown",
		"end": "End",
		
		
	}
	var file: File = File.new()
	var _error = file.open("user://standard_controls.controls", File.WRITE)
	file.store_line(to_json(save_dict))
	file.close()
	
	# creates a placeholder custom controls file
	_error = file.open("user://custom_controls.controls", File.WRITE)
	file.store_line(to_json(save_dict))
	file.close()
	
	# checks to make sure keys are correct
	if OS.is_debug_build():
		for key in save_dict.keys():
			EDITOR_ONLY_SCRIPT.standard_controls_key_verification += key
	save_dict.clear()
	

#gets which control file holds their controls
func get_controls() -> String:
	var file: File = File.new()
	#checks to make sure if file exists and if it
	#doesnt creates a new one, theoretically 'impossible'
	if not file.file_exists("user://preferences.settings"):
		Preferences.create_preferences()
	var _error = file.open("user://preferences.settings", File.READ)
	var data: Dictionary = parse_json(file.get_line())
	file.close()
	
	var location: String = data.controls_file
	data.clear()
	return location


#changes the controls to the users preferred
func set_controls(filepath: String) -> void:
	var file: File = File.new()
	var _error = file.open(filepath, File.READ)
	
	#this resets the InputMap to default meaning
	#that if the controls are changed there will
	#not be multiple keys per InputMap
	InputMap.load_from_globals()
	controls = parse_json(file.get_line()) 
	
	for i in range(controls.size()):
		var keycode = InputEventKey.new()
		keycode.scancode = OS.find_scancode_from_string(controls.values()[i])
		
		#WARNING
		#match in gdscript is the same speed as if elif
		#Checks if there is an error code (aka mouse buttons)
		if keycode.scancode != 0:
			pass
		else:
			keycode = InputEventMouseButton.new()
			match controls.values()[i]:
				"LeftClick": 
					keycode.button_index = BUTTON_LEFT
				"RightClick":
					keycode.button_index = BUTTON_RIGHT
				"MiddleClick":
					keycode.button_index = BUTTON_MIDDLE
				"ScrollWheelUp":
					keycode.button_index = BUTTON_WHEEL_UP
				"ScrollWheelDown":
					keycode.button_index = BUTTON_WHEEL_DOWN
				"ScrollWheelLeft":
					keycode.button_index = BUTTON_WHEEL_LEFT
				"ScrollWheelRight":
					keycode.button_index = BUTTON_WHEEL_RIGHT
				_:	
					print("Error on control creation key = " + controls.values()[i])
				
		InputMap.add_action(controls.keys()[i])
		InputMap.action_add_event(controls.keys()[i], keycode)
	
	file.close()
	



