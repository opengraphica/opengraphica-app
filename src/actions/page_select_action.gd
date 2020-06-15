extends HistoryAction
class_name PageSelectAction

var selected_page_id: int
var previous_selected_page_id

func _init(definition: Dictionary):
	id = HistoryAction.ID.PAGE_SELECT
	description = "Select Page"
	selected_page_id = definition.id

func do():
	.do()
	previous_selected_page_id = Workspace.working_file.selected_page_id
	Workspace.working_file.selected_page_id = selected_page_id

func undo():
	.undo()
	Workspace.working_file.selected_page_id = previous_selected_page_id

