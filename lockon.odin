package main

import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

target_overlay :: proc() {
	for e in world.entities {
		screen_position := rl.GetWorldToScreen(entity_center(e), world.camera.raw)
		rl.DrawCircleLinesV(screen_position, 50, rl.BLACK)
		entity_string := fmt.tprintf(
			"%v\n\t[%.2f, %.2f]",
			e.tag,
			screen_position.x,
			screen_position.y,
		)
		rl.DrawText(
			strings.clone_to_cstring(entity_string, allocator = context.temp_allocator),
			i32(screen_position.x),
			i32(screen_position.y),
			10,
			rl.BLACK,
		)
	}
}
