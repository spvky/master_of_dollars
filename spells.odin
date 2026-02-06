package main

import "core:math"
import l "core:math/linalg"
import rl "vendor:raylib"

Rune_Wheel :: struct {
	runes:       [10]rune,
	rune_count:  int,
	spell:       [10]int,
	spell_count: int,
}

init_runes :: proc() {
	world.rune_wheel = Rune_Wheel {
		runes      = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'},
		rune_count = 10,
	}
}

draw_spell :: proc() {
	wheel := &world.rune_wheel
	if wheel.spell_count > 1 {
		for i in 0 ..< wheel.spell_count - 1 {
			a := calculate_rune_position(wheel.spell[i])
			b := calculate_rune_position(wheel.spell[i + 1])
			rl.DrawLineEx(a, b, 10, rl.YELLOW)
		}
	}
}

detect_rune_collision :: proc() {
	wheel := &world.rune_wheel
	pos := world.camera.cursor_pos
	for i in 0 ..< world.rune_wheel.rune_count {
		if !is_rune_in_spell(i) {
			rune_pos := calculate_rune_position(i)
			if l.distance(pos, rune_pos) < 100 {
				wheel.spell[wheel.spell_count] = i
				wheel.spell_count += 1
			}
		}
	}
}

reset_spell :: proc() {
	if rl.IsMouseButtonPressed(.LEFT) {
		world.rune_wheel.spell_count = 0
	}
}

is_rune_in_spell :: proc(index: int) -> (in_spell: bool) {
	if world.rune_wheel.spell_count > 0 {
		for i in 0 ..< world.rune_wheel.spell_count {
			if i == index {
				in_spell = true
				return
			}
		}
	}
	return
}

calculate_rune_position :: proc(index: int) -> Vec2 {
	wheel := &world.rune_wheel
	center := Vec2{f32(SCREEN_WIDTH) / 2, f32(SCREEN_HEIGHT) / 2}
	angle_diff := TAU / f32(wheel.rune_count)
	rune_theta := f32(index) * angle_diff
	radius := f32(SCREEN_HEIGHT) / 2
	return(
		Vec2{math.sin(rune_theta) * radius, math.cos(rune_theta) * radius} +
		center -
		Vec2{32, 32} \
	)
}


draw_rune_wheel :: proc() {
	wheel := &world.rune_wheel
	center := Vec2{f32(SCREEN_WIDTH) / 2, f32(SCREEN_HEIGHT) / 2}
	angle_diff := TAU / f32(wheel.rune_count)
	start_radius := f32(SCREEN_HEIGHT) / 2.2
	end_radius := f32(SCREEN_HEIGHT) / 2
	rl.DrawCircleLinesV(center, f32(SCREEN_HEIGHT) / 2, rl.BLUE)
	rl.DrawCircleLinesV(center, f32(SCREEN_HEIGHT) / 2.2, rl.BLUE)

	for i in 0 ..< wheel.rune_count {
		theta := f32(i) * angle_diff + (PI / f32(wheel.rune_count))
		start := Vec2{math.sin(theta) * start_radius, math.cos(theta) * start_radius} + center
		end := Vec2{math.sin(theta) * end_radius, math.cos(theta) * end_radius} + center
		rune_pos := calculate_rune_position(i)

		rl.DrawTextCodepoint(
			assets.font,
			wheel.runes[i],
			rune_pos,
			32,
			is_rune_in_spell(i) ? rl.YELLOW : rl.WHITE,
		)

		rl.DrawLineEx(start, end, 4, rl.WHITE)
	}
}

handle_rune_wheel :: proc() {
	detect_rune_collision()
	reset_spell()
}
