extends Node

var current_document_id : String
var current_document_contents : String
var current_document_title : String

var documents = {}

@onready var theme : Theme = load("res://assets/themes/main_ui.tres")

func _ready():
	load_save()
	
	if not FileAccess.file_exists("noobsdoc.ini"):
		return
		
	var save = ConfigFile.new()
	save.load("noobsdoc.ini")
	documents = save.get_value("save", "documents", {})
	save_documents()

func load_document(document_id : String):
	load_save()
	current_document_id = document_id
	current_document_contents = documents[document_id].contents
	current_document_title = documents[document_id].title
	get_tree().change_scene_to_file("res://assets/prefab/document_page.tscn")

func load_save():
	if not FileAccess.file_exists("user://noobdocs.json"):
		return
	var file_access = FileAccess.open("user://noobdocs.json", FileAccess.READ)
	var json_string = file_access.get_line()
	file_access.close()
	var json = JSON.new()
	var error = json.parse(json_string)
	if error:
		return
	documents = json.data

func save_documents():
	var json_string = JSON.stringify(documents)
	var file_access = FileAccess.open("user://noobdocs.json", FileAccess.WRITE)
	if not file_access:
		return
	
	file_access.store_line(json_string)
	file_access.close()

func get_formatted_time_from_system():
	var time_dict = Time.get_datetime_dict_from_system()
	var year = str(time_dict.year)
	var month = str(time_dict.month)
	var day = str(time_dict.day)
	var hour = str(time_dict.hour)
	var minute = str(time_dict.minute)
	var second = str(time_dict.second)
	
	return year + "-" + month + "-" + day + " " + hour + "-" + minute + "-" + second
