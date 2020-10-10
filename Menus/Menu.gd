extends Control





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false


func _on_CloseMenu_pressed() -> void:
	self.visible = false


func _on_Settings_pressed() -> void:
	self.visible = false
	SettingsMenu.visible = true
	SettingsMenu.update_all_controls_display()


func _on_Quit_pressed() -> void:
	get_tree().quit()
