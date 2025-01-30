extends CharacterBody2D

var rockRes = preload("res://rock.tscn");
var bulletRes = preload("res://bullet.tscn");

const SPEED = 300.0
var rotVel = 0;
var speed = 500;
var tmp = 0;
var accel = 0;
var maxAccel = 16;
var timer = 0.0;
var chance = 0.0;
var cooldown = 0.3;
var shootTimer = 0;
var timerScore = 0.0;
var score = 0;
var dead = false;
var spawnDelay = 10.0;
var difficultyTimer = 0.0;

func _ready() -> void:
	rotation = deg_to_rad(randf() * 360);
	velocity = Vector2(1, 0).rotated(rotation) * randf() * 100;
	rotation = 0;
	pass;

func _physics_process(delta: float) -> void:
	
	$"../Control/score".text = str(score);
	
	timer += delta;
	timerScore += delta;
	difficultyTimer += delta;
	
	if difficultyTimer >= 10:
		difficultyTimer = 0;
		spawnDelay *= 0.8;
	
	if timerScore >= 1:
		if !dead:
			score += 10;
		timerScore = 0;
	
	if shootTimer >= 0:
		shootTimer -= delta;
	
	if timer > spawnDelay:
		timer = 0.0
		if !dead:
			chance = randf();
			var rock = rockRes.instantiate();
			if chance > 0.5:
				rock.position = Vector2(randf() * 480, -480); 
			else:
				rock.position = Vector2(-480, randf() * 480); 
			$"..".add_child(rock);
			print("spawned rock")
	
	if position.x >= 450:
		position.x = -450;
	elif position.x <= -450:
		position.x = 450;
		
	if position.y >= 450:
		position.y = -450;
	elif position.y <= -450:
		position.y = 450;
	
	if rotVel < -1 or rotVel > 1:
		rotVel *= 0.98;
	#speed = 0.95;
	accel *= 0.95;
	
	#print(velocity.length());
	#print(velocity);
	
	if velocity.length() >= speed:
		#velocity *= Vector2(0.95, 0).rotated(rotation);
		velocity *= Vector2(0.95, 0.95);
	
	if !dead:
		if Input.is_action_pressed("forward") and accel <= maxAccel and velocity.length() < speed:
			accel += 2;
			velocity += Vector2(1, 0).rotated(rotation) * accel;
			$GPUParticles2D.emitting = true;
			
		if Input.is_action_just_released("forward"):
			$GPUParticles2D.emitting = false;
		
		if Input.is_action_pressed("left") and rotVel > -4:
			rotVel -= 0.3;
			
		if Input.is_action_pressed("right") and rotVel < 4:
			rotVel += 0.3;
		
		if Input.is_action_pressed("shoot") and shootTimer < 0:
			shootTimer = cooldown;
			var bullet = bulletRes.instantiate();
			bullet.position = position;
			bullet.rotation = rotation;
			$"..".add_child(bullet);
	
	
	rotation += deg_to_rad(rotVel);
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("rock"):
		dead = true;
		$"../Control/dead".visible = true;
		$Sprite2D.visible = false;
		await get_tree().create_timer(3).timeout;
		queue_free();
	pass # Replace with function body.
