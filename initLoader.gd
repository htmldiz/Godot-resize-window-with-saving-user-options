extends Node
var options_string = ""
var defaultOptions:DefaultOptions = null
var userOptions:UserOptions = null
var windowControl:WindowControl = null
var arrow = load("res://Images/pointer_c.png")
# Called when the node enters the scene tree for the first time.
func _init() -> void:
	defaultOptions = DefaultOptions.new()
	self.add_child(defaultOptions)
	userOptions = UserOptions.new(defaultOptions)
	userOptions.load_options()
	self.add_child(userOptions)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	apply_user_options(userOptions.options)

func apply_user_options(options):
	windowControl = WindowControl.new(userOptions)
	windowControl.apply(get_viewport())
	
func _process(delta: float) -> void:
	pass
