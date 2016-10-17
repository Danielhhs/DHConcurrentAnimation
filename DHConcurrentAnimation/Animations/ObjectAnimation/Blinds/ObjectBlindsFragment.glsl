#version 300 es

precision highp float;

uniform sampler2D s_tex;

in vec2 v_texCoords;
in vec3 v_normal;

layout(location = 0) out vec4 out_color;

const vec3 c_light = vec3(0.f, 0.f, 1.f);

void main() {
    out_color = texture(s_tex, v_texCoords);
    if (out_color.a < 0.05) {
        discard;
    } else {
        float alpha = dot(v_normal, c_light);
        out_color.rgb *= alpha;
    }
}
