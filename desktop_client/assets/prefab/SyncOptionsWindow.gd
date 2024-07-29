extends Window

var options = {}

func _ready():
	load_options()
	$MarginContainer/PushSuccessfulPopup/AnimationPlayer.play("RESET")
	$MarginContainer/RemoteSavedPopup/AnimationPlayer.play("RESET")

func load_options():
	if not FileAccess.file_exists("user://sync_options.json"):
		return
	var file_access = FileAccess.open("user://sync_options.json", FileAccess.READ)
	var json_string = file_access.get_line()
	file_access.close()
	var json := JSON.new()
	var err = json.parse(json_string)
	if err:
		return
	options = json.data
	$MarginContainer/Lines/RemoteEdit.text = options.remote
	$MarginContainer/Lines/SecurityTokenEdit.text = options.security_token

func _on_save_as_remote_pressed():
	options.remote = $MarginContainer/Lines/RemoteEdit.text
	options.security_token = $MarginContainer/Lines/SecurityTokenEdit.text
	var json_string = JSON.stringify(options)
	var file_access = FileAccess.open("user://sync_options.json", FileAccess.WRITE)
	if not file_access:
		return
	file_access.store_line(json_string)
	file_access.close()
	$MarginContainer/RemoteSavedPopup/AnimationPlayer.play("ShowPushNotification")

func _on_close_requested():
	hide()

func _on_pull_button_pressed():
	var headers = ["Security-Token: " + $MarginContainer/Lines/SecurityTokenEdit.text]
	$PullRequest.request("http://" + options.remote + "/pull", headers)

func _on_push_button_pressed():
	var json = JSON.stringify(SceneManager.documents)
	var headers = ["Content-Type: application/json", "Security-Token:" + $MarginContainer/Lines/SecurityTokenEdit.text]
	$PushRequest.request("http://" + options.remote + "/push", headers, HTTPClient.METHOD_POST, json)

func _on_pull_request_request_completed(result, response_code, headers, body):
	if str(response_code) == "401":
		$MarginContainer/PushSuccessfulPopup/Label.text = "Invalid Security Token"
		$MarginContainer/PushSuccessfulPopup/AnimationPlayer.play("ShowPushNotification")
		return
	var json_string = body.get_string_from_utf8()
	var json = JSON.new()
	var err = json.parse(json_string)
	if err:
		return
	SceneManager.documents = json.data.documents
	SceneManager.save_documents()
	get_tree().change_scene_to_file("res://main_ui.tscn")

func _on_push_request_request_completed(result, response_code, headers, body):
	if str(response_code) == "401":
		$MarginContainer/PushSuccessfulPopup/Label.text = "Invalid Security Token"
		$MarginContainer/PushSuccessfulPopup/AnimationPlayer.play("ShowPushNotification")
		return
	if body.get_string_from_utf8() == "Database received":
		$MarginContainer/PushSuccessfulPopup/Label.text = "Push Successful"
		$MarginContainer/PushSuccessfulPopup/AnimationPlayer.play("ShowPushNotification")
