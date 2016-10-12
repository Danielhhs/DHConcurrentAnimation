#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform vec2 u_center;

layout(location = 0) in vec4 a_position;
layout(location = 1) in vec2 a_texCoords;

out vec2 v_texCoords;

const float c_big_scale = 5.f;

vec4 updatedPosition() {
    vec4 position = a_position;
    
    vec2 centerToPosition = position.xy - u_center;
    
    position.xy = u_center + length(centerToPosition) * (c_big_scale - (c_big_scale - 1.f) * u_percent) * normalize(centerToPosition);
//    position.xy = u_center + centerToPosition * u_percent;
    
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    v_texCoords = a_texCoords;
}
