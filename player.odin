package main

spawn_player :: proc(pos: Vec2) {
	player := Entity {
		pos    = pos,
		traits = {.Character},
		kind   = .Player,
	}
	player_idx := add(player)
	world.entities.player_idx = player_idx
}
