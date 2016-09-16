#version 300 es

uniform mat4 u_mvpMatrix;
uniform vec2 u_offset;

layout(location = 0) in vec4 a_position;
layout(location = 1) in vec2 a_texCoords;

out vec2 v_texCoords;

vec4 updatedPosition() {
    vec4 position = a_position;
    position.xy += u_offset;
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}