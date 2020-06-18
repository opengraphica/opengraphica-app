extends HistoryAction
class_name PageSelectAction

var selected_page_id: int
var previous_selected_page_id
var previous_selected_artboard_id

func _init(definition: Dictionary):
	id = HistoryAction.ID.PAGE_SELECT
	description = "Select Page"
	selected_page_id = definition.id

func do():
	.do()
	previous_selected_page_id = Workspace.working_file.selected_page_id
	previous_selected_artboard_id = Workspace.working_file.selected_artboard_id
	Workspace.working_file.selected_page_id = selected_page_id
	var selected_page = Workspace.get_selected_page()
	if selected_page.artboards.size() > 0:
		Workspace.working_file.selected_artboard_id = Workspace.get_artboard_id_by_index(0)

func undo():
	.undo()
	Workspace.working_file.selected_page_id = previous_selected_page_id
	Workspace.working_file.selected_artboard_id = previous_selected_artboard_id
