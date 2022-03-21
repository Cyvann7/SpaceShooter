extends Node2D

#Scenes Preload
var Room = preload("res://resources/scenes/room.tscn")
var Player = preload("res://resources/scenes/Player.tscn")
var Enemy = preload("res://resources/scenes/Enemy.tscn")
onready var Map = $Navigation2D/TileMap

#Map
var tile_size = 32
var h_spread = 100
var min_size = 4
var max_size = 10
var end_room = null
var num_rooms
var path = AStar2D

#Player
var play_mode = false
var player = null
var start_pos = null

#Enemies
var enemy_spawn_chance = 1

func _process(_delta):
	update()

func _ready():
	randomize()
	make_rooms()
	yield(get_tree().create_timer(3), "timeout")
	make_map()
	player = Player.instance()
	player.position = start_pos
	add_child(player)

func make_rooms():
	num_rooms = 15 + randi()%25
	#for every room needed to be made
	for _i in range(num_rooms):
		#blank vector
		var pos = Vector2(rand_range(-h_spread,h_spread), 0)
		#instance the room
		var r = Room.instance()
		#make random sizes for width and hight
		var w = min_size + randi() % (max_size - min_size)
		var h = min_size + randi() % (max_size - min_size)
		#call the make_room function 
		r.make_room(pos, Vector2(w,h)*tile_size)
		#add the room as a child of Rooms.
		$Rooms.add_child(r)
	#wait for movement to stop
	yield(get_tree().create_timer(0.7), "timeout")
	
	for room in $Rooms.get_children(): # cull all below y 200
		if room.position.y > 200:
			room.queue_free()
	yield(get_tree().create_timer(0.7), "timeout")
	
	for room in $Rooms.get_children(): # mirror the rooms
		var nr = room.duplicate()
		nr.make_room(Vector2(room.position.x,0-room.position.y), room.size)
		$Rooms.add_child(nr)
	yield(get_tree().create_timer(0.7), "timeout")
	
	var room_positions = [] # blank array to store room positions
	for room in $Rooms.get_children(): #make the rooms static
		room.mode = RigidBody2D.MODE_STATIC
		room_positions.append(Vector2(room.position.x,room.position.y)) #add room position
	
	yield(get_tree(), "idle_frame")
	# make a minimum span tree
	path = find_mst(room_positions)

func find_mst(nodes):
	# Prim's algorithm
	# Given an array of positions (nodes), generates a minimum
	# spanning tree
	# Returns an AStar object

	# Initialize the AStar and add the first point
	var path = AStar2D.new()
	path.add_point(path.get_available_point_id(), nodes.pop_front())
	
	# Repeat until no more nodes remain
	while nodes:
		var min_dist = INF  # Minimum distance found so far
		var min_p = null  # Position of that node
		var p = null  # Current position
		# Loop through the points in the path
		for p1 in path.get_points():
			p1 = path.get_point_position(p1)
			# Loop through the remaining nodes in the given array
			for p2 in nodes:
				# If the node is closer, make it the closest
				if p1.distance_to(p2) < min_dist:
					min_dist = p1.distance_to(p2)
					min_p = p2
					p = p1
					# Insert the resulting node into the path and add  its connection
		var n = path.get_available_point_id()
		path.add_point(n, min_p)
		path.connect_points(path.get_closest_point(p), n)
		# Remove the node from the array so it isn't visited again
		nodes.erase(min_p)
	return path

func make_map():
	#make a tilemap
	Map.clear()
	#fill tilemap with walls, then carve empty rooms
	var full_rect = Rect2()
	for room in $Rooms.get_children():
		#get the size of the room
		var r = Rect2(room.position-room.size, room.get_node("CollisionShape2D").shape.extents*2)
		full_rect = full_rect.merge(r)
	var topleft = Map.world_to_map(full_rect.position)
	var bottomright = Map.world_to_map(full_rect.end)
	for x in range(topleft.x, bottomright.x+2):
		for y in range(topleft.y, bottomright.y+2):
			Map.set_cell(x,y,1)
	
	#carve rooms
	var corridors = []
	for room in $Rooms.get_children():
		var s = (room.size/tile_size).floor()
		var _pos = Map.world_to_map(room.position)
		var ul = (room.position/tile_size).floor() - s
		for x in range(1, s.x*2 - 1): # start at 1 not 0 so that rooms still have walls
			for y in range(1, s.y*2 - 1):
				Map.set_cell(ul.x + x, ul.y+y ,0 )
		#carve corridors
		var p = path.get_closest_point(Vector2(room.position.x, room.position.y))
		for conn in path.get_point_connections(p):
			if not conn in corridors:
				var start = Map.world_to_map(Vector2(path.get_point_position(p)))
				var end = Map.world_to_map(Vector2(path.get_point_position(conn)))
				carve_path(start, end)
		corridors.append(p)
	
	for cell in Map.get_used_cells_by_id(0):
		Map.set_cell(cell.x,0-cell.y, 0)
		if (randi()%1000)/10 < enemy_spawn_chance: 
			var e = Enemy.instance()
			$Enemy.add_child(e)
			e.position = Map.map_to_world(cell)
			e.position.x +=16
			e.position.y +=16
	
	#choose player spawn
	var amt_of_flr_tiles = Map.get_used_cells_by_id(0).size()
	var spn_is_nxt_to_wall = true
	var spawn_cell
	while spn_is_nxt_to_wall:
		spawn_cell = Map.get_used_cells_by_id(0)[randi()%amt_of_flr_tiles]
		if Map.get_cell(spawn_cell.x+1, spawn_cell.y) == 1: spn_is_nxt_to_wall = true
		elif Map.get_cell(spawn_cell.x-1, spawn_cell.y) == 1: spn_is_nxt_to_wall = true
		elif Map.get_cell(spawn_cell.x, spawn_cell.y+1) == 1: spn_is_nxt_to_wall = true
		elif Map.get_cell(spawn_cell.x, spawn_cell.y-1) == 1: spn_is_nxt_to_wall = true
		elif Map.get_cell(spawn_cell.x+1, spawn_cell.y+1) == 1: spn_is_nxt_to_wall = true
		elif Map.get_cell(spawn_cell.x+1, spawn_cell.y-1) == 1: spn_is_nxt_to_wall = true
		elif Map.get_cell(spawn_cell.x-1, spawn_cell.y+1) == 1: spn_is_nxt_to_wall = true
		elif Map.get_cell(spawn_cell.x-1, spawn_cell.y-1) == 1: spn_is_nxt_to_wall = true
		else: spn_is_nxt_to_wall = false
		print(spn_is_nxt_to_wall, spawn_cell)
	start_pos = Map.map_to_world(spawn_cell)
	start_pos.x +=16
	start_pos.y +=16
	
	#get rid of squares not connected to floors
	for cell in Map.get_used_cells_by_id(1):
		var cnctd_to_flr = false
		if Map.get_cell(cell.x+1, cell.y) == 0: cnctd_to_flr = true
		if Map.get_cell(cell.x-1, cell.y) == 0: cnctd_to_flr = true
		if Map.get_cell(cell.x, cell.y+1) == 0: cnctd_to_flr = true
		if Map.get_cell(cell.x, cell.y-1) == 0: cnctd_to_flr = true
		if Map.get_cell(cell.x+1, cell.y+1) == 0: cnctd_to_flr = true
		if Map.get_cell(cell.x+1, cell.y-1) == 0: cnctd_to_flr = true
		if Map.get_cell(cell.x-1, cell.y+1) == 0: cnctd_to_flr = true
		if Map.get_cell(cell.x-1, cell.y-1) == 0: cnctd_to_flr = true
		if not cnctd_to_flr: Map.set_cell(cell.x,cell.y, -1)
	
	#delete all the rooms
	for n in $Rooms.get_children():
		n.queue_free()

func carve_path(pos1, pos2):
	#Carve a path between 2 points
	var x_diff = sign(pos2.x - pos1.x)
	var y_diff = sign(pos2.y - pos1.y)
	if x_diff == 0: x_diff = pow(-1.0, randi()%2)
	if y_diff == 0: y_diff = pow(-1.0, randi()%2)
	#choose either x -> y or y -> x
	var x_y = pos1
	var y_x = pos2
	if (randi()%2 > 0):
		x_y = pos2
		y_x = pos1
	
	for x in range(pos1.x, pos2.x, x_diff):
		Map.set_cell(x,x_y.y, 0)
		Map.set_cell(x,x_y.y + y_diff, 0) # widen path
		
	for y in range(pos1.y, pos2.y, y_diff):
		Map.set_cell(y_x.x, y, 0)
		Map.set_cell(y_x.x + x_diff, y, 0)


#########|DEV OPTIONS|##########################################################
#func _input(event):
#	if event.is_action_pressed("ui_select"):
#		for n in $Rooms.get_children():
#			n.queue_free()
#		make_rooms()
#	if event.is_action_pressed("ui_focus_next"):
#		make_map()
#
#func _draw():
#	for room in $Rooms.get_children():
#		draw_rect(Rect2(room.position - room.size, room.size * 2), Color(0,1,0), false)
#	if path:
#		for p in path.get_points():
#			for c in path.get_point_connections(p):
#				var pp = path.get_point_position(p)
#				var cp = path.get_point_position(c)
#				draw_line(Vector2(pp.x,pp.y),
#						  Vector2(cp.x, cp.y),
#						  Color(0.1,0.1,0.1,1), 15, true)
##################################################################################
