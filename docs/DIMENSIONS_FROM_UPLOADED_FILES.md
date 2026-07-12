# Dimensions read from uploaded STL/SCAD

## Parsed STL / SCAD measurements

- SCAD object1Min: `[45.388, 55.498, 0.0]`
- SCAD object1Max: `[89.02, 97.731, 7.308]`
- SCAD extents: `[43.632, 42.233, 7.308] mm`

### ElnaSupermaticZizagCamWhole.stl

- vertices: `40482`
- min: `[45.388, 55.498, 0.0]`
- max: `[89.02, 97.731, 7.308]`
- extents: `[43.632, 42.233, 7.308]` mm
- bbox center: `[67.204, 76.615, 3.654]`
- max radius from bbox center: `22.043 mm`

### ElnaSupermaticZizagCam3NoBottomRing.stl

- vertices: `27402`
- min: `[50.725, 8.941, 0.0]`
- max: `[94.361, 51.742, 6.048]`
- extents: `[43.636, 42.801, 6.048]` mm
- bbox center: `[72.543, 30.342, 3.024]`
- max radius from bbox center: `22.044 mm`

## Dimensions used in patch 008

| Parameter | Value |
|---|---:|
| `overall_diameter_mm` | 43.640 mm |
| `overall_radius_mm` | 21.820 mm |
| `total_height_mm` | 7.308 mm |
| `body_top_height_mm` | 6.999 mm |
| `label_height_mm` | 0.309 mm |
| `lower_cam_lobe_height_mm` | 4.499 mm |
| `upper_round_body_radius_mm` | 18.550 mm |
| `functional_lobe_min_radius_mm` | 18.550 mm |
| `functional_lobe_max_radius_mm` | 21.820 mm |
| `functional_lobe_throw_mm` | 3.270 mm |
| `center_hole_radius_mm` | 8.250 mm |
| `center_counterbore_radius_mm` | 9.500 mm |
| `center_counterbore_height_mm` | 1.500 mm |
| `center_cone_height_mm` | 1.500 mm |
| `transport_slot_width_mm` | 3.000 mm |
| `transport_slot_length_mm` | 4.100 mm |
| `transport_slot_depth_mm` | 5.500 mm |
| `transport_slot_gap_from_counterbore_mm` | 1.000 mm |


## Design rule used

The model preserves fixed dimensions and holes. Only these elements are variable:
- lower functional cam edge,
- number,
- stitch pictogram.

## Important

The candidate cams preserve the correct measured base and style, but their functional edge is not factory-verified until compared with a real top-down photo or STL scan.
