#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform float u_elapsedTime;

layout(location = 0) in vec4 a_position;
layout(location = 1) in vec3 a_targetPosition;
layout(location = 2) in float a_originalSize;
layout(location = 3) in float a_targetSize;
layout(location = 4) in float a_rotation;
layout(location = 5) in float a_lifeTime;

out mat4 v_rotationMat;

float updatedY() {
    float f = 1.f*(u_elapsedTime /= a_lifeTime) * u_elapsedTime * u_elapsedTime;
    float y = a_position.y + f * (a_targetPosition.y - a_position.y);
    return y;
}

vec4 updatedPosition()
{
    vec4 position = a_position;
    position.xyz += (a_targetPosition - a_position.xyz) * u_percent;
    position.y = updatedY();
    return position;
}

void main() {
    gl_Position = u_mvpMatrix * updatedPosition();
    gl_PointSize = a_originalSize + (a_targetSize - a_originalSize) * u_percent;
    float a_angle = a_rotation * u_percent;
    float cosA = cos(a_angle);
    float sinA = sin(a_angle);
    mat4 transInMat = mat4(1.0, 0.0, 0.0, 0.0,
                           0.0, 1.0, 0.0, 0.0,
                           0.0, 0.0, 1.0, 0.0,
                           0.5, 0.5, 0.0, 1.0);
    mat4 rotMat = mat4(cosA, -sinA, 0.0, 0.0,
                       sinA, cosA, 0.0, 0.0,
                       0.0, 0.0, 1.0, 0.0,
                       0.0, 0.0, 0.0, 1.0);
    
    mat4 resultMat = transInMat * rotMat;
    resultMat[3][0] = resultMat[3][0] + resultMat[0][0] * -0.5 + resultMat[1][0] * -0.5;
    resultMat[3][1] = resultMat[3][1] + resultMat[0][1] * -0.5 + resultMat[1][1] * -0.5;
    resultMat[3][2] = resultMat[3][2] + resultMat[0][2] * -0.5 + resultMat[1][2] * -0.5;
    v_rotationMat = resultMat;
    if (u_percent <= 0.f) {
        gl_PointSize = 0.f;
    }
}
