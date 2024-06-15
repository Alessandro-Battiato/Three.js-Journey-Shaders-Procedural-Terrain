#include ../includes/simplexNoise2d.glsl

float getElevation(vec2 position) {
    float uPositionFrequency = 0.2;

    float elevation = 0.0;
    elevation += simplexNoise2d(position * uPositionFrequency) / 2.0;
    elevation += simplexNoise2d(position * uPositionFrequency * 2.0) / 4.0;
    elevation += simplexNoise2d(position * uPositionFrequency * 4.0) / 8.0;

    float elevationSign = sign(elevation);
    elevation = pow(abs(elevation), 2.0) * elevationSign; // the abs fixes the issue where, if instead of 2.0 an odd number was given, then the "Holes" on the terrain which will soon have the water would disappear

    return elevation;
}

void main() {
    // Neighbours positions
    float shift = 0.01;
    vec3 positionA = position + vec3(shift, 0.0, 0.0);
    vec3 positionB = position + vec3(0.0, 0.0, - shift);

    // Elevation
    float elevation = getElevation(csm_Position.xz);
    csm_Position.y += elevation;
    positionA.y = getElevation(positionA.xz);
    positionB.y = getElevation(positionB.xz);

    // Compute normal
    vec3 toA = normalize(positionA - csm_Position);
    vec3 toB = normalize(positionB - csm_Position);
    csm_Normal = cross(toA, toB);
}