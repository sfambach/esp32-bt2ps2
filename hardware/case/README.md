# 3D-printed enclosures

One OpenSCAD file, one enclosure per board. Each is **split horizontally at half height**: a bottom tray and a top frame with the cover plate.

| | SMD board | THT D1 mini | THT WROOM | old combined THT board |
|---|---|---|---|---|
| `variante` | `smd` | `tht-d1` | `tht-wroom` | `tht` |
| Assembled, outer | 61.8 × 41.1 × 24.6 mm (board V2) | 71.2 × 49.8 × 24.6 mm | 74.2 × 58.0 × 24.6 mm | 94.3 × 49.8 × 24.6 mm |
| STL | `bt2ps2-smd-unterteil.stl` (bottom), `bt2ps2-smd-oberteil.stl` (top) | `bt2ps2-tht-d1-*.stl` | `bt2ps2-tht-wroom-*.stl` | `bt2ps2-tht-*.stl` |

All parts: bottom 12.0 mm, top 12.6 mm tall.

![SMD enclosure](vorschau-smd.png)

**SMD board V2:** no USB socket any more; the box is wider on the left for the WROOM antenna (5.75 mm over the board edge, no screw underneath).

THT boards: the box is larger than the board because the module sticks out: the WROOM antenna or the D1 mini's
board (7 mm of air, no screw underneath) and, on the D1 mini board, its USB socket (4.6 mm, cutout in the side wall).
The D1 mini box has no button, LED or J3 openings; the WROOM box has J3 at the front edge.

| THT D1 mini | THT WROOM |
|---|---|
| ![THT D1 mini enclosure](vorschau-tht-d1.png) | ![THT WROOM enclosure](vorschau-tht-wroom.png) |

**How it holds together:** four M3 screws, all from below. They pass through the bottom tray into columns that hang
down from the top cover. **Two of them go through the board's mounting holes** — the board sits on a 4 mm post of
the bottom part and the column of the top part presses on it, so board and case share the same screw. The other two
stand in the free strip left of the board. Screw heads sit in countersinks, so the case stands flat.

**Openings in the top part:** two buttons (⌀4.6 mm), LED (⌀3.0 mm SMD board, ⌀3.6 mm THT board), the JST connector J1 (the
cable leaves through it), the 5 V jumper JP1, and the programming header J3. **USB** is a cutout in the side wall
at socket height.

**You need:** tactile switches **6 × 6 mm with a long plunger, 17 mm overall** ("6x6x17") — then the plunger ends
flush with the cover; and four M3 × 16 self-tapping screws (2.5 mm pilot holes); M3 × 12 works too.

**Rebuild or modify** — wall thickness, inner height, clearances and every cutout are parameters at the top of
[`bt2ps2-gehaeuse.scad`](bt2ps2-gehaeuse.scad):

```bash
openscad -D 'variante="smd"' -D 'teil="unterteil"' -o bt2ps2-smd-unterteil.stl bt2ps2-gehaeuse.scad
```

`variante` is `smd`, `tht-d1`, `tht-wroom` or `tht`, `teil` is `unterteil` (bottom), `oberteil` (top) or `beides` (both, for viewing only).
Print the top part upside down — the columns then point upwards and need no supports.

> ⚠️ **Untested like the boards:** dimensions are taken from the KiCad files, but nothing has been printed or
> fitted yet. Print a test corner with one screw post and one button hole first.
