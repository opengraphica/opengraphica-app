extends Control

var sidebar_container_outer: HSplitContainer
var sidebar_container_inner: HSplitContainer
var drag_handle_size = 16

var left_sidebar_size = 200
var right_sidebar_size = 200

func _ready():
	JavaScript.eval("window.hideLogo()", true)
	get_tree().get_root().connect("size_changed", self, "_window_resize")
	sidebar_container_outer = $VBoxContainer/HSplitContainer
	sidebar_container_inner = $VBoxContainer/HSplitContainer/HSplitContainer
	sidebar_container_outer.connect("dragged", self, "_sidebar_container_outer_dragged")
	sidebar_container_inner.connect("dragged", self, "_sidebar_container_inner_dragged")
	_resize_sidebars()

func _sidebar_container_outer_dragged(offset):
	right_sidebar_size = get_viewport_rect().size.x - offset - (drag_handle_size * 2)
	
func _sidebar_container_inner_dragged(offset):
	left_sidebar_size = offset

func _resize_sidebars():
	sidebar_container_outer.split_offset = get_viewport_rect().size.x - right_sidebar_size - (drag_handle_size * 2)
	sidebar_container_inner.split_offset = left_sidebar_size

func _window_resize():
	_resize_sidebars()
