extends Control

var save = ConfigFile.new()

@onready var editor = $DocumentMargain/MainContainer/EditorScroll/EditorViewer/Editor
@onready var label = $DocumentMargain/MainContainer/EditorScroll/EditorViewer/MarkdownLabel
@onready var title = $DocumentMargain/MainContainer/TopBar/DocumentName

func _ready():
	editor.text = SceneManager.current_document_contents
	label.markdown_text = SceneManager.current_document_contents
	title.text = SceneManager.current_document_title

func _process(delta):
	if Input.is_action_pressed("modifier") and Input.is_action_just_pressed("s"):
		save_file()

func _on_save_button_pressed():
	save_file()

func save_file():
	SceneManager.documents[SceneManager.current_document_id].title = title.text
	SceneManager.documents[SceneManager.current_document_id].contents = editor.text
	SceneManager.save_documents()

func _on_editor_text_changed():
	label.markdown_text = editor.text

func _on_home_button_pressed():
	get_tree().change_scene_to_file("res://main_ui.tscn")

func _on_menu_button_item_selected(index):
	match index:
		0:
			label.hide()
			editor.show()
		1:
			label.show()
			editor.hide()
		2:
			label.show()
			editor.show()
