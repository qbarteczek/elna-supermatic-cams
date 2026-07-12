#!/usr/bin/env python3
# Extract an approximate 18-position Elna cam profile from a photo.
# This is a helper, not a validator. Always verify orientation manually.

from __future__ import annotations

import argparse
import json
from pathlib import Path

import cv2
import numpy as np

TOKENS = [
    ("l", 0.00),
    ("cl", 0.75),
    ("c", 1.50),
    ("cr", 2.25),
    ("r", 3.00),
]

def quantize(value: float) -> str:
    return min(TOKENS, key=lambda item: abs(item[1] - value))[0]

def parse_crop(value: str) -> tuple[int, int, int, int]:
    parts = [int(x) for x in value.split(",")]
    if len(parts) != 4:
        raise argparse.ArgumentTypeError("Crop must be x,y,w,h")
    return parts[0], parts[1], parts[2], parts[3]

def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("image", help="Input photo")
    parser.add_argument("--out", default=None, help="Output JSON path")
    parser.add_argument("--cam", default="unknown", help="Cam number")
    parser.add_argument("--invert", action="store_true", help="Invert threshold")
    parser.add_argument("--rotate-steps", type=int, default=0, help="Rotate profile by 18-position steps")
    parser.add_argument("--crop", type=parse_crop, help="Crop x,y,w,h before processing")
    parser.add_argument("--debug-image", help="Optional debug image with contour")
    args = parser.parse_args()

    img_path = Path(args.image)
    img = cv2.imread(str(img_path))
    if img is None:
        raise SystemExit(f"Cannot read image: {img_path}")

    if args.crop:
        x, y, w, h = args.crop
        img = img[y:y+h, x:x+w]

    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    gray = cv2.GaussianBlur(gray, (7, 7), 0)

    threshold_type = cv2.THRESH_BINARY_INV if args.invert else cv2.THRESH_BINARY
    _, bw = cv2.threshold(gray, 0, 255, threshold_type + cv2.THRESH_OTSU)

    kernel = np.ones((5, 5), np.uint8)
    bw = cv2.morphologyEx(bw, cv2.MORPH_CLOSE, kernel, iterations=2)
    bw = cv2.morphologyEx(bw, cv2.MORPH_OPEN, kernel, iterations=1)

    contours, _ = cv2.findContours(bw, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
    if not contours:
        raise SystemExit("No contour found")

    contour = max(contours, key=cv2.contourArea)
    if cv2.contourArea(contour) < 500:
        raise SystemExit("Contour too small; use better crop/photo")

    m = cv2.moments(contour)
    if abs(m["m00"]) < 1e-9:
        raise SystemExit("Invalid contour moments")

    cx = m["m10"] / m["m00"]
    cy = m["m01"] / m["m00"]

    pts = contour.reshape(-1, 2).astype(float)
    dx = pts[:, 0] - cx
    dy = cy - pts[:, 1]
    angles = (np.degrees(np.arctan2(dx, dy)) + 360.0) % 360.0
    radii = np.sqrt(dx * dx + dy * dy)

    sampled = []
    for i in range(18):
        center_angle = i * 20.0
        delta = np.abs(((angles - center_angle + 180.0) % 360.0) - 180.0)
        mask = delta <= 5.5
        if not np.any(mask):
            idx = int(np.argmin(delta))
            sampled.append(float(radii[idx]))
        else:
            sampled.append(float(np.percentile(radii[mask], 95)))

    r_min = min(sampled)
    r_max = max(sampled)
    normalized = [0.0 if abs(r_max - r_min) < 1e-6 else 3.0 * (r - r_min) / (r_max - r_min) for r in sampled]
    tokens = [quantize(v) for v in normalized]

    if args.rotate_steps:
        shift = args.rotate_steps % 18
        tokens = tokens[-shift:] + tokens[:-shift]
        normalized = normalized[-shift:] + normalized[:-shift]

    result = {
        "cam": str(args.cam),
        "type": "single",
        "source_image": str(img_path),
        "method": "photo-contour-18-sector",
        "warning": "Raw extraction. Manually verify orientation, scale and tokens before generating a printable cam.",
        "profile_tokens": tokens,
        "profile_values": [round(float(x), 3) for x in normalized],
    }

    out_path = Path(args.out) if args.out else img_path.with_suffix(".profile.json")
    out_path.write_text(json.dumps(result, indent=2, ensure_ascii=False), encoding="utf-8")

    if args.debug_image:
        dbg = img.copy()
        cv2.drawContours(dbg, [contour.astype(np.int32)], -1, (0, 255, 0), 2)
        cv2.circle(dbg, (int(cx), int(cy)), 4, (0, 0, 255), -1)
        cv2.imwrite(args.debug_image, dbg)

    print(f"Wrote {out_path}")
    print("Profile:", ",".join(tokens))

if __name__ == "__main__":
    main()
