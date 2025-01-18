class_name UserOptions
extends Node
signal loaded_user_options( options:DefaultOptions )
var windowControl:WindowControl = null
var options:DefaultOptions = null
var path_user_options = "user://options.ini"
func _init(defaultOptions):
	self.options = defaultOptions
	pass
func load_options():
	var file_exist = FileAccess.file_exists(path_user_options)
	if(file_exist == true):
		load_options_file()
		var file = FileAccess.open(path_user_options, FileAccess.READ)
		var options_string = file.get_as_text()
		for i in options_string.split('\n'):
			var param = i.split(' = ');
			for propertyInfo in options.get_script_property_list():
				var propertyName = propertyInfo[0]
				if(param[0] in propertyName):
					setOption(param[0],param[1])
			
	else:
		save_options()
	#InitLoader.apply_user_options(self.options)
	
func save_options():
	var lines = "";
	for propertyInfo in options.get_script_property_list():
		var propertyName = propertyInfo[0]
		var new_line = '%s = %s\n' % [ propertyName, self.options[propertyName]]
		print("--- Saving user options ---")
		print("viewport param ",propertyName," = ",self.options[propertyName])
		lines += new_line
	save_options_file(lines)

func getOption(key):
	return self.options.getOption(key)

func setOption(key,val):
	self.options.setOption(key,val)

func save_options_file(content):
	#print("--- Save user options ---")
	#print(content)
	var file = FileAccess.open(path_user_options, FileAccess.WRITE)
	file.store_string(content)
	file.close()

func load_options_file():
	var file = FileAccess.open(path_user_options, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	return content
