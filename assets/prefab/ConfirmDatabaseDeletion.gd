extends Window

var code : int

func show_confirmation():
	popup()
	randomize()
	code = randi_range(10000, 99999)
	$DialogMargain/Contents/CodeLabel.text = str(code)

func _process(delta):
	if $DialogMargain/Contents/CodeEnter.text != str(code):
		$DialogMargain/Contents/Buttons/ConfirmButton.disabled = true
	else:
		$DialogMargain/Contents/Buttons/ConfirmButton.disabled = false

func _on_close_requested():
	hide()

func _on_cancel_button_pressed():
	hide()

func _on_confirm_button_pressed():
	var dir = DirAccess.open("user://")
	if dir.file_exists("user://noobdocs.json") == false:
		hide()
		return
	var err = dir.remove("noobdocs.json")
	SceneManager.documents = {}
	get_tree().change_scene_to_file("res://main_ui.tscn")
