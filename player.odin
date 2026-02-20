package main

import l "core:math/linalg"
import rl "vendor:raylib"

init_player :: proc(entities: ^Entity_Manager) {
	spawn_player(entities, {50, 50})
}

get_player :: proc() -> Entity_Ptr {
	return get(&world.entities, world.entities.player_idx)
}

spawn_player :: proc(entities: ^Entity_Manager, pos: Vec2) {
	player := Entity {
		rigidbody = {pos = pos, speed = 100},
		traits = {.Character},
		kind = .Player,
	}
	player_idx := add(entities, player)
	entities.player_idx = player_idx
}

set_player_move_delta :: proc() {
	player := get_player()
	move_delta: Vec2
	if rl.IsKeyDown(.W) {move_delta.y -= 1}
	if rl.IsKeyDown(.S) {move_delta.y += 1}
	if rl.IsKeyDown(.A) {move_delta.x -= 1}
	if rl.IsKeyDown(.D) {move_delta.x += 1}
	player.rigidbody.m_delta = l.normalize0(move_delta)
}
