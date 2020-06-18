extends HistoryAction
class_name ArtboardCreateAction

var artboard_id: int
var artboard_definition: Dictionary
var previous_selected_artboard_id

func _init(definition: Dictionary):
	id = HistoryAction.ID.ARTBOARD_CREATE
	description = "Create Artboard"
	artboard_definition = definition

func do():
	.do()
	previous_selected_artboard_id = Workspace.working_file.selected_artboard_id
	artboard_id = Workspace.working_file.artboard_id_counter
	Workspace.working_file.artboard_id_counter += 1
	Workspace.working_file.selected_artboard_id = artboard_id
	var selected_page = Workspace.get_selected_page()
	if selected_page:
		selected_page.artboards.push_back({
			"id": artboard_id,
			"display_name": artboard_definition.display_name if artboard_definition.has("display_name") else "Artboard " + str(artboard_id + 1),
			"children": [],
		})

func undo():
	.undo()
	Workspace.working_file.selected_artboard_id = previous_selected_artboard_id
	Workspace.working_file.artboard_id_counter -= 1
	var selected_page = Workspace.get_selected_page()
	if selected_page:
		for i in selected_page.artboards.size():
			var artboard = selected_page.artboards[i]
			if artboard.id == artboard_id:
				selected_page.artboards.remove(i)
				break
