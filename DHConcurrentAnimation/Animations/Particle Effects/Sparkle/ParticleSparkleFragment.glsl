#version 300 es

precision highp float;

uniform sampler2D s_tex;

layout(location = 0) out vec4 out_color;

void main() {
    out_color = texture(s_tex, gl_PointCoord.xy);
    if (out_color.a < 0.1) {
        discard;
    }
}
