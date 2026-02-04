package main

import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

Lockon_Data :: struct {
	screen_position: Vec2,
	on_screen:       bool,
}

target_overlay :: proc() {
	for e in world.entities {
		if e.on_screen {
			fmt.printfln("Column Screen Pos: %.0f, %.0f", e.screen_position.x, e.screen_position.y)
			rl.DrawCircleLinesV(e.screen_position, 50, rl.BLACK)
			entity_string := fmt.tprintf(
				"%v\n\t[%.2f, %.2f]",
				e.tag,
				e.screen_position.x,
				e.screen_position.y,
			)
			rl.DrawText(
				strings.clone_to_cstring(entity_string, allocator = context.temp_allocator),
				i32(e.screen_position.x),
				i32(e.screen_position.y),
				10,
				rl.BLACK,
			)
		}
	}
}
