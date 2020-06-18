extends Reference
class_name HistoryAction

enum ID {
	ARTBOARD_CREATE,
	FILE_CREATE,
	PAGE_CREATE,
	PAGE_DELETE,
	PAGE_SELECT,
	UNDEFINED,
}

var id: int = ID.UNDEFINED
var is_done: bool = false
var description: String = "Undefined"

func do():
	is_done = true

func undo():
	is_done = false
