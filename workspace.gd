extends Node

# History

signal history_change(action)

var history: Array = []
var history_index = 0
var history_max = 50

func do_action(action: HistoryAction):
	action.do()
	if history_index < history.size():
		history = history.slice(0, history_index)
	history.push_back(action)
	if history.size() > history_max:
		var discard_action = history.pop_front()
		discard_action.queue_free()
	else:
		history_index += 1
	emit_signal("history_change", action)

func can_redo():
	return history_index < history.size()
	
func can_undo():
	return history_index > 0

func redo_action():
	if can_redo():
		var action = history[history_index]
		action.do()
		history_index += 1
		emit_signal("history_change", action)

func undo_action():
	if can_undo():
		history_index -= 1
		history[history_index].undo()
		emit_signal("history_change", history[history_index])

# Working File

var working_file = null

func get_page_index_by_id(id: int):
	var index = null
	if working_file:
		for i in working_file.pages.size():
			var page = working_file.pages[i]
			if page.id == id:
				index = i
				break
	return index

func get_page_id_by_index(index: int):
	var id = null
	if working_file and working_file.pages.size() > index:
		id = working_file.pages[index].id
	return id

func get_selected_page():
	if working_file and working_file.selected_page_id != null:
		return working_file.pages[get_page_index_by_id(working_file.selected_page_id)]
	else:
		return null

func get_artboard_index_by_id(id: int):
	var index = null
	var selected_page = get_selected_page()
	if selected_page:
		for i in selected_page.artboards.size():
			var artboard = selected_page.artboards[i]
			if artboard.id == id:
				index = i
				break
	return index

func get_artboard_id_by_index(index: int):
	var id = null
	var selected_page = get_selected_page()
	if selected_page and selected_page.artboards.size() > index:
		id = selected_page.artboards[index].id
	return id

func get_selected_artboard():
	var selected_artboard = null
	if working_file and working_file.selected_artboard_id != null:
		var selected_page = get_selected_page()
		if selected_page:
			selected_artboard = selected_page.artboards[get_artboard_index_by_id(working_file.selected_artboard_id)]
	return selected_artboard

# Lifecycle

func _ready():
	# Init new file without history event
	FileCreateAction.new().do()
