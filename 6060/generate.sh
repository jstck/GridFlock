#!/usr/bin/env bash
# Gridfinity baseplate for an IKEA Maximera 60x60 drawer (inner area ~480 wide x 504 deep).
# 11 x 12 grid (470 x 504 mm, 4 mm padding left/right) made from 2 different pieces, each fitting a 280x280 bed.
#
# Seen from above, drawer front at the bottom, width left to right:
#
#   back:  B(6) A(5)
#   front: A(5) B(6)
#
#   A: 5 x 6 tiles  print 2 (the second one is the same piece turned 180°)
#   B: 6 x 6 tiles  print 2
#
# A and B are the same pieces as in ../8060.
set -euo pipefail
cd "$(dirname "$0")"

OPENSCAD="${OPENSCAD:-$(command -v openscad || echo /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD)}"
ARGS=(
    -D 'plate_size=[504,470]'
    -D 'bed_size=[280,280]'
    -D 'y_row_counts=[6,5]'
    -D connector_symmetric=true
    -D numbering=false
    "$@"
)

"$OPENSCAD" -o layout.png --camera=0,0,0,0,0,90,1300 --imgsize=900,800 "${ARGS[@]}" ../gridflock.scad
"$OPENSCAD" -o maximera-B.stl "${ARGS[@]}" -D segment_number=1 ../gridflock.scad &
"$OPENSCAD" -o maximera-A.stl "${ARGS[@]}" -D segment_number=2 ../gridflock.scad &
wait
