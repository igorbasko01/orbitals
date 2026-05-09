#version 460 core
#include <flutter/runtime_effect.glsl>

uniform vec2 u_resolution;
uniform float u_time;
uniform vec4 u_water_color;
uniform vec4 u_land_color;

out vec4 fragColor;

vec2 hash(vec2 p) {
    p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
    return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(dot(hash(i + vec2(0.0, 0.0)), f - vec2(0.0, 0.0)),
                   dot(hash(i + vec2(1.0, 0.0)), f - vec2(1.0, 0.0)), u.x),
               mix(dot(hash(i + vec2(0.0, 1.0)), f - vec2(0.0, 1.0)),
                   dot(hash(i + vec2(1.0, 1.0)), f - vec2(1.0, 1.0)), u.x), u.y);
}

// Fractional Brownian Motion (layered noise for detail)
float fbm(vec2 p) {
    float f = 0.0;
    float amp = 0.5;
    for(int i = 0; i < 4; i++) {
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

void main() {
    // 1. Center the coordinates (-1.0 to 1.0)
    vec2 p = (FlutterFragCoord().xy / u_resolution) * 2.0 - 1.0;
    
    // 2. Calculate the distance from center
    float d = dot(p, p);
    
    // 3. Optional: mask it to a circle (if your widget isn't already a circle)
    if (d > 1.0) {
        discard; 
    }

    // 4. THE MAGIC: Calculate the 3D "Bulge" (Sphere math)
    float z = sqrt(1.0 - d);
    float x = atan(p.x, z) / 3.14159; // Map X to a sphere
    float y = p.y;                    // Keep Y linear

    // 5. Apply rotation
    vec2 moving_uv = vec2(x + u_time * 0.1, y);

    // 6. Generate noise
    float n = fbm(moving_uv * 4.0);
    n = n * 0.5 + 0.5;

    // ... color logic (same as before)
    if (n < 0.5) {
        fragColor = u_water_color;
    } else {
        fragColor = mix(u_land_color, vec4(0.1, 0.6, 0.2, 1.0), (n - 0.5) * 2.0);
    }
}
