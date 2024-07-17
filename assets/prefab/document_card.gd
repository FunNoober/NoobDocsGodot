class_name DocumentCard
extends HBoxContainer

var document_id : String
var document_title : String

signal OpenDocument(id : String)
signal DeleteDocument(id : String, self_path : String)

func new_document_card(new_id, new_title):
	document_id = new_id
	document_title = new_title
	$OpenDocumentButton.text = document_title

func _on_delete_document_button_pressed():
	DeleteDocument.emit(document_id, get_path())

func _on_open_document_button_pressed():
	OpenDocument.emit(document_id)
