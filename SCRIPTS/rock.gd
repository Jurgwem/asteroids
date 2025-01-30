extends CharacterBody2D

var rockRes = preload("res://INSTANCES/rock.tscn");
@onready var game = get_node("/root/game");
@onready var player = get_node("/root/game/player");

var chance = 0;
var rot = 0.0;
var type = 0;
var direction = 0;
var speed = 0.0;

func _ready() -> void:
	if chance == 0:
		chance = randf();
	if chance > 0.66:
		scale = Vector2(1, 1)
		$AnimatedSprite2D.frame = 0;
		type = 3;
	elif chance > 0.33:
		scale = Vector2(0.75, 0.75)
		$AnimatedSprite2D.frame = 1;
		type = 2;
	else:
		scale = Vector2(0.5, 0.5)
		$AnimatedSprite2D.frame = 2;
		type = 1;
	pass
	
	chance = randf()
	rot = 1 + (randf() / 2);
	if chance > 0.5:
		rot *= -1;
		
	direction = randf() * 360;
	rotation = deg_to_rad(direction);
	
	speed = 10 + randf() * 100;

func _physics_process(_delta: float) -> void:
	if position.x >= 480:
		position.x = -480;
	elif position.x <= -480:
		position.x = 480;
		
	if position.y >= 480:
		position.y = -480;
	elif position.y <= -480:
		position.y = 480;
	
	velocity = Vector2(1, 0).rotated(rotation) * speed;
	$AnimatedSprite2D.rotation += deg_to_rad(rot);
	move_and_slide()
	
func hit() -> void:
	player.score += 50;
	print("hit")
	$CollisionShape2D.queue_free();
	$AnimatedSprite2D.visible = false;
	$GPUParticles2D.emitting = true;
	var newType = 0.0;
	if type != 1:
		if type == 3:
			newType = 0.5;
		else:
			newType = 0.25;
		call_deferred("spawnNew", newType, 10);
		call_deferred("spawnNew", newType, -10);
	await get_tree().create_timer(2).timeout;
	queue_free();
	pass

func spawnNew(spawnType, pos) -> void:
	var rock2 = rockRes.instantiate();
	rock2.chance = spawnType;
	rock2.global_position = global_position + Vector2(pos, 0);
	game.add_child(rock2);
	pass
