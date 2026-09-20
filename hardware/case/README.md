# 3D-printed enclosures

One OpenSCAD file, two enclosures (SMD and THT board), each a shell plus a lid.

| | SMD board | THT board |
|---|---|---|
| Shell, outer | 72.3 × 49.8 × 22.6 mm | 94.3 × 49.8 × 22.6 mm |
| With lid | 24.6 mm tall | 24.6 mm tall |
| STL | `bt2ps2-smd-schale.stl` (shell), `bt2ps2-smd-deckel.stl` (lid) | `bt2ps2-tht-schale.stl`, `bt2ps2-tht-deckel.stl` |

![SMD enclosure](vorschau-smd.png)

The box is larger than the board because the ESP32 module sticks out at both ends: the antenna (7 mm of air, no
copper and no screw underneath) and the D1 mini's USB socket (4.6 mm).

**Lid openings:** two buttons (⌀4.6 mm), LED (⌀3.0 mm SMD board, ⌀3.6 mm THT board), the JST connector J1 (the
cable leaves through it), the 5 V jumper JP1, and the programming header J3. **USB** is a cutout in the side wall
at socket height.

**You need:** tactile switches **6 × 6 mm with a long plunger, 17 mm overall** ("6x6x17") — then the plunger ends
flush with the lid; four M3 × 10 self-tapping screws for the lid (2.5 mm pilot holes) and two M3 × 6 for the board,
which rests on 4 mm posts.

**Rebuild or modify** — wall thickness, inner height, clearances and every cutout are parameters at the top of
[`bt2ps2-gehaeuse.scad`](bt2ps2-gehaeuse.scad):

```bash
openscad -D 'variante="smd"' -D 'teil="schale"' -o bt2ps2-smd-schale.stl bt2ps2-gehaeuse.scad
```

`variante` is `smd` or `tht`, `teil` is `schale` (shell), `deckel` (lid) or `beides` (both, for viewing only).

> ⚠️ **Untested like the boards:** dimensions are taken from the KiCad files, but nothing has been printed or
> fitted yet. Print a test corner with one screw post and one button hole first.
