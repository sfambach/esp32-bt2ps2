// Gehäuse für die zwei BT2PS2-Platinen (SMD und THT), zum 3D-Drucken.
// Maße aus den KiCad-Platinen gemessen (Platinenkoordinaten, Ursprung oben links, y nach unten;
// y = 0 ist die Antennenseite, y = Platinenhöhe die USB-Seite).
//
// Aufruf:
//   openscad -D variante=\"smd\" -D teil=\"schale\" -o schale.stl bt2ps2-gehaeuse.scad
//   openscad -D variante=\"tht\" -D teil=\"deckel\" -o deckel.stl bt2ps2-gehaeuse.scad
//
// Taster: 6 × 6 mm mit langem Schaft, Gesamthöhe ab Platine 17 mm ("6x6x17"). Der Schaft schliesst dann oben
// mit dem Deckel ab. Kürzere Schäfte (13 mm) erreichen den Deckel nicht.

variante = "smd";      // "smd" oder "tht"
teil     = "schale";   // "schale", "deckel" oder "beides"

$fn = 48;

// ── Platinen ───────────────────────────────────────────────────────────────────────────────────
smd = [61.1, 34.2];    // Breite, Höhe der Platine
tht = [83.1, 34.2];
platine  = variante == "tht" ? tht : smd;
pb = platine[0];
ph = platine[1];

// Innenhöhe über der Platine: THT braucht mehr (TO-220 stehend, Elkos, Taster)
innen_h  = 15;   // höchstes Teil ist die USB-Buchse des D1 mini (12,1 mm über der Platine)

wand     = 2.0;    // Wandstärke
boden    = 2.0;    // Bodenstärke
deckel_d = 2.0;    // Deckelstärke
luft     = 0.6;    // Luft um die Platine
stuetze  = 4.0;    // Höhe der Platine über dem Boden (Platz für Lötstellen und Teile unten)
dicke    = 1.6;    // Platinendicke
oben_frei   = 7.0; // Überstand der Antenne über die Platinenkante (Modul ragt hinaus)
unten_frei  = 4.6; // Überstand des D1 mini mit USB-Buchse
links_frei  = 6.0; // Streifen neben der Platine für die zwei linken Deckelsäulen (über der Platine ist kein Platz:
                   // das Modul deckt dort die ganze Breite ab)

// Innenraum in Platinenkoordinaten
ix0 = -luft - links_frei;   ix1 = pb + luft;
iy0 = -oben_frei;       iy1 = ph + unten_frei;
iw  = ix1 - ix0;        ih = iy1 - iy0;

// ── Merkmale (Mitte der Courtyard-Felder aus KiCad) ────────────────────────────────────────────
// [x, y] bzw. [x, y, breite, tiefe]
usb        = [17.05, ph];                       // Mitte der USB-Buchse an der Unterkante
taster     = variante == "tht" ? [[58.30, 24.80], [68.80, 24.80]] : [[37.80, 23.80], [47.80, 23.80]];
led        = variante == "tht" ? [67.60, 16.55] : [47.55, 31.55];
led_d      = variante == "tht" ? 3.6 : 3.0;
j1         = [42.80, 5.08, 14.5, 8.0];          // JST-Stecker: Kabel geht nach oben heraus
jp1        = variante == "tht" ? [35.05, 12.30, 6.0, 9.0] : [35.55, 13.30, 6.0, 9.0];
j3         = variante == "tht" ? [77.55, 25.35, 6.0, 13.5] : [39.35, 31.55, 13.0, 6.0];
loecher    = variante == "tht" ? [[49.05, 16.05], [49.05, 28.05]] : [[57.55, 4.55], [57.55, 30.15]];

schraube_d = 3.2;   // M3 durch die Platine
dom_d      = 6.0;   // Außendurchmesser der Stütze
kern_d     = 2.5;   // Kernloch für M3-Blechschraube

// Ecken des Deckels: vier Schrauben in die Ecksäulen. Alle vier stehen ausserhalb der Platine — links im
// Streifen, rechts in den Überständen oben und unten, wo das Modul nicht hinreicht.
ecken = [[ix0 + 3.2, iy0 + 3.4], [ix1 - 3.4, iy0 + 3.4], [ix0 + 3.2, iy1 - 3.4], [ix1 - 3.4, iy1 - 3.4]];
// Zwei Auflager ohne Schraube, damit die Platine nicht kippt (unter bauteilfreien Stellen)
auflager = [[3.0, 3.0], [3.0, 31.0]];

module aussen(h) {
    translate([ix0 - wand, iy0 - wand, 0])
        cube([iw + 2 * wand, ih + 2 * wand, h]);
}

module innen(h) {
    translate([ix0, iy0, boden]) cube([iw, ih, h]);
}

// Durchbrüche in der Seitenwand (y = ih-Seite) für die USB-Buchse
module usb_loch() {
    // Platinenoberkante + Buchsenleiste 8,5 + Modulplatine 1,0 = Unterkante der Buchse; Buchse 2,6 hoch.
    z = boden + stuetze + dicke + 9.5;
    translate([usb[0] - 7.5, iy1 - 1, z - 1.6])
        cube([15, wand + 4, 6.0]);
}

module dom(x, y, h, innen_d) {
    translate([x, y, boden]) difference() {
        cylinder(d = dom_d, h = h);
        translate([0, 0, 1]) cylinder(d = innen_d, h = h);
    }
}

module schale() {
    difference() {
        union() {
            difference() {
                aussen(boden + stuetze + dicke + innen_h);
                innen(stuetze + dicke + innen_h + 1);
                usb_loch();
            }
            // Stützen für die Platine (Schraublöcher) und Ecksäulen für den Deckel
            for (l = loecher) dom(l[0], l[1], stuetze, kern_d);
            for (a = auflager) translate([a[0], a[1], boden]) cylinder(d = dom_d, h = stuetze);
            for (e = ecken) dom(e[0], e[1], stuetze + dicke + innen_h, kern_d);
        }
        // Antennenbereich dünn halten ist nicht nötig, aber Luft unter der Platine für Bauteile:
        translate([ix0 + 2, iy0 + 2, boden]) cube([iw - 4, oben_frei - 2, stuetze]);
    }
}

module deckel() {
    difference() {
        union() {
            translate([ix0 - wand, iy0 - wand, 0]) cube([iw + 2 * wand, ih + 2 * wand, deckel_d]);
            // Rand, der in die Schale greift
            translate([ix0 + 0.3, iy0 + 0.3, -1.5]) difference() {
                cube([iw - 0.6, ih - 0.6, 1.5]);
                translate([1.2, 1.2, -0.1]) cube([iw - 3.0, ih - 3.0, 1.7]);
            }
        }
        for (e = ecken) translate([e[0], e[1], -2]) cylinder(d = 3.4, h = 10);
        // Der umlaufende Rand darf nicht in die Ecksäulen laufen
        for (e = ecken) translate([e[0], e[1], -2]) cylinder(d = dom_d + 1.0, h = 3.4);
        for (e = ecken) translate([e[0], e[1], deckel_d - 1.2]) cylinder(d1 = 3.4, d2 = 6.2, h = 1.3);
        for (t = taster) translate([t[0], t[1], -2]) cylinder(d = 4.6, h = 10);
        translate([led[0], led[1], -2]) cylinder(d = led_d, h = 10);
        for (o = [j1, jp1, j3])
            translate([o[0] - o[2] / 2, o[1] - o[3] / 2, -2]) cube([o[2], o[3], 10]);
    }
}

if (teil == "schale" || teil == "beides") schale();
if (teil == "deckel") deckel();
if (teil == "beides") translate([0, 0, boden + stuetze + dicke + innen_h + 6]) deckel();
