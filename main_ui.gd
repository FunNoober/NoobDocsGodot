extends Control

@onready var document_card : PackedScene = load("res://assets/prefab/document_card.tscn")
@onready var contents : Control = $UiMargain/MainContainer/ContentsScroll/Contents

var documents = {}

var save = ConfigFile.new()

func _ready():
	load_save()
	
	for document_key in documents:
		create_document_card(false, documents[document_key].title, documents[document_key].hash)
	
func load_save():
	var err = save.load("noobsdoc.ini")
	if err == 7:
		save.save("noobsdoc.ini")
		load_save()
	if err != OK:
		return
	documents = save.get_value("save", "documents", {})

func _on_create_button_pressed():
	create_document_card(true, "New Document", "")

func create_document_card(save_new : bool, title : String, document_hash : String):
	var new_document_card : DocumentCard = document_card.instantiate()
	contents.add_child(new_document_card)
	if document_hash.is_empty():
		document_hash = str(Time.get_unix_time_from_system()).sha256_text()
	new_document_card.new_document_card(document_hash, title)
	new_document_card.connect("OpenDocument", open_document)
	new_document_card.connect("DeleteDocument", delete_document)
	if save_new == false:
		return
	documents[document_hash] = {"title": title, "contents": "", "hash": document_hash}
	save.set_value("save", "documents", documents)
	save.save("noobsdoc.ini")

func open_document(document_id : String):
	SceneManager.load_document(document_id)
	
func delete_document(document_id : String):
	documents.erase(document_id)
	save.set_value("save", "documents", documents)
	save.save("noobsdoc.ini")
