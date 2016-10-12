#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_offset;
uniform float u_percent;

layout(location = 0) in vec4 a_position;
layout(location = 1) in vec2 a_texCoords;

out vec2 v_texCoords;

vec4 udpatedPosition() {
    vec4 position = a_position;
    
    position.y += u_offset * (1.f - u_percent);
    
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * udpatedPosition();
    v_texCoords = a_texCoords;
}
