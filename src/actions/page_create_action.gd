extends HistoryAction
class_name PageCreateAction

var page_id: int
var page_definition: Dictionary
var previous_selected_page_id

func _init(definition: Dictionary):
	id = HistoryAction.ID.PAGE_CREATE
	description = "Create Page"
	page_definition = definition

func do():
	.do()
	previous_selected_page_id = Workspace.working_file.selected_page_id
	page_id = Workspace.working_file.page_id_counter
	Workspace.working_file.page_id_counter += 1
	Workspace.working_file.selected_page_id = page_id
	Workspace.working_file.pages.push_back({
		"id": page_id,
		"display_name": page_definition.display_name if page_definition.has("display_name") else "Page " + str(page_id + 1),
		"artboards": [],
	})

func undo():
	.undo()
	Workspace.working_file.selected_page_id = previous_selected_page_id
	Workspace.working_file.page_id_counter -= 1
	for i in Workspace.working_file.pages.size():
		var page = Workspace.working_file.pages[i]
		if page.id == page_id:
			Workspace.working_file.pages.remove(i)
			break
