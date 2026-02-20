package main

import "core:log"
import rl "vendor:raylib"

Vec2 :: [2]f32

game_init :: proc() {
	rl.SetConfigFlags({.WINDOW_RESIZABLE})
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Kick man")
	init_world()
	init_assets()
	init_entity_manager(&world.entities)
	init_player(&world.entities)
	log.infof("Entitites Size: %v kb", size_of(Entity_Manager) / 1024)
}

game_update :: proc() {
	if rl.IsKeyPressed(.SPACE) {
		write_entities_to_file(world.entities)
	}
	player := get_player()
	delta := rl.GetFrameTime()
	set_player_move_delta()
	entity_movement(delta)
	entity_idx_tracking()
	render()
}

game_cleanup :: proc() {
	cleanup_assets()
}
