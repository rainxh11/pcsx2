//#version 420 // Keep it for editor detection

struct vertex_basic
{
    vec4 p;
    vec2 t;
};

in SHADER
{
    vec4 p;
    vec2 t;
} PSin;

#define PSin_p (PSin.p)
#define PSin_t (PSin.t)

#ifdef FRAGMENT_SHADER

layout(location = 0) out vec4 SV_Target0;

layout(std140, binding = 11) uniform cb11
{
    vec2 ZrH;
    float hH;
};

layout(binding = 0) uniform sampler2D TextureSampler;

// TODO ensure that clip (discard) is < 0 and not <= 0 ???
void ps_main0()
{
    if (fract(PSin_t.y * hH) - 0.5 < 0.0)
        discard;
    // I'm not sure it impact us but be safe to lookup texture before conditional if
    // see: http://www.opengl.org/wiki/GLSL_Sampler#Non-uniform_flow_control
    vec4 c = texture(TextureSampler, PSin_t);

    SV_Target0 = c;
}

void ps_main1()
{
    if (0.5 - fract(PSin_t.y * hH) < 0.0)
        discard;
    // I'm not sure it impact us but be safe to lookup texture before conditional if
    // see: http://www.opengl.org/wiki/GLSL_Sampler#Non-uniform_flow_control
    vec4 c = texture(TextureSampler, PSin_t);

    SV_Target0 = c;
}

void ps_main2()
{
    vec4 c0 = texture(TextureSampler, PSin_t - ZrH);
    vec4 c1 = texture(TextureSampler, PSin_t);
    vec4 c2 = texture(TextureSampler, PSin_t + ZrH);

    SV_Target0 = (c0 + c1 * 2.0f + c2) / 4.0f;
}

void ps_main3()
{
    SV_Target0 = texture(TextureSampler, PSin_t);
}

#endif
