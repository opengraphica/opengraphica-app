extends HistoryAction
class_name PageDeleteAction

var delete_page_id: int = -1
var previous_selected_page_id: int = -1
var previous_page_position: int = -1
var previous_page_definition: Dictionary

func _init(definition: Dictionary):
	id = HistoryAction.ID.PAGE_DELETE
	description = "Delete Page"
	delete_page_id = definition.id

func do():
	.do()
	for i in Workspace.working_file.pages.size():
		var page = Workspace.working_file.pages[i]
		if page.id == delete_page_id:
			previous_selected_page_id = Workspace.working_file.selected_page_id
			previous_page_position = i
			previous_page_definition = page
			Workspace.working_file.pages.remove(i)
			if Workspace.working_file.pages.size() == 0:
				Workspace.working_file.selected_page_id = null
			elif i > 0:
				Workspace.working_file.selected_page_id = Workspace.get_page_id_by_index(i - 1)
			else:
				Workspace.working_file.selected_page_id = Workspace.get_page_id_by_index(i)
			break

func undo():
	.undo()
	Workspace.working_file.pages.insert(previous_page_position, previous_page_definition)
	Workspace.working_file.selected_page_id = previous_selected_page_id
