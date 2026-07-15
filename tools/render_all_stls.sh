#!/bin/bash
set -e

mkdir -p stls

echo "Starting headless OpenSCAD rendering of 34 cams..."

ls models/measured_parametric_single_v1/cam_*.scad | xargs -n 1 -P 4 -I {} bash -c '
  cam=$(basename "{}" .scad)
  if [ -f "stls/${cam}.stl" ]; then
    echo "Skipping $cam (already exists)"
  else
    echo "Rendering $cam..."
    ./openscad.AppImage -o stls/${cam}.stl "{}"
  fi
'

echo "All rendering complete!"
