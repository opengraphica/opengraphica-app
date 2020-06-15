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

func _ready():
	# Init new file without history event
	FileCreateAction.new().do()
