#version 300 es

uniform mat4 u_mvpMatrix;
uniform vec2 u_offset;
uniform float u_percent;
uniform mat4 u_rotationMatrix;
uniform float u_transitionRatio;
uniform float u_event;

layout(location = 0) in vec4 a_position;
layout(location = 1) in vec2 a_texCoords;

out vec2 v_texCoords;

vec4 updatedPosition() {
    vec4 position = a_position;
    position = u_rotationMatrix * position;
    if (u_event == 0.f) {
        if (u_percent < u_transitionRatio) {
            position.xy += u_offset * (1.f - (u_percent / u_transitionRatio));
        }
    } else {
        position.xy += u_offset * u_percent;
    }
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}
