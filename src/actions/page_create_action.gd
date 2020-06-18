extends HistoryAction
class_name PageCreateAction

const artboard_enums =  preload("res://src/enums/artboard.gd")
const ARTBOARD_DISPLAY_LAYOUT = artboard_enums.ARTBOARD_DISPLAY_LAYOUT
const ARTBOARD_DISPLAY_ALIGNMENT = artboard_enums.ARTBOARD_DISPLAY_ALIGNMENT

var page_id: int
var page_definition: Dictionary
var previous_selected_artboard_id
var previous_selected_page_id

func _init(definition: Dictionary):
	id = HistoryAction.ID.PAGE_CREATE
	description = "Create Page"
	page_definition = definition

func do():
	.do()
	previous_selected_page_id = Workspace.working_file.selected_page_id
	previous_selected_artboard_id = Workspace.working_file.selected_artboard_id
	page_id = Workspace.working_file.page_id_counter
	Workspace.working_file.page_id_counter += 1
	Workspace.working_file.selected_page_id = page_id
	Workspace.working_file.selected_artboard_id = null
	Workspace.working_file.pages.push_back({
		"id": page_id,
		"display_name": page_definition.display_name if page_definition.has("display_name") else "Page " + str(page_id + 1),
		"artboard_display_layout": page_definition.artboard_display_layout if page_definition.has("artboard_display_layout") else ARTBOARD_DISPLAY_LAYOUT.HORIZONTAL,
		"artboard_display_alignment": page_definition.artboard_display_alignment if page_definition.has("artboard_display_alignment") else ARTBOARD_DISPLAY_ALIGNMENT.TOP,
		"artboard_display_spacing": page_definition.artboard_display_spacing if page_definition.has("artboard_display_spacing") else 100,
		"artboards": [],
	})

func undo():
	.undo()
	Workspace.working_file.selected_page_id = previous_selected_page_id
	Workspace.working_file.selected_artboard_id = previous_selected_artboard_id
	Workspace.working_file.page_id_counter -= 1
	for i in Workspace.working_file.pages.size():
		var page = Workspace.working_file.pages[i]
		if page.id == page_id:
			Workspace.working_file.pages.remove(i)
			break
