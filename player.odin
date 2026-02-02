package main

import gm "shared:ghst/math"
import rl "vendor:raylib"

Player :: struct {
	translation: Vec3,
}

move_player :: proc() {
	player := &world.player
	delta := rl.GetFrameTime()
	raw_delta: Vec2

	if rl.IsKeyDown(.W) {
		raw_delta.y += 1
	}
	if rl.IsKeyDown(.A) {
		raw_delta.x += 1
	}
	if rl.IsKeyDown(.D) {
		raw_delta.x -= 1
	}
	if rl.IsKeyDown(.S) {
		raw_delta.y -= 1
	}

	move_delta := gm.interpolate_lateral_vector(world.camera.rotation, raw_delta)
	player.translation += move_delta * 5 * delta
}
