extends Control

var file_icon = preload("res://assets/icons/file-regular.svg")
var pencil_icon = preload("res://assets/icons/pencil-alt-solid-highlight.svg")

enum PAGE_CONTEXT_MENU_ITEM {
	DELETE,
	CANCEL,
}

var add_artboard_button: Button
var add_page_button: Button
var pages_heading: PanelContainer
var page_list: ItemList
var selected_page_heading: PanelContainer
var selected_page_label: Label
var selected_page_tree: Tree
var selected_page_tree_root: TreeItem
var page_context_menu: PopupMenu

func _ready():
	pages_heading = $ScrollContainer/VBoxContainer/PagesHeading
	add_page_button = $ScrollContainer/VBoxContainer/PagesHeading/MarginContainer/HBoxContainer/AddPageButton
	page_list = $ScrollContainer/VBoxContainer/PageList
	page_context_menu = $PageContextMenu
	selected_page_heading = $ScrollContainer/VBoxContainer/SelectedPageHeading
	selected_page_label = $ScrollContainer/VBoxContainer/SelectedPageHeading/MarginContainer/HBoxContainer/Label
	add_artboard_button = $ScrollContainer/VBoxContainer/SelectedPageHeading/MarginContainer/HBoxContainer/AddArtboardButton
	selected_page_tree = $ScrollContainer/VBoxContainer/SelectedPageTree
	
	selected_page_heading.visible = false
	selected_page_tree.visible = false
	
	add_page_button.connect("pressed", self, "_add_page_pressed")
	add_artboard_button.connect("pressed", self, "_add_artboard_pressed")
	page_list.connect("item_selected", self, "_page_selected")
	page_list.connect("item_rmb_selected", self, "_page_context_menu_opened")
	page_context_menu.connect("id_pressed", self, "_page_context_menu_selection")
	Workspace.connect("history_change", self, "_history_change")


func _history_change(action: HistoryAction):
	print_debug(HistoryAction.ID.keys()[action.id])
	var selected_page = null
	if [HistoryAction.ID.PAGE_CREATE, HistoryAction.ID.PAGE_DELETE].has(action.id):
		_create_page_list_items()
	if [HistoryAction.ID.PAGE_CREATE, HistoryAction.ID.PAGE_DELETE, HistoryAction.ID.PAGE_SELECT].has(action.id):
		selected_page = _set_page_list_item_selection()
	if [HistoryAction.ID.PAGE_CREATE, HistoryAction.ID.PAGE_DELETE, HistoryAction.ID.PAGE_SELECT, HistoryAction.ID.ARTBOARD_CREATE].has(action.id):
		_create_selected_page_outline_items()
	if Workspace.working_file.pages.size() > 4:
		page_list.auto_height = false
		page_list.rect_min_size.y = 100
	else:
		page_list.auto_height = true
		page_list.rect_min_size.y = 0
	
	selected_page_heading.visible = true if Workspace.working_file.selected_page_id != null else false
	selected_page_tree.visible = true if Workspace.working_file.selected_page_id != null else false
	if selected_page_heading.visible and selected_page:
		selected_page_label.text = selected_page.display_name

func _add_page_pressed():
	Workspace.do_action(
		PageCreateAction.new({})
	)

func _page_selected(index: int):
	Workspace.do_action(
		PageSelectAction.new({
			"id": Workspace.working_file.pages[index].id
		})
	)

func _create_page_list_items():
	page_list.clear()
	for i in Workspace.working_file.pages.size():
		var page = Workspace.working_file.pages[i]
		page_list.add_item(page.display_name, file_icon)
		page_list.set_item_tooltip_enabled(i, false)

func _set_page_list_item_selection():
	var selected_page = null
	for i in Workspace.working_file.pages.size():
		var page = Workspace.working_file.pages[i]
		if Workspace.working_file.selected_page_id == page.id:
			selected_page = page
			page_list.set_item_icon(i, pencil_icon)
			page_list.select(i)
			page_list.ensure_current_is_visible()
		else:
			page_list.set_item_icon(i, file_icon)
	return selected_page

func _page_context_menu_opened(index: int, at_position: Vector2):
	page_context_menu.clear()
	page_context_menu.add_item("Delete", PAGE_CONTEXT_MENU_ITEM.DELETE)
	page_context_menu.add_item("Cancel", PAGE_CONTEXT_MENU_ITEM.CANCEL)
	page_context_menu.rect_global_position = get_global_mouse_position()
	page_context_menu.popup()

func _page_context_menu_selection(id: int):
	match id:
		PAGE_CONTEXT_MENU_ITEM.DELETE:
			Workspace.do_action(
				PageDeleteAction.new({
					"id": Workspace.get_page_id_by_index(page_list.get_selected_items()[0])
				})
			)

func _add_artboard_pressed():
	Workspace.do_action(
		ArtboardCreateAction.new({})
	)

func _create_selected_page_outline_items():
	selected_page_tree.clear()
	selected_page_tree_root = selected_page_tree.create_item()
	selected_page_tree.set_hide_root(true)
	var selected_page = Workspace.get_selected_page()
	if selected_page:
		for artboard in selected_page.artboards:
			var artboard_item = selected_page_tree.create_item(selected_page_tree_root)
			artboard_item.set_text(0, artboard.display_name)
