#!/bin/bash
# Renders every cam (assembly + body) and the universal ring to stls/.
# Always re-renders, so the STL files never lag behind the SCAD library.
#
# Usage (from the repository root):
#   tools/render_all_stls.sh                 # uses $OPENSCAD, ./openscad.AppImage or openscad from PATH
#   OPENSCAD=/path/to/openscad tools/render_all_stls.sh
#   JOBS=8 tools/render_all_stls.sh
#
# OpenSCAD 2024+ with the Manifold backend is ~100x faster than 2021.01.
set -e

cd "$(dirname "$0")/.."

if [ -z "$OPENSCAD" ]; then
  if [ -x ./openscad.AppImage ] && [ "$(uname -s)" = "Linux" ]; then
    OPENSCAD=./openscad.AppImage
  else
    OPENSCAD=openscad
  fi
fi

EXTRA=""
if "$OPENSCAD" --help 2>&1 | grep -q -- "--backend"; then
  EXTRA="--backend=manifold"
fi

JOBS="${JOBS:-4}"
export OPENSCAD EXTRA

mkdir -p stls
echo "OpenSCAD: $OPENSCAD $EXTRA, $JOBS parallel jobs"

ls models/measured_parametric_single_v1/cam_*.scad models/measured_parametric_single_v1/universal_ring.scad |
  xargs -P "$JOBS" -I {} bash -c '
    name=$(basename "{}" .scad)
    if "$OPENSCAD" $EXTRA --export-format binstl -o "stls/${name}.stl" "{}" > "stls/.${name}.log" 2>&1; then
      echo "OK    $name"
      rm -f "stls/.${name}.log"
    else
      echo "ERROR $name (see stls/.${name}.log)"
      exit 1
    fi
  '

echo "All rendering complete."
