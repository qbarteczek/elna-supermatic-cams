#!/usr/bin/env bash
set -euo pipefail

BASE_URL="https://raw.githubusercontent.com/ln-komandur/elna-cam-discs/master"
DEST="models/original"

mkdir -p "$DEST"

curl -L "$BASE_URL/Cam-as-18-Sided-Polygon.scad" -o "$DEST/Cam-as-18-Sided-Polygon.scad"
curl -L "$BASE_URL/Single%20Cam%20-%20No%2013.scad" -o "$DEST/Single Cam - No 13.scad"
curl -L "$BASE_URL/Single%20Cam%20-%20No%2016.scad" -o "$DEST/Single Cam - No 16.scad"
curl -L "$BASE_URL/Single%20Cam%20-%20No%2020.scad" -o "$DEST/Single Cam - No 20.scad"
curl -L "$BASE_URL/Single%20Cam%20-%20No%2033.scad" -o "$DEST/Single Cam - No 33.scad"
curl -L "$BASE_URL/Double%20Cam%20-%20No%20107.scad" -o "$DEST/Double Cam - No 107.scad"
curl -L "$BASE_URL/font.dxf" -o "$DEST/font.dxf"
curl -L "$BASE_URL/Elna%20Cam%20Dimensions.md" -o "$DEST/Elna Cam Dimensions.md"

echo "Imported source models into $DEST"
