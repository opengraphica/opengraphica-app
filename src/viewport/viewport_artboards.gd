extends Control

var no_pages_prompt: CenterContainer
var artboards_container: Node2D

func _ready():
	no_pages_prompt = $NoPagesPrompt
	artboards_container = $Artboards
	
	no_pages_prompt.visible = true
	artboards_container.visible = false
	
	$NoPagesPrompt/VBoxContainer/AddPageButton.connect("pressed", self, "_add_page_pressed")
	
	Workspace.connect("history_change", self, "_history_change")

func _history_change(action: HistoryAction):
	if [
		HistoryAction.ID.FILE_CREATE, HistoryAction.ID.PAGE_CREATE,
		HistoryAction.ID.PAGE_DELETE, HistoryAction.ID.PAGE_SELECT,
	].has(action.id):
		var selected_page = Workspace.get_selected_page()
		no_pages_prompt.visible = true if not selected_page else false
		artboards_container.visible = true if selected_page else false
			

func _add_page_pressed():
	Workspace.do_action(
		PageCreateAction.new({})
	)
