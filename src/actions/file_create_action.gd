extends HistoryAction
class_name FileCreateAction

var previous_working_file

func _init():
	id = HistoryAction.ID.FILE_CREATE
	description = "Create File"

func do():
	.do()
	previous_working_file = Workspace.working_file
	Workspace.working_file = {
		"filename": "new_file",
		"extension": "opgr",
		"page_id_counter": 0,
		"artboard_id_counter": 0,
		"selected_page_id": null,
		"selected_artboard_id": null,
		"pages": [],
		"resources": [],
	}

func undo():
	.undo()
	Workspace.working_file = previous_working_file
