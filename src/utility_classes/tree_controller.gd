extends Reference
class_name TreeController

static func free_children(parent_item: TreeItem):
	var current_item = parent_item.get_children()
	while current_item:
		var next_item = current_item.get_next()
		parent_item.remove_child(current_item)
		current_item.free()
		current_item = next_item
