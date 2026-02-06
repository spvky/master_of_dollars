package main

import "core:fmt"
import "core:math"
import l "core:math/linalg"
import "core:strings"
import rl "vendor:raylib"

Lockon_Data :: struct {
	screen_position: Vec2,
	on_screen:       bool,
}

target_overlay :: proc() {
	for e in world.entities {
		if e.on_screen {
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

draw_rune_wheel :: proc() {
	center := Vec2{f32(SCREEN_WIDTH) / 2, f32(SCREEN_HEIGHT) / 2}
	angle_diff := TAU / 10
	start_radius := f32(SCREEN_HEIGHT) / 2.2
	end_radius := f32(SCREEN_HEIGHT) / 2
	rl.DrawCircleLinesV(center, f32(SCREEN_HEIGHT) / 2, rl.BLUE)
	rl.DrawCircleLinesV(center, f32(SCREEN_HEIGHT) / 2.2, rl.BLUE)

	for i in 0 ..< 10 {
		theta := f32(i) * angle_diff + (PI / 10)
		start := Vec2{math.sin(theta) * start_radius, math.cos(theta) * start_radius} + center
		end := Vec2{math.sin(theta) * end_radius, math.cos(theta) * end_radius} + center

		rl.DrawLineEx(start, end, 4, rl.WHITE)
	}
}

draw_crosshair :: proc() {
	crosshair_pos := world.camera.cursor_pos

	source := rl.Rectangle {
		x      = 0,
		y      = 0,
		width  = 32,
		height = 32,
	}
	dest := rl.Rectangle {
		x      = crosshair_pos.x - 64,
		y      = crosshair_pos.y - 64,
		width  = 128,
		height = 128,
	}
	rl.DrawTexturePro(assets.crosshair, source, dest, {0, 0}, 0, rl.WHITE)
}
