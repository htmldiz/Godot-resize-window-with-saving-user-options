extends Control
class_name WindowControl
var userOptions:UserOptions = null
var viewport = null
func _init(options = null) -> void:
	if(options != null):
		self.userOptions = options

func apply(viewport):
	self.viewport = viewport
	var options = self.userOptions.options
	change_full_screen(options.is_fullscreen)
	change_content_scale_aspect(options.stretch_aspect)
	change_content_scale_size(options.get_base_window_size())
	change_stretch_mode(options.stretch_mode)
	change_scale_factor(options.scale_factor)
	change_lang(options.lang)
	pass
	
func change_content_scale_aspect(stretch_aspect):
	set_vp('content_scale_aspect',stretch_aspect)
	
func change_content_scale_stretch(scale_stretch):
	set_vp('content_scale_stretch',scale_stretch,"stretch_mode")

func change_lang(lang:String):
	var locale = lang.to_lower()
	TranslationServer.set_locale(lang)
	set_user_option('lang',lang)
	
	pass
func change_scale_factor(scale_factor):
	set_vp("content_scale_factor",scale_factor,"scale_factor")
	pass
func change_full_screen(is_fullscreen):
	if(is_fullscreen == true):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	set_user_option("is_fullscreen",is_fullscreen)
	
	
func change_content_scale_size(base_window_size:Vector2i):
	set_vp("content_scale_size",base_window_size)
	Input.warp_mouse(base_window_size)
	set_user_option("window_width",base_window_size[0])
	set_user_option("window_height",base_window_size[1])
	
func change_stretch_mode(stretch_mode):
	set_vp("content_scale_mode",stretch_mode,"stretch_mode")

func set_user_option(key,val):
	print("set user option ",key," = ",val)
	self.userOptions.setOption(key,val)
	
func set_vp(key,val,option_key = null):
	print("--- Viewport ---")
	print("viewport param ",key," = ",val)
	if(option_key != null):
		set_user_option(option_key,val)
	self.viewport[key] = val
