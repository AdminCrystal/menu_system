extends Control

# determines whether this control should accept input
var accepting_input: bool = false
# the user supplied key to change control
var new_key: String = ''
# provides current controls button to change
var current_button: Button
# checks if any preferences were changed
var were_preferences_changed: bool = false


func _ready() -> void:
	self.visible = false
	update_all_controls_display()
	update_all_sounds_display()
	connect_all_buttons()
	
	were_preferences_changed = false


func _input(event: InputEvent) -> void:
	# gets user input and applys it to new_key
	if accepting_input:
		if event is InputEventKey:
			new_key = event.as_text()
			($ButtonChanger/Picture/Label as Label).text += new_key.to_lower()
			accepting_input = false
			get_tree().set_input_as_handled()


func change_fps_color(fps_color: Button) -> void:
	var name: String = fps_color.get_name()
	Preferences.data['fps_color'] = name
	disable_and_enable_children(fps_color)
	Preferences.adjust_fps_color()
	

func change_fps_display(fps_display: Button) -> void:
	var name: String = fps_display.get_name()
	Preferences.data['do_display_fps'] = name
	disable_and_enable_children(fps_display)	


func change_fps_location(fps_location: Button) -> void:
	var name: String = fps_location.get_name()
	if name == "top" or name == "bottom":
		Preferences.data["fps_vertical_location"] = name
	else:
		Preferences.data["fps_horizontal_location"] = name
	for child in fps_location.get_parent().get_children():
		var child_name: String = child.get_name()
		if child_name == "top" or child_name == "bottom":
			if child_name == Preferences.data["fps_vertical_location"]:
				child.disabled = true
			else:
				child.disabled = false
		else:
			if child_name == Preferences.data["fps_horizontal_location"]:
				child.disabled = true
			else:
				child.disabled = false
	Preferences.adjust_fps_display_location()
	were_preferences_changed = true


func change_fps_max(value: float, fps: HScrollBar) -> void:
	var name: String = fps.get_name()
	Preferences.data[name] = value
	fps.get_child(0).text = str(fps.value)
	Preferences.adjust_fps_max()
	were_preferences_changed = true
	

func change_msaa(msaa: Button) -> void:
	var name: String = msaa.get_name()
	Preferences.data['msaa'] = name
	disable_and_enable_children(msaa)
	Preferences.adjust_msaa()
	

func change_resolution(resolution: Button) -> void:
	var name: String = resolution.get_name()
	Preferences.data['resolution'] = name
	disable_and_enable_children(resolution)
	Preferences.adjust_screen_resolution()
	

func change_vsync(vsync: Button) -> void:
	var name: String = vsync.get_name()
	Preferences.data['vsync'] = name
	disable_and_enable_children(vsync)
	Preferences.turn_on_vsync()
	Preferences.adjust_fps_max()
	

func change_window_size(window_type: Button) -> void:
	var name: String = window_type.get_name()
	Preferences.data["window_type"] = name
	disable_and_enable_children(window_type)
	Preferences.adjust_screen_size()
	

func connect_all_buttons() -> void:
	# connects control buttons
	for child in $VBoxContainer/SettingsRow/ControlsScroller/ControlsContainer/Controls.get_children():
		child.connect('pressed', self, '_on_UpdateControl_pressed', [child])
		
	# conects sound buttons
	for child in $VBoxContainer/SettingsRow/SoundScroller/SoundContainer/Sounds.get_children():
		child.connect('value_changed', self, '_on_UpdateSound_pressed', [child])
		
	connect_graphics_buttons()


func connect_children(parent: HBoxContainer, function_name: String) -> void:
	var preference = parent.get_name()
	
	for child in parent.get_children():
		child = child as Button
		if child.get_name() == Preferences.data[preference]:
			child.disabled = true
		child.connect('pressed', self, function_name, [child])	


func connect_graphics_buttons() -> void:
	var container = $VBoxContainer/SettingsRow/GraphicsScroller/GraphicsContainer/Graphics
	
	var window_type_options = container.get_child(0)
	var resolution_options = container.get_child(1)
	var msaa_options = container.get_child(2)
	var vsync_options = container.get_child(3)
	var max_fps_options = container.get_child(4).get_child(0)
	var display_fps_options = container.get_child(5)
	var fps_location_options = container.get_child(6)
	var fps_color_options = container.get_child(7)

	connect_children(window_type_options, "change_window_size")	
	connect_children(resolution_options, "change_resolution")
	connect_children(msaa_options, "change_msaa")
	connect_children(vsync_options, "change_vsync")
	connect_children(display_fps_options, "change_fps_display")
	connect_children(fps_color_options, "change_fps_color")
	
	max_fps_options.connect('value_changed', self, "change_fps_max", [max_fps_options])
	max_fps_options.value = Preferences.data["max_fps"]
	
	for child in fps_location_options.get_children():
		child.connect('pressed', self, "change_fps_location", [child])
		
	for child in fps_location_options.get_children():
		var child_name: String = child.get_name()
		if child_name == "top" or child_name == "bottom":
			if child_name == Preferences.data["fps_vertical_location"]:
				child.disabled = true
			else:
				child.disabled = false
		else:
			if child_name == Preferences.data["fps_horizontal_location"]:
				child.disabled = true
			else:
				child.disabled = false
			
	
func disable_and_enable_children(parent: Button) -> void:
	var name: String = parent.get_name()
	for child in parent.get_parent().get_children():
		if child.get_name() == name:
			child.disabled = true
		else:
			child.disabled = false
	were_preferences_changed = true
		

func display_preset_children(visible: bool) -> void:
	for child in $VBoxContainer/PresetsRow.get_children():
		child.visible = visible
		

func save_preferences() -> void:
	# will update preferences file if changes were made
	if were_preferences_changed:
		Preferences.save_preferences()
		were_preferences_changed = false
		

func update_all_controls_display() -> void:
	for child in $VBoxContainer/SettingsRow/ControlsScroller/ControlsContainer/Controls.get_children():
		update_control_display(child)


func update_all_sounds_display() -> void:
	for child in $VBoxContainer/SettingsRow/SoundScroller/SoundContainer/Sounds.get_children():
		child = (child as HScrollBar)
		_on_UpdateSound_pressed(Preferences.data[child.get_name()], child)
		child.value = Preferences.data[child.get_name()]
		

func _on_UpdateControl_pressed(button: Button) -> void:
	current_button = button
	($ButtonChanger as Button).visible = true
	accepting_input = true
	

func update_control_display(button: Button) -> void:
	# gets the saved controls and puts that as the text
	button.text = Controls.controls[button.get_name()].to_lower()
			

func _on_UpdateSound_pressed(value: float, scroller: HScrollBar) -> void:
	var label: Label = scroller.get_child(0)
	label.text = str(value)
	were_preferences_changed = true
	var key: String = scroller.get_name()
	var other_key: String = key.substr(0, -10)
	Preferences.data[key] = value
	Preferences.data[other_key] = Preferences.calculate_volume(Preferences.data[key])
	

func _on_BackButton_pressed() -> void:
	self.visible = false
	Menu.visible = true
	($ButtonChanger/Picture as TextureRect).visible = false
	accepting_input = false
	save_preferences()
	

func _on_Cancel_pressed() -> void:
	($ButtonChanger as Button).visible = false
	($ButtonChanger/Picture/Label as Label).text = "Push Button\n"
	accepting_input = false
	

func _on_CloseMenus_pressed() -> void:
	self.visible = false
	($ButtonChanger/Picture as TextureRect).visible = false
	accepting_input = false
	save_preferences()
	

func _on_Confirm_pressed() -> void:
	($ButtonChanger as Button).visible = false
	if !accepting_input:
		were_preferences_changed = true
		var controls_file: String = "user://custom_controls.controls"
		Controls.change_control(current_button.get_name(), new_key, controls_file)
		Controls.set_controls(controls_file)
		update_control_display(current_button)
		($ButtonChanger/Picture/Label as Label).text = "Push Button\n"
	accepting_input = false
	

func _on_Controls_pressed() -> void:
	$VBoxContainer/SettingsRow/GraphicsScroller.visible = false
	$VBoxContainer/SettingsRow/SoundScroller.visible = false
	$VBoxContainer/SettingsRow/ControlsScroller.visible = true
	display_preset_children(true)
	

func _on_CustomControls_pressed() -> void:
	var controls_file = "user://custom_controls.controls"
	Controls.set_controls("user://custom_controls.controls")
	Preferences.data.controls_file = controls_file
	update_all_controls_display()
	were_preferences_changed = true
	

func _on_DvorakControls_pressed() -> void:
	var controls_file = "user://dvorak_controls.controls"
	Controls.set_controls(controls_file)
	Preferences.data.controls_file = controls_file
	were_preferences_changed = true
	update_all_controls_display()
	

func _on_Graphics_pressed() -> void:
	$VBoxContainer/SettingsRow/ControlsScroller.visible = false
	$VBoxContainer/SettingsRow/SoundScroller.visible = false
	$VBoxContainer/SettingsRow/GraphicsScroller.visible = true
	display_preset_children(false)
	

func _on_Sound_pressed() -> void:
	$VBoxContainer/SettingsRow/GraphicsScroller.visible = false
	$VBoxContainer/SettingsRow/ControlsScroller.visible = false
	$VBoxContainer/SettingsRow/SoundScroller.visible = true
	display_preset_children(false)
	

func _on_StandardControls_pressed() -> void:
	var controls_file = "user://standard_controls.controls"
	Controls.set_controls(controls_file)
	Preferences.data.controls_file = controls_file
	were_preferences_changed = true
	update_all_controls_display()



	
