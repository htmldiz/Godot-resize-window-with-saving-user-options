class_name DefaultOptions
extends Node
var stretch_mode = int(Window.CONTENT_SCALE_MODE_CANVAS_ITEMS) : 
	set(val):  stretch_mode = int(val)
var stretch_aspect   = int(Window.CONTENT_SCALE_ASPECT_EXPAND) : 
	set(val):  stretch_aspect = int(val)
var scale_factor     = 1.0 : 
	set(val):  scale_factor = float(val)
var gui_aspect_ratio:float = -1.0 : 
	set(val):  gui_aspect_ratio = float(val)
var gui_margin       = 0.0 : 
	set(val):  gui_margin = float(val)
var is_fullscreen   = true :
	set(val): 
		if(typeof(val) == TYPE_STRING):
			if(val.to_lower() == 'true'):
				is_fullscreen = true
			else:
				is_fullscreen =  false
var window_width  = 648 : 
	set(val): 
		if(typeof(val) == TYPE_STRING):
			window_width =  val.bin_to_int()
		else:
			window_width =  val
var window_height    = 648 : 
	set(val): 
		if(typeof(val) == TYPE_STRING):
			window_height =  val.bin_to_int()
		else:
			window_height =  val
var lang             = "en"
var langs            = Helper.langs
func get_script_property_list():
	var thisScript: GDScript = get_script()
	var returnOptions = []
	for propertyInfo in thisScript.get_script_property_list():
		var propertyName: String = propertyInfo.name
		var propertyValue = get(propertyName)
		if not ".gd" in propertyName:
			returnOptions.append([ propertyName, propertyValue ])
	return returnOptions

func get_base_window_size():
	return Vector2i(self.window_width, self.window_height)

func set_base_window_size(window_width,window_height):
	self.window_width  = window_width
	self.window_height = window_height

func setOption(key,val):
	if(typeof(self[key]) == TYPE_INT):
		val = int(float(val))
	if(typeof(self[key]) == TYPE_FLOAT):
		val = float(val)
	if(typeof(self[key]) == TYPE_STRING):
		if(val.to_lower() == "true"):
			val = true
		else:
			val = false
	self[key] = val
	
func getOption(key):
	return self[key]
