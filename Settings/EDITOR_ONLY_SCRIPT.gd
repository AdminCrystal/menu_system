extends Node


var standard_controls_key_verification: String
var dvorak_controls_key_verification: String





# will only run if it is not a release build
func _ready() -> void:
	if OS.is_debug_build():
		# will always create new preferences for testing
		Preferences.create_preferences()


func check_for_issues() -> void:
	var hash1: String = standard_controls_key_verification.sha256_text()
	var hash2: String = dvorak_controls_key_verification.sha256_text()
	
	if hash1 != hash2:
		print('ERROR... You have different dictionary keys in Controls.gd ' + 
				'create_standard_controls and create_dvorak_controls')
