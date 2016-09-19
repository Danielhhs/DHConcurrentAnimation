#version 300 es

uniform mat4 u_mvpMatrix;
uniform vec2 u_offset;
uniform float u_percent;
uniform mat4 u_rotationMatrix;
uniform float u_transitionRatio;

layout(location = 0) in vec4 a_position;
layout(location = 1) in vec2 a_texCoords;

out vec2 v_texCoords;

vec4 updatedPosition() {
    vec4 position = a_position;
    position = u_rotationMatrix * position;
    if (u_percent < u_transitionRatio) {
        position.xy += u_offset * (1.f - (u_percent / u_transitionRatio));
    }
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}