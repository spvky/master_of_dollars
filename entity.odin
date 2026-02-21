package main

import "core:log"
import rl "vendor:raylib"

Idx :: distinct u16

Entity :: struct {
	rigidbody:  Rigidbody,
	traits:     bit_set[Entity_Trait;u64],
	state:      bit_set[Entity_State],
	relations:  Entity_Relations,
	kind:       Entity_Kind,
	allignment: Entity_Allignment,
}

Entity_Relations :: struct {
	target:       Idx,
	prev_idx:     Idx,
	curr_idx:     Idx,
	parent_idx:   Idx,
	child_idx:    Idx,
	prev_sib_idx: Idx,
	next_sib_idx: Idx,
}

Entity_Trait :: enum u64 {
	Character,
	Auto_Pickup,
	Grabable,
	Pocketable,
	Throwable,
}

Entity_State :: enum u16 {
	Dead,
	Stunned,
	Burning,
	Wet,
}

Entity_Allignment :: enum {
	Neutral,
	Friendly,
	Hostile,
}

Entity_Kind :: union {
	Player_Data,
	Object_Data,
	NPC_Data,
}

entity_movement :: proc(delta: f32) {
	entities := &world.entities
	for i in 1 ..< entities.empty_slot {
		if entities.used[i] {
			rb := &entities.items[i].rigidbody
			rb.pos += rb.m_delta * rb.speed * delta
		}
	}
}

entity_idx_tracking :: proc() {
	entities := &world.entities
	for i in 1 ..< entities.empty_slot {
		if entities.used[i] {
			e := &entities.items[i]
			e.relations.prev_idx = e.relations.curr_idx
			e.relations.curr_idx = i

			//Handle idx mismatch here after movement
		}
	}
}

render_entities :: proc() {
	entities := world.entities
	for i in 1 ..< entities.empty_slot {
		if entities.used[i] && entities.items.relations[i].parent_idx == 0 {
			e := entities.items[i]
			switch v in e.kind {
			case Player_Data:
				rl.DrawCircleV(e.rigidbody.pos, 5, rl.BLUE)
			case Object_Data:
				render_object(e, v)
			case NPC_Data:
			}
		}
	}

}
