import os
import json
import re
import math

N = 18
BASE_R = 18.55
THROW_R = 3.27

scad_dir = "models/measured_parametric_single_v1"
profiles_dir = os.path.join(scad_dir, "profiles")

def generate_stepped_points(values):
    pts = []
    N_local = len(values)
    step = 360.0 / N_local
    for i in range(N_local):
        a0 = (i / N_local) * math.pi * 2
        a1 = ((i + 1) / N_local) * math.pi * 2
        r = BASE_R + (values[i] / 3.0) * THROW_R
        offset = (step / 2.0) * (math.pi / 180.0)
        # We step inward by offset*0.3 to avoid exact colinearity which might break geometry
        pts.append((math.sin(a0 + offset * 0.3) * r, math.cos(a0 + offset * 0.3) * r))
        pts.append((math.sin(a1 - offset * 0.3) * r, math.cos(a1 - offset * 0.3) * r))
    return pts

def generate_smooth_points(values):
    pts = []
    N_local = len(values)
    # 2 degrees step for smooth curve
    for deg in range(0, 360, 2):
        fi = (deg / 360.0) * N_local
        i0 = int(math.floor(fi)) % N_local
        i1 = (i0 + 1) % N_local
        t = fi - math.floor(fi)
        
        # Smooth cosine interpolation
        t_smooth = (1 - math.cos(t * math.pi)) / 2
        v = values[i0] * (1 - t_smooth) + values[i1] * t_smooth
        
        r = BASE_R + (v / 3.0) * THROW_R
        angle = (deg / 180.0) * math.pi - math.pi / 2
        pts.append((math.sin(angle + math.pi/2) * r, math.cos(angle + math.pi/2) * r))
    return pts

def main():
    icons = {}
    for i in range(1, 35):
        cam = f"{i:02d}"
        scad_path = os.path.join(scad_dir, f"cam_{cam}.scad")
        if os.path.exists(scad_path):
            with open(scad_path, 'r') as f:
                content = f.read()
                m = re.search(r'icon_points\s*=\s*(\[.*?\]);', content)
                if m:
                    icons[cam] = m.group(1)

    for i in range(1, 35):
        cam = f"{i:02d}"
        json_path = os.path.join(profiles_dir, f"cam_{cam}_profile.json")
        if not os.path.exists(json_path):
            continue
        with open(json_path, 'r') as f:
            data = json.load(f)
        
        values = data['profile_values_nominal_0_3']
        surface_mode = data.get('surface_mode', 'smooth')
        name = data.get('name', 'Custom cam')
        status = data.get('status', 'candidate')
        
        if surface_mode == 'stepped':
            pts = generate_stepped_points(values)
        else:
            pts = generate_smooth_points(values)
            
        pts_str = ",\n".join([f"        [{x:.4f}, {y:.4f}]" for x, y in pts])
        icon_str = icons.get(cam, "[[-1,0.5],[0,0],[1,0.5]]")
        
        out_scad = f"""/*
  Elna Supermatic cam {cam}
  Name: {name}
  Status: {status}

  Generated from measured parametric base v2.
  Surface mode: {surface_mode}
*/

include <_elna_measured_common.scad>;

profile_points = [
{pts_str}
];

icon_points = {icon_str};

elna_single_cam(profile_points=profile_points, icon_points=icon_points, number_text="{cam}");
"""
        scad_path = os.path.join(scad_dir, f"cam_{cam}.scad")
        with open(scad_path, 'w') as f:
            f.write(out_scad)
    print("Regenerated all SCAD files.")

if __name__ == '__main__':
    main()
