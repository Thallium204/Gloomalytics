extends Node

const class_cards_address = "https://raw.githubusercontent.com/Thallium204/Gloom-Assets/master/Class%20Cards/"
const class_refs_address = class_cards_address + "class_refs.dat"

var active_class:String
var classes_data = {}
var class_refs = {}


func _ready():
	get_class_refs()


func get_class_refs():
	
	var http_request = HTTPRequest.new()
	http_request.use_threads = true
	http_request.connect("request_completed", self, "_ref_request_completed", [http_request])
	add_child(http_request)
	
	var error = http_request.request(class_refs_address)
	if error != OK:
		push_error("An error occurred in the HTTP request.")


func _ref_request_completed(result, _response_code, _headers, body, http_request):
	http_request.queue_free()
	if result == HTTPRequest.RESULT_SUCCESS:
		class_refs = parse_json( body.get_string_from_ascii() )
	else:
		push_error("Request incomplete.")
	
	convert_ranges()


func convert_ranges():
	
	for ref in class_refs:
		
		var class_data = class_refs[ref]
		var string_lower = string_to_int(class_data.card_range[0])
		var string_upper = string_to_int(class_data.card_range[1])
		
		class_data["card_data"] = {}
		for card_number in range(string_lower,string_upper+1):
			class_data["card_data"][int_to_string(card_number)] = {"name":"","level":""}
		
	print_dictionary(class_refs)


func get_class_cards(class_ref, object_to_call = null, function_name = ""):
	
	for card_id in class_refs[class_ref].card_data:
		
		var http_request = HTTPRequest.new()
		http_request.use_threads = true
		http_request.connect("request_completed", self, "_png_request_completed",[class_ref,card_id,http_request])
		if object_to_call:
			http_request.connect("request_completed", object_to_call, function_name, [class_ref,card_id])
		add_child(http_request)
		
		var error = http_request.request(class_cards_address + class_ref + "/singles/" + card_id + ".png")
		if error != OK:
			push_error("An error occurred in the HTTP request.")


func _png_request_completed(_result, _response_code, _headers, body, class_ref, card_id, http_request):
	http_request.queue_free()
	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")
	else:
		print("Success! ",class_ref,card_id)
	
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	class_refs[class_ref].card_data[card_id]["image_texture"] = texture


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


func string_to_int(string:String):
	return int(string)


func int_to_string(integer:int):
	var string = str(integer)
	while string.length() < 3:
		string = "0" + string
	return string

var print_exceptions = ["card_data"]

func print_dictionary(dict,prefix=""):
	
	for key in dict:
		if prefix == "":
			print()
		var value = dict[key]
		if key in print_exceptions:
			print(prefix+key+": [...]")
		elif value is Dictionary:
			print(prefix+key+":")
			print_dictionary(value,prefix+" ")
		else:
			print(prefix+key+": ",value)





