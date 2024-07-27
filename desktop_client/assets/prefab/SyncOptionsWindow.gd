extends Window

var options = {}

func _ready():
	load_options()

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

func _on_save_as_remote_pressed():
	options.remote = $MarginContainer/Lines/RemoteEdit.text
	var json_string = JSON.stringify(options)
	var file_access = FileAccess.open("user://sync_options.json", FileAccess.WRITE)
	if not file_access:
		return
	file_access.store_line(json_string)
	file_access.close()

func _on_close_requested():
	hide()

func _on_pull_button_pressed():
	$PullRequest.request("http://" + options.remote + "/pull")

func _on_push_button_pressed():
	var json = JSON.stringify(SceneManager.documents)
	var headers = ["Content-Type: application/json"]
	$PushRequest.request("http://" + options.remote + "/push", headers, HTTPClient.METHOD_POST, json)

func _on_pull_request_request_completed(result, response_code, headers, body):
	var json_string = body.get_string_from_utf8()
	var json = JSON.new()
	var err = json.parse(json_string)
	if err:
		return
	SceneManager.documents = json.data.documents
	SceneManager.save_documents()
	get_tree().change_scene_to_file("res://main_ui.tscn")

func _on_push_request_request_completed(result, response_code, headers, body):
	print(body.get_string_from_utf8())
