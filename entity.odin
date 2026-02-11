package main

Idx :: distinct u16

Entity :: struct {
	pos:          Vec2,
	velocity:     Vec2,
	target:       Idx,
	idx:          Idx,
	parent_idx:   Idx,
	child_idx:    Idx,
	prev_sib_idx: Idx,
	next_sib_idx: Idx,
}

Trait :: enum u16 {
	Character,
	Pickup,
	Throwable,
	Grabable,
	Pocketable,
}

Allignment :: enum {
	Neutral,
	Friendly,
	Hostile,
}

Kind :: enum {
	Player,
	NPC,
}
