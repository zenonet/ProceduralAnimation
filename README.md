# Procedural Animation

This is an experiment. I tried implementing procedurally animated walking in the godot game engine. I only used default default Godot nodes. (this heavily relies on Godots SkeletonIK3D node) No third-party-assets, no tutorials.
This is fully written in GDScript.

## Controls

WASD or Arrow Keys - Movement<br>
E/Q - rotate left/right<br>
C/V - move the body down/up

## How it works

The robot body has 4 inversed-kinematics-controlled legs. Each leg has an optimal position which is determined by a raycast down to the ground. When the player moves the robot. The starting positions of these raycasts are moved in the direction, the player wants to move.
When a leg is too far away from its optimal position, it takes a step to it meaning when moving forward, the legs step forward. The body isn't moved by the player directly. Instead, the bodys horizontal position is always the average horizontal posistion of all feet.
The vertical position also evaluated like this but an offset is applied to keep the body above the feet. This way of moving the body based on feet position ensures that the body never surpasses the feet positions horizontally and mimics realistic behaviour.
