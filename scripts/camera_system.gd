class_name CameraSystem
extends Control

signal bonnieMinigameResult(result : bool)

enum Animatronics {
	BONNIE,
	CHICA,
	FREDDY,
	FOXY
}



# Camera and button handlers
var cameraList : Array[TextureRect] 
var buttonList : Array[Button]
var currentCamera : int = 0
var unlockedButtonCounter : int = 0
var displayCameraStaticTimer : float = 0

# Animatronic minigame scenes
var bonnieGuitar : PackedScene = preload("res://scenes/CameraMinigames/bonnieGuitar.tscn")

# Where each of the animatronic minigames can take place
var animatronicSpawns : Dictionary[Animatronics, Array] = {
	Animatronics.BONNIE : [0,2,4,6],
	Animatronics.CHICA  : [1,3,5,7],
	Animatronics.FREDDY : [],
	Animatronics.FOXY	 : []
}

# Animatronic minigame variables
var activeGuitarRooms : Array[int] = []                   
var activeGuitarTimers : Array[float] = []


func _ready() -> void:
	for camera in $Cameras.get_children():
		cameraList.push_back(camera)
	for button in $CameraSelector/Buttons.get_children():
		buttonList.push_back(button)
	$disabledRectangle.visible = false
	cameraList[currentCamera].visible = true
	buttonList[unlockedButtonCounter].visible = true

func _process(delta : float) -> void:
	for cameraButton : Button in $CameraSelector/Buttons.get_children():
		if cameraButton.button_pressed && int(cameraButton.name) != currentCamera:
			changeCamera(int(cameraButton.name))
	handleTimers(delta)
	debug()

func toggle() -> void:
	self.visible = !self.visible
## A method that behins the find Bonnie's guitar minigame.
## roomNum: (-1) for a random, pool based room OR a manual room number. Selecting a room number may cause undesired behaviour.
## findTime: How long (in seconds) the player has to find the given guitar.
## returns whether it was able to spawn a guitar or not
func activateBonnie(roomNum : int, findTime : float) -> bool:
	if roomNum != -1:
		if activeGuitarRooms.has(roomNum):
			return false
		else:
			activeGuitarRooms.push_back(roomNum)
			activeGuitarTimers.push_back(findTime)
			spawnGuitar(roomNum)
			return true
	else:
		var randomRoom : int = animatronicSpawns[Animatronics.BONNIE][randi_range(0, animatronicSpawns[Animatronics.BONNIE].size()-1)] 
		var index : int = 0
		while activeGuitarRooms.has(randomRoom) || randomRoom > unlockedButtonCounter:
			if index == animatronicSpawns[Animatronics.BONNIE].size():
				return false
			randomRoom = animatronicSpawns[Animatronics.BONNIE][index] 
			index += 1
		activeGuitarRooms.push_back(randomRoom)
		activeGuitarTimers.push_back(findTime)
		spawnGuitar(randomRoom)
		return true
func spawnGuitar(roomNum : int) -> void:
	var guitar : BonnieGuitar = bonnieGuitar.instantiate()
	cameraList[roomNum].add_child(guitar)
	guitar.set_global_position(Vector2(randf_range(0,self.size.x*0.70),randf_range(100,self.size.y*0.70)))
func changeCamera(nextCamera : int) -> void:
	cameraList[currentCamera].visible = false
	currentCamera = nextCamera
	cameraList[currentCamera].visible = true
	$camaraChange.play()
	disableCameras(0.25)

func disableCameras(time : float) -> void:
	displayCameraStaticTimer = time
	$disabledRectangle.visible = true
	
func unlockNextButton() -> void:
	if unlockedButtonCounter < buttonList.size() -1:
		unlockedButtonCounter+=1
		buttonList[unlockedButtonCounter].visible = true


func handleTimers(delta : float) -> void:
	
	
	displayCameraStaticTimer = max(0, displayCameraStaticTimer-delta)
	if displayCameraStaticTimer == 0:
		$disabledRectangle.visible = false
	
	var i : int = activeGuitarTimers.size() - 1
	while i >= 0:
		activeGuitarTimers[i] -= delta
		if activeGuitarTimers[i] <= 0:
			var foundGuitar := false
			var room_index := activeGuitarRooms[i]

		# Check all children in the camera room
			for child in cameraList[room_index].get_children():
				if child is BonnieGuitar:
					foundGuitar = true
					child.queue_free()  
					break
			# Emit the result before removing array elements
			bonnieMinigameResult.emit(foundGuitar)
			# Remove the timer and room from arrays
			activeGuitarTimers.remove_at(i)
			activeGuitarRooms.remove_at(i)
		i -= 1
			
	
	
func debug() -> void:
	if Input.is_action_just_pressed("ui_left"):
		unlockNextButton()
	if Input.is_action_just_pressed("ui_right"):
		activateBonnie(-1, 10)
	


func _on_bonnie_minigame_result(result: bool) -> void:
	print("Player won minigame? " + str(result))


func _on_camera_button_pressed() -> void:
	toggle()
