# The root Control node ("Main") and AspectRatioContainer nodes are the most important
# pieces of this demo.
# Both nodes have their Layout set to Full Rect
# (with their rect spread across the whole viewport, and Anchor set to Full Rect).
extends Control

var base_window_size = Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
)

# These defaults match this demo's project settings. Adjust as needed if adapting this
# in your own project.
var stretch_mode   = InitLoader.userOptions.getOption('stretch_mode')
var stretch_aspect = InitLoader.userOptions.getOption('stretch_aspect')

var scale_factor = InitLoader.userOptions.getOption('scale_factor')
var gui_aspect_ratio = InitLoader.userOptions.getOption('gui_aspect_ratio')
var gui_margin =  InitLoader.userOptions.getOption('gui_margin')

@onready var panel = $Panel
@onready var arc = $Panel/AspectRatioContainer
@onready var window_sizes_element = $Panel/AspectRatioContainer/Panel/CenterContainer/Options/WindowBaseSize/WindowBaseSizeButton


	
func _ready():
	# The `resized` signal will be emitted when the window size changes, as the root Control node
	# is resized whenever the window size changes. This is because the root Control node
	# uses a Full Rect anchor, so its size will always be equal to the window size.
	resized.connect(_on_resized)
	update_container.call_deferred()
	var index = null
	#print(Helper.window_sizes.size())
	for i in Helper.window_sizes.size():
		var size = Helper.window_sizes[i]
		var label = str(size[0])+" x "+str(size[1])
		window_sizes_element.add_item(label)
		var window_width = InitLoader.userOptions.getOption("window_width")
		var window_height = InitLoader.userOptions.getOption("window_height")
		if (window_width == int(size[0]) and window_height == int(size[1])):
			window_sizes_element.select(i)
		
			#window_sizes_element.add_item(text,j)


func update_container():
	# The code within this function needs to be run deferred to work around an issue with containers
	# having a 1-frame delay with updates.
	# Otherwise, `panel.size` returns a value of the previous frame, which results in incorrect
	# sizing of the inner AspectRatioContainer when using the Fit to Window setting.
	for _i in 2:
		if is_equal_approx(gui_aspect_ratio, -1.0):
			# Fit to Window. Tell the AspectRatioContainer to use the same aspect ratio as the window,
			# making the AspectRatioContainer not have any visible effect.
			arc.ratio = panel.size.aspect()
			# Apply GUI offset on the AspectRatioContainer's parent (Panel).
			# This also makes the GUI offset apply on controls located outside the AspectRatioContainer
			# (such as the inner side label in this demo).
			panel.offset_top = gui_margin
			panel.offset_bottom = -gui_margin
		else:
			# Constrained aspect ratio.
			arc.ratio = min(panel.size.aspect(), gui_aspect_ratio)
			# Adjust top and bottom offsets relative to the aspect ratio when it's constrained.
			# This ensures that GUI offset settings behave exactly as if the window had the
			# original aspect ratio size.
			panel.offset_top = gui_margin / gui_aspect_ratio
			panel.offset_bottom = -gui_margin / gui_aspect_ratio

		panel.offset_left = gui_margin
		panel.offset_right = -gui_margin

var gui_aspect_ratios = [
	-1.0,
	5.0 / 4.0,
	4.0 / 3.0,
	3.0 / 2.0,
	16.0 / 10.0,
	16.0 / 9.0,
	21.0 / 9.0
]
func _on_gui_aspect_ratio_item_selected(index):
	match index:
		0:  # Fit to Window
			gui_aspect_ratio = -1.0
		1:  # 5:4
			gui_aspect_ratio = 5.0 / 4.0
		2:  # 4:3
			gui_aspect_ratio = 4.0 / 3.0
		3:  # 3:2
			gui_aspect_ratio = 3.0 / 2.0
		4:  # 16:10
			gui_aspect_ratio = 16.0 / 10.0
		5:  # 16:9
			gui_aspect_ratio = 16.0 / 9.0
		6:  # 21:9
			gui_aspect_ratio = 21.0 / 9.0

	update_container.call_deferred()


func _on_resized():
	update_container.call_deferred()


func _on_gui_margin_drag_ended(_value_changed):
	gui_margin = $"Panel/AspectRatioContainer/Panel/CenterContainer/Options/GUIMargin/HSlider".value
	$"Panel/AspectRatioContainer/Panel/CenterContainer/Options/GUIMargin/Value".text = str(gui_margin)
	update_container.call_deferred()


func _on_window_base_size_item_selected(index):
	base_window_size = Vector2(Helper.window_sizes[index][0], Helper.window_sizes[index][1])
	print(base_window_size,'setup base_window_size')
	InitLoader.windowControl.change_content_scale_size(base_window_size)
	update_container.call_deferred()


func _on_window_stretch_mode_item_selected(index):
	stretch_mode = index
	get_viewport().content_scale_mode = stretch_mode
	#print(stretch_mode)
	# Disable irrelevant options when the stretch mode is Disabled.
#	$"Panel/AspectRatioContainer/Panel/CenterContainer/Options/WindowBaseSize/OptionButton".disabled = stretch_mode == Window.CONTENT_SCALE_MODE_DISABLED
#	$"Panel/AspectRatioContainer/Panel/CenterContainer/Options/WindowStretchAspect/OptionButton".disabled = stretch_mode == Window.CONTENT_SCALE_MODE_DISABLED


func _on_window_stretch_aspect_item_selected(index):
	InitLoader.windowControl.change_content_scale_aspect(index)


func _on_window_scale_factor_drag_ended(_value_changed):
	scale_factor = $"Panel/AspectRatioContainer/Panel/CenterContainer/Options/WindowScaleFactor/HSlider".value
	$"Panel/AspectRatioContainer/Panel/CenterContainer/Options/WindowScaleFactor/Value".text = "%d%%" % (scale_factor * 100)
	InitLoader.windowControl.change_scale_factor(scale_factor)


func _on_window_stretch_scale_mode_item_selected(index: int) -> void:
	InitLoader.windowControl.change_content_scale_stretch(index)


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_window_base_size_button_ready() -> void:
	pass # Replace with function body.


func _on_save_button_pressed() -> void:
	InitLoader.userOptions.save_options()


func _on_option_button_item_selected(index: int) -> void:
	
	pass
