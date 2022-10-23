extends Node2D

onready var n : int = $Nodes.get_child_count()
onready var arr : Array = $Nodes.get_children()
onready var raycast := $RayCast2D

var adj := []
var next := []
var racers := []


func dist(a: Vector2, b: Vector2):
	return pow(a.distance_to(b), 0.6) 

func cekwall(racer: EnemyRacer) -> void:
	# cek apa bs ke nextnext?
	raycast.position = racer.position
	raycast.cast_to = arr[racer.nextnext].position - racer.position
	raycast.force_raycast_update()
	if not raycast.is_colliding():
		racer.next = racer.nextnext
		racer.nextnext = next[racer.guideID][racer.nextnext]
		return
		
	# cek udh gbs ke next
	raycast.position = racer.position
	raycast.cast_to = arr[racer.next].position - racer.position
	raycast.force_raycast_update()
	if raycast.is_colliding():
		updatenext(racer.position, racer.guideID)

func updatenext(pos : Vector2, guide_id : int) -> void:
	var mi := INF
	var nxt := -1
	for i in n:
		raycast.position = pos
		raycast.cast_to = arr[i].position - pos
		raycast.force_raycast_update()
		if not raycast.is_colliding():
			var d = dist(pos, arr[i].position)
			if d < mi:
				mi = d
				nxt = i
	racers[guide_id].next = nxt
	racers[guide_id].nextnext = next[guide_id][nxt]

func _ready():
	randomize()
	# bikin grafnya
	for x in n: adj.append([])
	for i in n: for j in i:
		raycast.position = arr[i].position
		raycast.cast_to = arr[j].position - arr[i].position
		raycast.force_raycast_update()
		if not raycast.is_colliding():
			adj[i].append(Vector2(j, dist(arr[i].position, arr[j].position)))
			adj[j].append(Vector2(i, dist(arr[i].position, arr[j].position)))
	
	# assign tiap enemies
	for racer in self.get_children():
		if racer.get("guideID") == null: continue
		racer.guideID = len(next)
		racers.append(racer)
		# djikstra yg agk random :v
		var vis := []
		var queue := []
		
		var inf = -1
		for i in n: vis.append(inf)
		queue.push_back(Vector3(0, 1, 1))
		while not queue.empty():
			queue.sort() # complexity ga penting lah ya :v
			var a : Vector3 = queue.pop_front()
			var d := a.x
			var u := int(a.y)
			var p := int(a.z)
			if vis[u] != inf: continue
			vis[u] = p
			for V in adj[u]:
				var v := int(V.x)
				if vis[v] != inf: continue
				queue.push_back(Vector3(d + V.y * (1 + randf() * 2), v, u))
		
		var nextarr = []
		for i in n: nextarr.push_back(-1)
		for i in n: nextarr[i] = vis[i]
		print(nextarr)
		next.append(nextarr)
		updatenext(racer.position, racer.guideID)
	
	$Timer.start()


func _on_Timer_timeout():
	for racer in racers:
		cekwall(racer)
