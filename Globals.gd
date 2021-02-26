extends Node

var active_class:String
var classes_data = {}

func _init():
	get_classes_data()
	#save_data()


func set_active_class(button_text):
	active_class = button_text


func save_data():
	var file = File.new()
	file.open("res://save_data.dat", File.WRITE)
	file.store_line(to_json(classes_data))
	file.close()



func load_data():
	pass


func get_classes_data():
	
	var path = "res://Class Cards/"
	var dir = Directory.new()
	if dir.open(path) == OK: # if this is a valid path to open
		dir.list_dir_begin(true) # begin scan
		var file_name = dir.get_next() # get next file
		while file_name != "": # while we're not at the end
			if dir.current_is_dir(): # if the file is a folder
				classes_data[file_name] = {"name":file_name.right(3)}
				
				var dir_contents = Directory.new()
				dir_contents.open(path + file_name + "/")
				dir_contents.list_dir_begin(true)
				var content_name = dir_contents.get_next()
				while content_name != "":
					
					if ".import" in content_name:
						content_name = dir_contents.get_next()
						continue
					if file_name + ".png" == content_name:
						classes_data[file_name]["icon_path"] = path + file_name + "/" + content_name
					elif "front" in content_name:
						classes_data[file_name]["front_path"] = path + file_name + "/" + content_name
					elif "back" in content_name:
						classes_data[file_name]["back_path"] = path + file_name + "/" + content_name
					content_name = dir_contents.get_next()
				
			file_name = dir.get_next()
	else:
		print(path + " doesnt exist.")
