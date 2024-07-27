extends Control

@onready var document_card : PackedScene = load("res://assets/prefab/document_card.tscn")
@onready var contents : Control = $UiMargain/MainContainer/ContentsScroll/Contents
@onready var confirm_delete_dialog : ConfirmDeleteDialog = $ConfirmDeleteDialog

func _ready():
	SceneManager.load_save()
	
	for document_key in SceneManager.documents:
		create_document_card(false, SceneManager.documents[document_key].title, SceneManager.documents[document_key].hash)
	
	$UiMargain/MainContainer/SearchBar.grab_focus()

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
	SceneManager.documents[document_hash] = {"title": title, "contents": "", "hash": document_hash, "time_of_modification": SceneManager.get_formatted_time_from_system()}
	SceneManager.save_documents()
	open_document(document_hash)

func open_document(document_id : String):
	SceneManager.load_document(document_id)
	
func delete_document(document_id : String, card_path : String):
	confirm_delete_dialog.popup()
	confirm_delete_dialog.document_id = document_id
	confirm_delete_dialog.documents = SceneManager.documents
	confirm_delete_dialog.card_path = card_path

func _on_confirm_delete_dialog_confirmed():
	SceneManager.documents.erase(confirm_delete_dialog.document_id)
	SceneManager.save_documents()
	get_node(confirm_delete_dialog.card_path).queue_free()

func _on_backup_button_pressed():
	if FileAccess.file_exists("user://noobdocs.json"):
		DirAccess.copy_absolute("user://noobdocs.json", "backup_" + str(Time.get_unix_time_from_system()) + "_noobdocs.json")
	

func _on_delete_databasebutton_pressed():
	$ConfirmDatabaseDeletion.show_confirmation()

func _on_search_bar_text_changed(new_text):
	for child in contents.get_children():
		child.queue_free()
	if new_text.is_empty():
		for document_key in SceneManager.documents:
			create_document_card(false, SceneManager.documents[document_key].title, SceneManager.documents[document_key].hash)
		return
	for document_key in SceneManager.documents:
		if SceneManager.documents[document_key].title.findn(new_text) != -1:
			create_document_card(false, SceneManager.documents[document_key].title, SceneManager.documents[document_key].hash)
