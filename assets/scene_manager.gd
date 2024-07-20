extends Node

var current_document_id : String
var current_document_contents : String
var current_document_title : String

#var save = ConfigFile.new()
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
	#var err = save.load("noobsdoc.ini")
	#if err == 7:
		#save.save("noobsdoc.ini")
		#load_save()
	#if err != OK:
		#return
	#documents = save.get_value("save", "documents", {})
	
	if not FileAccess.file_exists("noobdocs.json"):
		return
	var file_access = FileAccess.open("noobdocs.json", FileAccess.READ)
	var json_string = file_access.get_line()
	file_access.close()
	var json = JSON.new()
	var error = json.parse(json_string)
	if error:
		return
	documents = json.data

func save_documents():
	#save.set_value("save", "documents", documents)
	#save.save("noobsdoc.ini")
	var json_string = JSON.stringify(documents)
	var file_access = FileAccess.open("noobdocs.json", FileAccess.WRITE)
	if not file_access:
		return
	
	file_access.store_line(json_string)
	file_access.close()
