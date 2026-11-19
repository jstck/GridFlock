#!/usr/bin/env bash
# Gridfinity baseplate for an IKEA Maximera 80x60 drawer (inner area ~680 wide x 504 deep).
# 16 x 12 grid (680 x 504 mm, 4 mm padding left/right) made from 3 different pieces, each fitting a 280x280 bed.
#
# Seen from above, drawer front at the bottom, width left to right:
#
#   back:  B(6) C(5) A(5)
#   front: A(5) C(5) B(6)
#
#   A: 5 x 6 tiles, 4 mm padding on one side  print 2 (the second one is the same piece turned 180°)
#   B: 6 x 6 tiles, 4 mm padding on one side  print 2
#   C: 5 x 6 tiles, no padding                print 2
#
# A and B are the same pieces as in ../6060.
set -euo pipefail
cd "$(dirname "$0")"

OPENSCAD="${OPENSCAD:-$(command -v openscad || echo /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD)}"
ARGS=(
    -D 'plate_size=[504,680]'
    -D 'bed_size=[280,280]'
    -D 'y_row_counts=[6,5,5]'
    -D connector_symmetric=true
    -D numbering=false
    "$@"
)

"$OPENSCAD" -o layout.png --camera=0,0,0,0,0,90,1600 --imgsize=1000,700 "${ARGS[@]}" ../gridflock.scad
"$OPENSCAD" -o maximera-B.stl "${ARGS[@]}" -D segment_number=1 ../gridflock.scad &
"$OPENSCAD" -o maximera-C.stl "${ARGS[@]}" -D segment_number=2 ../gridflock.scad &
"$OPENSCAD" -o maximera-A.stl "${ARGS[@]}" -D segment_number=3 ../gridflock.scad &
wait
