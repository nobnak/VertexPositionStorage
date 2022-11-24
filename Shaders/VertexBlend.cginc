#ifndef __VERTEX_BLEND_CGINC__
#define __VERTEX_BLEND_CGINC__

#include "UnityCG.cginc"



#ifdef SHADER_API_D3D11
StructuredBuffer<float3> _VertexPositionBlend_VertexPositions;
#endif
float4 _VertexPositionBlend_WorldPivot;

float _VertexPositionBlend_Blend;
float _VertexPositionBlend_Variation;
float2 _VertexPositionBlend_UVBobbin;

static const float4x4 IDENTITY_MATRIX = { 
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
};



#define VERTEX_BLEND_FUNC(v, b, x) saturate(v * (x + b - 1.0) + b)

float LinearVariationalBlend(float variation, float blendRatio, float x) {
    return VERTEX_BLEND_FUNC(variation, blendRatio, x);
}
float3 GetTargetWorldPosition(uint vertexIndex) {
    #ifdef SHADER_API_D3D11
    return _VertexPositionBlend_VertexPositions[vertexIndex];
    #else
    return 0;
    #endif
}
float3 BlendPosition(uint vertexIndex, float3 srcPos, float blendRatio) {
    #ifdef SHADER_API_D3D11
    float3 dstPos = GetTargetWorldPosition(vertexIndex);
    srcPos = lerp(srcPos, dstPos, blendRatio);
    #endif
    return srcPos;
}



float UVVariationalBlend(float2 uv) {
    return LinearVariationalBlend(_VertexPositionBlend_Variation, _VertexPositionBlend_Blend, 
        frac(dot(uv, _VertexPositionBlend_UVBobbin)));
}


#endif