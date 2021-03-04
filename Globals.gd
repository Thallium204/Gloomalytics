extends Node

signal card_fetched_success(progress_node)
signal card_fetched_failed(progress_node)

const class_cards_address = "https://raw.githubusercontent.com/Thallium204/Gloom-Assets/master/Class%20Cards/"
const class_refs_address = class_cards_address + "class_refs.dat"
const error_image_path = "res://assets/error.png"

var class_refs = {}



func _ready():
	fetch_class_refs()


func fetch_class_refs():
	
	var http_request = HTTPRequest.new()
	http_request.use_threads = true
	http_request.connect("request_completed", self, "_ref_request_completed", [http_request])
	add_child(http_request)
	
	var error = http_request.request(class_refs_address)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func _ref_request_completed(_result, response_code, _headers, body, http_request):
	
	http_request.queue_free()
	
	if response_code != 404:
		class_refs = parse_json( body.get_string_from_ascii() )
	else:
		push_error("Request incomplete.")
	
	convert_ranges()
	create_user_directory()

func convert_ranges():
	
	for ref in class_refs:
		
		var class_data = class_refs[ref]
		var string_lower = string_to_int(class_data.card_range[0])
		var string_upper = string_to_int(class_data.card_range[1])
		
		class_data["card_data"] = {}
		for card_number in range(string_lower,string_upper+1):
			class_data["card_data"][int_to_string(card_number)] = {"name":"","level":""}
		
	print_dictionary(class_refs)


func create_user_directory():
	
	if not folder_exists_in("user://","Class Cards"):
		create_folder("user://","Class Cards")
	
	for class_ref in class_refs:
		if not folder_exists_in("user://Class Cards/",class_ref):
			create_folder("user://Class Cards/",class_ref)
		if not folder_exists_in("user://Class Cards/"+class_ref+"/","singles"):
			create_folder("user://Class Cards/"+class_ref+"/","singles")

func folder_exists_in(path,folder_name):
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin(true)
	var file_name = " "
	while file_name != "":
		file_name = dir.get_next()
		if file_name == folder_name:
			return true
	return false

func create_folder(path,folder_name):
	var dir = Directory.new()
	dir.open(path)
	dir.make_dir(folder_name)

func reset_folder(path,folder_name):
	var dir = Directory.new()
	dir.open(path)
	dir.remove(folder_name)

func delete_singles():
	for class_ref in class_refs:
		reset_folder("user://Class Cards/"+class_ref+"/","singles")



func fetch_class_cards(class_ref):
	
	for card_id in class_refs[class_ref].card_data:
		
		var http_request = HTTPRequest.new()
		http_request.use_threads = true
		http_request.connect("request_completed", self, "_png_request_completed", [class_ref,card_id,http_request])
		add_child(http_request)
		var address:String = class_cards_address + class_ref + "/singles/" + card_id + ".png"
		address = address.replace(" ","%20")
		var error = http_request.request(address)
		if error != OK:
			push_error("An error occurred in the HTTP request.")
	
	# icon fetch
	var http_request = HTTPRequest.new()
	http_request.use_threads = true
	http_request.connect("request_completed", self, "_icon_request_completed", [class_ref,http_request])
	add_child(http_request)
	var address:String = class_cards_address + class_ref + "/icon.png"
	address = address.replace(" ","%20")
	var error = http_request.request(address)
	if error != OK:
		push_error("An error occurred in the HTTP request.")


func _png_request_completed(_result, response_code, _headers, body, class_ref, card_id, http_request):
	
	http_request.queue_free()
	
	if response_code == 404:
		print("Failed! ",class_ref," | ",card_id)
		emit_signal("card_fetched_failed")
		return
	
	var image = Image.new()
	var _error = image.load_png_from_buffer(body)
	image.save_png("user://Class Cards/"+class_ref+"/singles/"+card_id+".png")
	print("Success! ",class_ref," | ",card_id)
	emit_signal("card_fetched_success")

func _icon_request_completed(_result, response_code, _headers, body, class_ref, http_request):
	
	http_request.queue_free()
	
	if response_code == 404:
		print("Failed! ",class_ref," | icon.png")
		return
	
	var image = Image.new()
	var _error = image.load_png_from_buffer(body)
	image.save_png("user://Class Cards/"+class_ref+"/icon.png")
	print("Success! ",class_ref," | icon.png")


func get_class_icon(class_ref):
	if folder_exists_in("user://Class Cards/"+class_ref+"/","icon.png"):
		var image = ImageTexture.new()
		image.load( "user://Class Cards/"+class_ref+"/icon.png" )
		return image
	return load("res://assets/error.png")

func get_class_cards_path_array(class_ref) -> PoolStringArray:
	var path_array = PoolStringArray()
	if folder_exists_in("user://Class Cards/"+class_ref+"/","singles"):
		var dir = Directory.new()
		var path = "user://Class Cards/"+class_ref+"/singles/"
		dir.open(path)
		dir.list_dir_begin(true)
		var file_name = dir.get_next()
		while file_name != "":
			path_array.append(path + file_name)
			file_name = dir.get_next()
	return path_array



func save_data():
	pass

func load_data():
	pass


func get_safe_name(class_ref):
	if class_refs[class_ref].spoiler_name == "":
		return class_refs[class_ref].display_name
	return class_refs[class_ref].spoiler_name

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





