extends Node
class_name MapPlanner

const MAP_X: float = 500
const MAP_Y: float = 500
const MIN_ENCOUNTER_DISTANCE: float = 50

var encounter_num: int = 14

func get_even_points(num: int) -> Array[Vector2]:
  var p: Array[Vector2] = []
  
  while len(p) < num:
    var pos: Vector2 = Vector2(
      randf_range(0, MAP_X),
      randf_range(0, MAP_Y),
    )
    
    var add: bool = true
    for i in p:
      if i.distance_squared_to(pos) < MIN_ENCOUNTER_DISTANCE * MIN_ENCOUNTER_DISTANCE:
        add = false
        break
    
    if add: p.push_back(pos)
  
  return p
func sort_points(p: Array[Vector2]) -> void:
  var f = func(a: Vector2):
    return min(
      a.distance_squared_to(Vector2(0, 0)),
      a.distance_squared_to(Vector2(MAP_X, 0)),
      a.distance_squared_to(Vector2(0, MAP_Y)),
      a.distance_squared_to(Vector2(MAP_X, MAP_Y)),
    )
  
  p.sort_custom(func(a, b): return f.call(a) < f.call(b))

  var start: Vector2 = p.pop_front()

  var g = func(a: Vector2): return a.distance_squared_to(start)

  p.sort_custom(func(a, b): return g.call(a) < g.call(b))

  p.insert(0, start)
func make_edges(p: Array[Vector2]) -> Array[Vector2i]:
  var joined: Array[Vector2i] = []
  var queue: Array[int] = [len(p)-1]
  var deep: Dictionary[int, int] = {0: -1, len(p)-1: 0}
  #var per_depth: Dictionary[int, int] = {0: 1}
  
  while queue:
    var e: int = queue.pop_front()
    
    var could: Array[Vector2i] = []
    for i in range(len(p)):
      if i in deep and deep[i] != deep[e]+1: continue
      
      could.push_back(Vector2i(i, int(p[i].distance_squared_to(p[e]))))

    could.sort_custom(func(a: Vector2, b: Vector2): return a.y < b.y)

    for i in range(min(len(could)-1, randi_range(1, 3))):
      joined.push_back(Vector2i(e, could[i].x))
      if !could[i].x in deep:
        deep[could[i].x] = deep[e]+1
        #if deep[e]+1 in per_depth:
        #  per_depth[deep[e]+1]+=1
        #else:
        #  per_depth[deep[e]+1]=1
      queue.push_back(could[i].x)
  
  #print(per_depth)
  
  var exits: Array[int] = []
  for i in joined: if !i.x in exits: exits.push_back(i.x)
  
  for i in range(len(p)):
    if i > 0 and !i in exits and i in deep:
      joined.push_back(Vector2i(0, i))
  
  # There should be at most 1 disconnected node, we fix that here
  for i in range(len(p)):
    if !i in deep:
      for l in range(len(joined)):
        var j = joined[l]
        var nj: Vector2 = Vector2(j.x, j.y)
        if j.x == i: nj.x = len(p)-1
        if j.x == len(p)-1: nj.x = i
        if j.y == i: nj.y = len(p)-1
        if j.y == len(p)-1: nj.y = i
        joined[l] = nj
      joined.push_back(Vector2i(i, len(p)-1))
  
  # Final cleanup
  var new_j: Array[Vector2i] = []
  var depth_queue: Array[int] = [0]
  var seen: Array[int] = []
  
  while depth_queue:
    var from: int = depth_queue.pop_front()
    seen.push_back(from)
    
    for i in joined:
      if i.x == from and !i.y in seen and !Vector2i(from, i.y) in new_j:
        depth_queue.push_back(i.y)
        new_j.push_back(Vector2i(from, i.y))
      if i.y == from and !i.x in seen and !Vector2i(from, i.x) in new_j:
        depth_queue.push_back(i.x)
        new_j.push_back(Vector2i(from, i.x))
  
  return new_j

func pick_room_types(num: int) -> Dictionary[int, Map.RoomTypes]:
  var types: Dictionary[int, Map.RoomTypes] = {
    0:     Map.RoomTypes.Start,
    num-1: Map.RoomTypes.Boss
  }
  
  var type_queue: Array[String] = []
  
  for i in range(num):
    if !i in types:
      if !type_queue:
        type_queue.append_array(Array(Map.RoomTypes.keys()).slice(0, -2))
        type_queue.shuffle()
      
      types[i] = Map.RoomTypes[type_queue.pop_back()]
  
  return types

func plan_map() -> Map:
  var points = get_even_points(encounter_num)
  sort_points(points)
  var edges = make_edges(points)
  
  var types = pick_room_types(encounter_num)
  
  var m: Map = Map.new()
  for i in range(encounter_num):
    m.encounters.push_back(types[i])
  for i in edges:
    if i.x in m.edges:
      m.edges[i.x].push_back(i.y)
    else:
      m.edges[i.x] = [i.y]
  
  return m
