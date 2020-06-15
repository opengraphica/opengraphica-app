extends Control

var file_icon = preload("res://assets/icons/file-regular.svg")
var pencil_icon = preload("res://assets/icons/pencil-alt-solid-highlight.svg")

var add_artboard_button: Button
var add_page_button: Button
var pages_heading: PanelContainer
var page_list: ItemList
var selected_page_heading: PanelContainer
var selected_page_label: Label
var selected_page_tree: Tree

func _ready():
	pages_heading = $ScrollContainer/VBoxContainer/PagesHeading
	add_page_button = $ScrollContainer/VBoxContainer/PagesHeading/MarginContainer/HBoxContainer/AddPageButton
	page_list = $ScrollContainer/VBoxContainer/PageList
	selected_page_heading = $ScrollContainer/VBoxContainer/SelectedPageHeading
	selected_page_label = $ScrollContainer/VBoxContainer/SelectedPageHeading/MarginContainer/HBoxContainer/Label
	add_artboard_button = $ScrollContainer/VBoxContainer/SelectedPageHeading/MarginContainer/HBoxContainer/AddArtboardButton
	selected_page_tree = $ScrollContainer/VBoxContainer/SelectedPageTree
	
	selected_page_heading.visible = false
	selected_page_tree.visible = false
	
	add_page_button.connect("pressed", self, "_add_page_pressed")
	add_artboard_button.connect("pressed", self, "_add_artboard_pressed")
	page_list.connect("item_selected", self, "_page_selected")
	Workspace.connect("history_change", self, "_history_change")
	
	var root = selected_page_tree.create_item()
	selected_page_tree.set_hide_root(true)
	var child1 = selected_page_tree.create_item(root)
	var child2 = selected_page_tree.create_item(root)
	var subchild1 = selected_page_tree.create_item(child1)
	subchild1.set_text(0, "Subchild1")


func _history_change(action: HistoryAction):
	var selected_page
	if [HistoryAction.ID.PAGE_CREATE].has(action.id):
		page_list.clear()
		for i in Workspace.working_file.pages.size():
			var page = Workspace.working_file.pages[i]
			page_list.add_item(page.display_name, file_icon)
			page_list.set_item_tooltip_enabled(i, false)
	if [HistoryAction.ID.PAGE_CREATE, HistoryAction.ID.PAGE_SELECT].has(action.id):
		var selected_page_index = -1
		for i in Workspace.working_file.pages.size():
			var page = Workspace.working_file.pages[i]
			if Workspace.working_file.selected_page_id == page.id:
				selected_page = page
				page_list.set_item_icon(i, pencil_icon)
				page_list.select(i)
			else:
				page_list.set_item_icon(i, file_icon)
	selected_page_heading.visible = true if Workspace.working_file.selected_page_id != null else false
	selected_page_tree.visible = true if Workspace.working_file.selected_page_id != null else false
	if selected_page_heading.visible and selected_page:
		selected_page_label.text = selected_page.display_name

func _page_selected(index: int):
	Workspace.do_action(
		PageSelectAction.new({
			"id": Workspace.working_file.pages[index].id
		})
	)

func _add_page_pressed():
	Workspace.do_action(
		PageCreateAction.new({})
	)

func _add_artboard_pressed():
	pass
