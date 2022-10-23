extends Node2D

onready var n : int = $Nodes.get_child_count()
onready var arr : Array = $Nodes.get_children()
onready var raycast := $RayCast2D

var adj := []
var balancer := []
var next := []
var racers := []

var colors := [
	Color("#bc0b22"),
	Color("#009900"),
	Color("#831bf9"),
	Color("#c16a00"),
	Color("#9e0962"),
	Color("#9e8b00"),
	Color("#1adde0"),
	Color("#ff991c")
]

func dist(a: Vector2, b: Vector2):
	return pow(a.distance_to(b), 1) 

func cekwall(racer: EnemyRacer) -> void:
	# cek apa bs ke nextnext?
	var X : Vector2 = (arr[racer.nextnext].position - racer.position).normalized().rotated(PI/2)
	for x in [-35, 0, 35]:
		var pos = racer.position + X * x
		raycast.position = pos
		raycast.cast_to = arr[racer.nextnext].position - pos
		raycast.force_raycast_update()
		if not raycast.is_colliding():
			racer.next = racer.nextnext
			racer.nextnext = next[racer.guideID][racer.nextnext]
			return
		
	# cek udh gbs ke next
	var flag = 0
	for x in [-35, 0, 35]:
		var pos = racer.position + X * x
		raycast.position = pos
		raycast.cast_to = arr[racer.next].position - pos
		raycast.force_raycast_update()
		if raycast.is_colliding():
			flag += 1
	if flag == 3:
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
#	print("jumlah titik:", n)
	# bikin grafnya
	for i in n: adj.append([])
	var ARR = []
	for i in n: ARR.append(0)
	for i in n: balancer.append(ARR.duplicate())
	
	for i in n: 
		var to := []
		for j in n:
			if i == j: continue
			raycast.position = arr[i].position
			raycast.cast_to = arr[j].position - arr[i].position
			raycast.force_raycast_update()
			if not raycast.is_colliding():
				var flag := 0
				for k in len(to):
					var u : Vector2 = arr[i].position
					var v : Vector2 = arr[j].position
					var w : Vector2 = arr[to[k]].position
					var d := (v-u).angle_to(w-u)
					if d < 0: d += PI * 2
					if d < deg2rad(25) or d > deg2rad(360-25):
						flag += 1
						if dist(v, u) < dist(w, u):
							to[k] = j
				if flag == 0:
					to.push_back(j)
#		print(i, to)
		for j in to:
			adj[j].append(Vector2(i, dist(arr[i].position, arr[j].position)))
			#adj[j].append(Vector2(i, dist(arr[i].position, arr[j].position)))
	
	# assign tiap enemies
	for racer in self.get_children():
		randomize()
		if racer.get("guideID") == null: continue
		racer.guideID = len(next)
		racer.racer_id = racer.guideID + 1
		racer.get_node("Polygon2D").color = colors[racer.guideID % len(colors)]
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
				queue.push_back(Vector3(d + (V.y) * (1 + balancer[u][v] * 2) * (1 + randf() * 2), v, u))
#			if u == 0: print(d)
		var t = 0
		while t != 1:
			balancer[t][vis[t]] += 1
			balancer[vis[t]][t] += 1
			t = vis[t]
			
		next.append(vis)
#		print(vis)
		updatenext(racer.position, racer.guideID)
		
	$Timer.start()


func _on_Timer_timeout():
	for racer in racers:
		cekwall(racer)
