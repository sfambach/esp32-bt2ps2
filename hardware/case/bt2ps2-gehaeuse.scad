// Gehäuse für die zwei BT2PS2-Platinen (SMD und THT), zum 3D-Drucken.
// Maße aus den KiCad-Platinen gemessen (Platinenkoordinaten, Ursprung oben links, y nach unten;
// y = 0 ist die Antennenseite, y = Platinenhöhe die USB-Seite).
//
// Aufbau: waagerecht geteilt. Das Unterteil ist eine flache Wanne, das Oberteil ein Rahmen mit Deckplatte.
// Vier Schrauben M3 kommen von unten durch das Unterteil und ziehen in die Säulen des Oberteils.
// Zwei davon gehen durch die Montagelöcher der Platine — die Platine hängt also an der Gehäuseverschraubung.
//
// Aufruf:
//   openscad -D 'variante="smd"' -D 'teil="unterteil"' -o unterteil.stl bt2ps2-gehaeuse.scad
//   openscad -D 'variante="tht"' -D 'teil="oberteil"'  -o oberteil.stl  bt2ps2-gehaeuse.scad
//
// Taster: 6 × 6 mm mit langem Schaft, Gesamthöhe ab Platine 17 mm ("6x6x17"). Der Schaft schliesst dann oben
// mit der Deckplatte ab. Kürzere Schäfte (13 mm) erreichen sie nicht.

variante = "smd";        // "smd" oder "tht"
teil     = "unterteil";  // "unterteil", "oberteil" oder "beides"

$fn = 48;

// ── Platinen ───────────────────────────────────────────────────────────────────────────────────
smd = [49.1, 31.1];      // Breite, Höhe der Platine (V2)
tht = [83.1, 34.2];
platine = variante == "tht" ? tht : smd;
pb = platine[0];
ph = platine[1];

wand     = 2.0;    // Wandstärke
boden    = 2.0;    // Bodenstärke des Unterteils
deckel_d = 2.0;    // Deckplatte des Oberteils
luft     = 0.6;    // Luft um die Platine
stuetze  = 4.0;    // Platine über dem Boden (Platz für Lötstellen und Teile unten)
dicke    = 1.6;    // Platinendicke
innen_h  = 15.0;   // Luft über der Platine (höchstes Teil: USB-Buchse des D1 mini, 12,1 mm)

// SMD V2: kein D1 mini mehr, das WROOM liegt quer, die Antenne ragt links 5,75 mm über die Platine.
oben_frei  = variante == "tht" ? 7.0 : 3.0;  // THT: Überstand der Antenne über die Platinenkante
unten_frei = variante == "tht" ? 4.6 : 3.0;  // THT: Überstand des D1 mini mit der USB-Buchse
links_frei = variante == "tht" ? 6.0 : 7.5;  // Streifen links: Schraubsäulen (SMD: dazu die Antenne)

// Höhen über dem Boden (Aussenkante Unterteil = 0)
pl_u   = boden + stuetze;                 // Unterkante Platine   = 6,0
pl_o   = pl_u + dicke;                    // Oberkante Platine    = 7,6
h_ges  = pl_o + innen_h + deckel_d;       // Gesamthöhe           = 24,6
naht   = 12.0;                            // Trennebene, ungefähr auf halber Höhe

// Innenraum in Platinenkoordinaten
ix0 = -luft - links_frei;   ix1 = pb + luft;
iy0 = -oben_frei;           iy1 = ph + unten_frei;
iw  = ix1 - ix0;            ih  = iy1 - iy0;

// ── Merkmale (Mitte der Courtyard-Felder aus KiCad) ────────────────────────────────────────────
usb     = variante == "tht" ? [17.05, ph] : undef;   // SMD V2 hat keine USB-Buchse
taster  = variante == "tht" ? [[58.30, 24.80], [68.80, 24.80]] : [[26.90, 26.70], [36.90, 26.70]];
led     = variante == "tht" ? [67.60, 16.55] : [35.85, 2.35];
led_d   = variante == "tht" ? 3.6 : 3.0;
j1      = variante == "tht" ? [42.80, 5.08, 14.5, 8.0] : [45.27, 15.30, 8.0, 14.5];   // JST-Stecker: Kabel geht nach oben heraus
jp1     = variante == "tht" ? [35.05, 12.30, 6.0, 9.0] : [39.35, 8.82, 6.0, 9.0];
j3      = variante == "tht" ? [77.55, 25.35, 6.0, 13.5] : [27.86, 2.35, 13.0, 6.0];

// Die zwei Montagelöcher der Platine — hier hält dieselbe Schraube Platine und Gehäuse zusammen
platinen_loecher = variante == "tht" ? [[49.05, 16.05], [49.05, 28.05]] : [[45.55, 3.55], [45.55, 27.55]];
// Die zwei übrigen Schrauben stehen im linken Streifen, wo das Modul nicht hinreicht
rand_loecher = [[ix0 + 3.4, iy0 + 3.6], [ix0 + 3.4, iy1 - 3.6]];
schrauben = concat(platinen_loecher, rand_loecher);
// Auflager ohne Schraube, damit die Platine nicht kippt
auflager = variante == "tht" ? [[3.0, 3.0], [3.0, 31.0], [78.0, 3.0], [78.0, 31.0]] : [[3.0, 3.0], [3.0, 28.0]];

dom_d  = 6.4;    // Aussendurchmesser der Säulen
durch  = 3.4;    // Durchgangsloch M3
kern   = 2.5;    // Kernloch M3 (Blechschraube)
kopf_d = 6.4;    // Senkung für den Schraubenkopf im Boden
kopf_h = 2.0;

// ── Bausteine ──────────────────────────────────────────────────────────────────────────────────
module schale(h) {                 // Aussenkörper von z = 0 bis h
    translate([ix0 - wand, iy0 - wand, 0]) cube([iw + 2 * wand, ih + 2 * wand, h]);
}

module hohlraum(z0, z1) {
    translate([ix0, iy0, z0]) cube([iw, ih, z1 - z0]);
}

module usb_loch() {                // Ausschnitt in der Seitenwand, in Gehäusehöhen
    z = pl_o + 8.5 + 1.0;          // Buchsenleiste + Modulplatine = Unterkante der Buchse
    translate([usb[0] - 7.5, iy1 - 1, z - 1.6]) cube([15, wand + 4, 6.0]);
}

// ── Unterteil: Wanne bis zur Naht, Säulen mit Durchgangsloch, Senkung im Boden ─────────────────
module unterteil() {
    difference() {
        union() {
            difference() {
                schale(naht);
                hohlraum(boden, naht + 1);
            }
            // Säulen bis Unterkante Platine; die Platine liegt darauf
            for (s = schrauben) translate([s[0], s[1], boden]) cylinder(d = dom_d, h = stuetze);
            for (a = auflager) translate([a[0], a[1], boden]) cylinder(d = dom_d, h = stuetze);
        }
        for (s = schrauben) {
            translate([s[0], s[1], -1]) cylinder(d = durch, h = pl_u + 2);
            translate([s[0], s[1], -0.1]) cylinder(d = kopf_d, h = kopf_h);   // Senkung für den Kopf
        }
    }
}

// ── Oberteil: Rahmen mit Deckplatte; Säulen greifen bis auf die Platine hinunter ───────────────
module oberteil() {
    hoehe = h_ges - naht;          // eigene Höhe
    dz    = naht;                  // Gehäusehöhe = eigene Höhe + dz
    difference() {
        union() {
            difference() {
                translate([0, 0, 0]) schale(hoehe);
                hohlraum(-1, hoehe - deckel_d);
                if (variante == "tht") translate([0, 0, -dz]) usb_loch();
            }
            // Rand, der in das Unterteil greift
            translate([ix0 + 0.3, iy0 + 0.3, -1.5]) difference() {
                cube([iw - 0.6, ih - 0.6, 1.5]);
                translate([1.2, 1.2, -0.1]) cube([iw - 3.0, ih - 3.0, 1.7]);
            }
            // Säulen von der Deckplatte bis auf die Platine (bzw. bis auf die Säule des Unterteils)
            for (s = platinen_loecher) translate([s[0], s[1], pl_o - dz]) cylinder(d = dom_d, h = hoehe - deckel_d - (pl_o - dz));
            for (s = rand_loecher)     translate([s[0], s[1], pl_u - dz]) cylinder(d = dom_d, h = hoehe - deckel_d - (pl_u - dz));
        }
        // Kernloch durch alle Säulen, von unten offen
        for (s = schrauben) translate([s[0], s[1], pl_u - dz - 1]) cylinder(d = kern, h = hoehe);
        for (t = taster) translate([t[0], t[1], hoehe - deckel_d - 1]) cylinder(d = 4.6, h = 10);
        translate([led[0], led[1], hoehe - deckel_d - 1]) cylinder(d = led_d, h = 10);
        for (o = [j1, jp1, j3])
            translate([o[0] - o[2] / 2, o[1] - o[3] / 2, hoehe - deckel_d - 1]) cube([o[2], o[3], 10]);
    }
}

if (teil == "unterteil" || teil == "beides") unterteil();
if (teil == "oberteil") oberteil();
if (teil == "beides") translate([0, 0, naht + 8]) oberteil();
