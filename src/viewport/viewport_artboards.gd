extends Node2D

func _ready():
	Workspace.connect("history_change", self, "_history_change")

func _history_change(action: HistoryAction):
	match action.id:
		HistoryAction.ID.PAGE_CREATE:
			pass
