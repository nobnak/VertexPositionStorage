#ifndef __VERTEX_BLEND_SAMPLE_INCLUDE__
#define __VERTEX_BLEND_SAMPLE_INCLUDE__

#include "VertexBlend.cginc"

float _PositionBlend;
float _Variation;
float2 _UVBobbin;
			
float3 UVVariationalLocalPosition(uint vid, float2 uv, float3 localPos) {
    float b = LinearVariationalBlend(_Variation, _PositionBlend, frac(dot(uv, _UVBobbin)));
    return BlendLocalPosition(vid, localPos, b);
}

#endif