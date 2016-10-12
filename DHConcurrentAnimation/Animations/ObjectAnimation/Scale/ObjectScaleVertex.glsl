#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform vec2 u_center;

layout(location = 0) in vec4 a_position;
layout(location = 1) in vec2 a_texCoords;

out vec2 v_texCoords;

vec4 updatedPosition() {
    vec4 position = a_position;
    vec2 positionToCenter = position.xy - u_center;
    position.xy = u_center + positionToCenter * u_percent;
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}
