#ifndef __VERTEX_BLEND_SAMPLE_INCLUDE__
#define __VERTEX_BLEND_SAMPLE_INCLUDE__

#include "VertexBlend.cginc"

float _VertexPositionBlend_Blend;
float _VertexPositionBlend_Variation;
float2 _VertexPositionBlend_UVBobbin;
			
float3 UVVariationalLocalPosition(uint vid, float2 uv, float3 localPos) {
    float b = LinearVariationalBlend(_VertexPositionBlend_Variation, _VertexPositionBlend_Blend, 
        frac(dot(uv, _VertexPositionBlend_UVBobbin)));
    return BlendLocalPosition(vid, localPos, b);
}

#endif