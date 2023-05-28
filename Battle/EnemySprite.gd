extends Sprite2D

@onready var bs : Control = get_node("/root/BattleScene")

#OPTIMIZE almost same code as the PlayerSprite
func animate() -> void: #ADD animation in input. Now the animation is the same for every monster
	var tw : Tween = create_tween()
	var position : Vector2
	position = self.position
	tw.tween_property(self, "position", position - Vector2(50,0), 0.2)
	position -= Vector2(50,0)
	tw.tween_property(self, "position", position + Vector2(50,0), 0.3)
	await get_tree().create_timer(1).timeout

func enemy_turn() -> void:
	bs.get_node("AttackMenu").visible = false
	bs.compute_attack(bs.enemy, bs.player, bs.enemy.moves[bs.rng.randi_range(0,3)])
	await get_tree().create_timer(bs.HP_BAR_SPEED + 1).timeout
	bs.get_node("DescriptionBox").visible = false
