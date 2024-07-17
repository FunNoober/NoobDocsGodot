extends Node

var current_document_id : String
var current_document_contents : String
var current_document_title : String

var save = ConfigFile.new()
var documents = {}

func _ready():
	load_save()

func load_document(document_id : String):
	load_save()
	current_document_id = document_id
	current_document_contents = documents[document_id].contents
	current_document_title = documents[document_id].title
	get_tree().change_scene_to_file("res://assets/prefab/document_page.tscn")

func load_save():
	var err = save.load("noobsdoc.ini")
	if err == 7:
		save.save("noobsdoc.ini")
		load_save()
	if err != OK:
		return
	documents = save.get_value("save", "documents", {})

func save_documents():
	save.set_value("save", "documents", documents)
	save.save("noobsdoc.ini")
